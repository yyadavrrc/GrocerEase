class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :gst
      t.decimal :hst
      t.decimal :pst

      t.timestamps
    end
  end
end
