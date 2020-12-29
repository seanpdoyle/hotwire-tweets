class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Tweet ], dependent: :destroy

  belongs_to :creator, class_name: "User"

  scope :newest_to_oldest, -> { order created_at: :desc }

  delegate_missing_to :entryable
end
