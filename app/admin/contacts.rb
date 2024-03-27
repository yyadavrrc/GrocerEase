# app/admin/contact.rb

ActiveAdmin.register Contact do
  permit_params :email, :phone
end
