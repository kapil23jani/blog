class IsFirstPairValidInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :is_first_pair_valid, :boolean
  end
end
