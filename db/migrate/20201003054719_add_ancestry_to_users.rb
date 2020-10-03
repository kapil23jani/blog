class AddAncestryToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ancestry, :integer
    add_index :users, :ancestry
  end
end
