class Mention < ApplicationRecord
  include Entryable

  belongs_to :user
end
