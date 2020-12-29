class Tweet < ApplicationRecord
  include Entryable

  has_rich_text :content
end
