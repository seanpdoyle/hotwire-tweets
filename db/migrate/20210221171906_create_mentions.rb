class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :user, null: false, index: true, foreign_key: true
    end
  end
end
