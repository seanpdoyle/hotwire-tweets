class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false, index: true, foreign_key: { to_table: :users }
      t.references :publisher, null: false, index: true, foreign_key: { to_table: :users }

      t.index [:subscriber_id, :publisher_id], unique: true
      t.check_constraint "subscriber_id != publisher_id", name: "self_subscription_check"
    end
  end
end
