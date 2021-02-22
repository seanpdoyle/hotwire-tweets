class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Tweet Retweet Subscription Mention ], dependent: :destroy

  belongs_to :creator, class_name: "User"
  belongs_to :parent, class_name: "Entry", optional: true, touch: true

  has_many :children, class_name: "Entry", foreign_key: :parent_id
  has_many :publishings, through: :creator
  has_many :subscribers, through: :publishings

  scope :root, -> { where parent: nil }
  scope :activities, -> { retweets.or root.tweets }
  scope :newest_to_oldest, -> { order created_at: :desc }
  scope :replies, -> { tweets.where.not parent: nil }
  scope :trashed, -> { where.not trashed_at: nil }
  scope :not_trashed, -> { where trashed_at: nil }
  scope :containing, ->(query) { tweets.where(entryable_id: Tweet.containing(query)) }

  after_create -> { MentionsJob.perform_now self }, if: :tweet?
  after_create -> { broadcast_prepend_later_to creator, :entries }, if: :public?
  after_create -> { broadcast_prepend_later_to parent, :entries }, if: :reply?
  after_create -> { subscribers.each { |subscriber| broadcast_prepend_later_to subscriber, :entries } }, if: :public?
  after_create -> { broadcast_prepend_later_to parent.creator, :notifications, target: :notifications, partial: "entries/notification" }, if: :retweet?
  after_create -> { broadcast_prepend_later_to parent.creator, :notifications, target: :notifications, partial: "entries/notification" }, if: :reply?
  after_create -> { broadcast_prepend_later_to mention.user, :notifications, target: :notifications, partial: "entries/notification" }, if: :mention?
  after_create -> { broadcast_prepend_later_to subscription.publisher, :notifications, target: :notifications, partial: "entries/notification" }, if: :subscription?

  after_update -> { broadcast_remove_to creator, :entries }, if: :trashed?
  after_update -> { broadcast_remove_to parent, :entries }, if: :trashed?
  after_update -> { subscribers.each { |subscriber| broadcast_remove_to subscriber, :entries } }, if: :trashed?

  delegate_missing_to :entryable

  def self.enter!(entryable, creator: Current.user, **attributes)
    transaction do
      entryable.save!
      creator.entries.create! entryable: entryable, **attributes
    end
  end

  def trashed!
    update! trashed_at: Time.current
  end

  def trashed?
    trashed_at.present?
  end

  def reply?
    parent&.tweet? && tweet?
  end

  def public?
    return false if reply?

    tweet? || retweet?
  end
end
