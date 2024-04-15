class AddGstPstHstToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :gst, :decimal
    add_column :invoices, :pst, :decimal
    add_column :invoices, :hst, :decimal
  end
end
