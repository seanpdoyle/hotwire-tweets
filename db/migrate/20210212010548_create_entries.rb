class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :entryable, null: false, polymorphic: true, index: true

      t.timestamps
    end
  end
end
