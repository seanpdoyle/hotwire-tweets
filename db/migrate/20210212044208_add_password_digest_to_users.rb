class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.text :password_digest, null: false
    end
  end
end
