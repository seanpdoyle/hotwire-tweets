class Tweet < ApplicationRecord
  validates :content, presence: true
end
