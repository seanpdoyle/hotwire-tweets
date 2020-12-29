class User < ApplicationRecord
  has_many :entries, foreign_key: :creator_id
end
