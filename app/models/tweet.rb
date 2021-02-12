class Tweet < ApplicationRecord
  include Entryable

  has_rich_text :content

  validates :content, presence: true
  validate -> { errors.add(:content, :too_long, { count: 280 }) if content.to_plain_text.length > 280 }
end
