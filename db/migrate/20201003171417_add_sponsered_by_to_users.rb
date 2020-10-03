class AddSponseredByToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_reference :users, :sponsered_by, index: true
  end
end
