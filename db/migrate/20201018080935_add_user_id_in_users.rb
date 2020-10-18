class AddUserIdInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :unique_user_id, :string
  end
end
