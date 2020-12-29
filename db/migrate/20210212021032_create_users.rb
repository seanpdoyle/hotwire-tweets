class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension "citext"
    create_table :users do |t|
      t.citext :username, null: false

      t.timestamps

      t.index :username, unique: true
    end

    change_table :entries do |t|
      t.references :creator, null: false, index: true, foreign_key: { to_table: :users }
    end
  end
end
