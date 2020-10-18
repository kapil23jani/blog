class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
    	t.string :amount
    	t.string :invoice_pdf
    	t.string :invoice_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
