class AddInvoiceNumberInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :invoice_number, :string
  end
end
