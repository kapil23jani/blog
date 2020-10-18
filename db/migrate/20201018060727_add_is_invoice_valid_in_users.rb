class AddIsInvoiceValidInUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :is_invoice_valid, :boolean
  end
end
