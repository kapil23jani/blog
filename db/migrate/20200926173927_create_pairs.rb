class CreatePairs < ActiveRecord::Migration[6.0]
  def change
    create_table :pairs do |t|
      t.timestamps
      t.references :left_user, references: :user, null: true
      t.references :right_user, references: :user, null: true
      t.references :user
    end
  end
end
