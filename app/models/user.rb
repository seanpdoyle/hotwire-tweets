class User < ApplicationRecord
  has_secure_password

  has_many :entries, foreign_key: :creator_id
  has_many :subscriptions, through: :entries, source: :entryable, source_type: "Subscription"
  has_many :publishers, -> { merge(Entry.not_trashed) }, through: :subscriptions, source: :publisher

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
