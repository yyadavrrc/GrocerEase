class AddProvinceIdAndAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :province_id, :integer
    add_column :users, :address, :string
  end
end
