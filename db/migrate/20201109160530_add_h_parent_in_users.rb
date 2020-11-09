class AddHParentInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :h_parent, :integer
  end
end
