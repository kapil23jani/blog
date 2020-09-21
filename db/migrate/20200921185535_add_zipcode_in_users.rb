class AddZipcodeInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :zipcode, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :country, :string
  end
end
