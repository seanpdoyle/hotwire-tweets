class Tweet < ApplicationRecord
  include Entryable

  has_rich_text :content

  scope :containing, ->(query) { joins(:rich_text_content).merge(ActionText::RichText.with_body_containing(query)) }

  validates :content, presence: true
  validate -> { errors.add(:content, :too_long, { count: 280 }) if content.to_plain_text.length > 280 }

  def mentioned_users
    User.where(username: mentioned_usernames)
  end

  def mentioned_usernames
    content.to_plain_text.scan(/(?<!\w)@(\w+)/).uniq(&:downcase)
  end
end
