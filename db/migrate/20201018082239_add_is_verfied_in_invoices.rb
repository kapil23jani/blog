class AddIsVerfiedInInvoices < ActiveRecord::Migration[6.0]
  def change
  	add_column :invoices, :is_invoice_valid, :boolean
  end
end
