ActiveAdmin.register Order do
  permit_params :total_amount, :customer_id

  index do
    selectable_column
    id_column
    column :total_amount
    column :customer_id
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :total_amount
      f.input :customer_id
    end
    f.actions
  end
end