class AddParentToEntries < ActiveRecord::Migration[7.0]
  def change
    change_table :entries do |t|
      t.references :parent, null: true, index: true, foreign_key: { to_table: :entries }
    end
  end
end
