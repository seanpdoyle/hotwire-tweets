class User < ApplicationRecord
  has_secure_password

  has_many :entries, foreign_key: :creator_id
end
