class AddSubscriptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_id, :integer
    add_column :users, :customer_id, :string
  end
end
