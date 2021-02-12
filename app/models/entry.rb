class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Tweet ], dependent: :destroy

  belongs_to :creator, class_name: "User"

  scope :newest_to_oldest, -> { order created_at: :desc }
  scope :trashed, -> { where.not trashed_at: nil }
  scope :not_trashed, -> { where trashed_at: nil }

  delegate_missing_to :entryable

  def self.enter!(entryable, creator: Current.user)
    transaction do
      entryable.save!
      creator.entries.create! entryable: entryable
    end
  end

  def trashed!
    update! trashed_at: Time.current
  end

  def trashed?
    trashed_at.present?
  end
end
