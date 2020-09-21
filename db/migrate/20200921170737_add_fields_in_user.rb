class AddFieldsInUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :dob, :string
  	add_column :users, :sponser_id, :string
  	add_column :users, :position, :string
  	add_column :users, :address, :string
  	add_column :users, :country_code, :string
  	add_column :users, :phone_number, :string
  	add_column :users, :pan_number, :string
  	add_column :users, :gender, :string
  end
end
