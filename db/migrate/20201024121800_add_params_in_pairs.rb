class AddParamsInPairs < ActiveRecord::Migration[6.0]
  def change
  	add_column :pairs, :is_left_verified, :boolean
  	add_column :pairs, :is_right_verified, :boolean
  end
end
