class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Tweet Retweet ], dependent: :destroy

  belongs_to :creator, class_name: "User"
  belongs_to :parent, class_name: "Entry", optional: true, touch: true

  has_many :children, class_name: "Entry", foreign_key: :parent_id

  scope :root, -> { where parent: nil }
  scope :activities, -> { retweets.or root.tweets }
  scope :newest_to_oldest, -> { order created_at: :desc }
  scope :replies, -> { tweets.where.not parent: nil }
  scope :trashed, -> { where.not trashed_at: nil }
  scope :not_trashed, -> { where trashed_at: nil }

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
end
