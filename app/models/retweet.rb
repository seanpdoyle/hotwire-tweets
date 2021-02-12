class Retweet < ApplicationRecord
  include Entryable

  belongs_to :tweet
end
