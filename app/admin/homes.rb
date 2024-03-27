# app/admin/home.rb

ActiveAdmin.register Home do
  permit_params :heading, :message
end
