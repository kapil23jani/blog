class AddUpiIdInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :upi_id, :string
  end
end
