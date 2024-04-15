# Require faker gem
require 'faker'

Product.delete_all
Category.delete_all


# Seed customers
10.times do
  Customer.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number
  )
end

# Seed categories
15.times do
  Category.create(
    name: Faker::Commerce.department(max: 1)
  )
end

# Seed products with categories
100.times do
  product = Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 0..100.0),
    stock_quantity: Faker::Number.between(from: 1, to: 100),
    category: Category.all.sample
  )
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Iterate over each province and update the taxes
Province.all.each do |province|
  case province.name
  when 'Alberta'
    province.update(gst: 5, hst: 0, pst: 0)
  when 'British Columbia'
    province.update(gst: 5, hst: 0, pst: 7)
  when 'Manitoba'
    province.update(gst: 5, hst: 0, pst: 7)
  when 'New Brunswick'
    province.update(gst: 5, hst: 0, pst: 10)
  when 'Newfoundland and Labrador'
    province.update(gst: 5, hst: 0, pst: 10)
  when 'Northwest Territories'
    province.update(gst: 5, hst: 0, pst: 0)
  when 'Nova Scotia'
    province.update(gst: 5, hst: 0, pst: 10)
  when 'Nunavut'
    province.update(gst: 5, hst: 0, pst: 0)
  when 'Ontario'
    province.update(gst: 5, hst: 13, pst: 0)
  when 'Prince Edward Island'
    province.update(gst: 5, hst: 0, pst: 10)
  when 'Quebec'
    province.update(gst: 5, hst: 0, pst: 9.975)
  when 'Saskatchewan'
    province.update(gst: 5, hst: 0, pst: 6)
  when 'Yukon'
    province.update(gst: 5, hst: 0, pst: 0)
  else
    # Handle other provinces if needed
  end
end
