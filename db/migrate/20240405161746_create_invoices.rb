class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :customer_id
      t.decimal :total_amount

      t.timestamps
    end
  end
end
