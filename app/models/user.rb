class User < ApplicationRecord
  has_secure_password

  has_many :entries, foreign_key: :creator_id
  has_many :subscriptions, through: :entries, source: :entryable, source_type: "Subscription"
  has_many :publishers, -> { merge(Entry.not_trashed) }, through: :subscriptions, source: :publisher
  has_many :publishings, class_name: "Subscription", foreign_key: :publisher_id
  has_many :followings, -> { not_trashed }, through: :publishings, source: :entry
  has_many :mentions
  has_many :mentionings, through: :mentions, source: :entry

  def notifications
    Entry.
      where.not(creator: self).
      where(parent: entries.tweets).
      or(Entry.where(id: followings)).
      or(Entry.where(id: mentionings)).
      newest_to_oldest
  end

  def subscribe_to(user)
    subscription = Subscription.new publisher: user, subscriber: self

    Entry.enter! subscription, creator: self
  rescue ActiveRecord::RecordNotUnique
    # no-op
  end

  def unsubscribe_from(user)
    subscriptions = Subscription.where publisher: user, subscriber: self

    Entry.subscriptions.where(entryable_id: subscriptions).each(&:trashed!)
  end
end
