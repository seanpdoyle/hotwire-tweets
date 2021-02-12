class AddTrashedAtToEntries < ActiveRecord::Migration[7.0]
  change_table :entries do |t|
    t.timestamp :trashed_at, null: true, index: true
  end
end
