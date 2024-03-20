# Require faker gem
require 'faker'

# db/seeds.rb

# Delete all existing records
OrderDetail.delete_all
Order.delete_all
Product.delete_all
Category.delete_all
Customer.delete_all


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

# Seed orders with order details
5.times do
  customer = Customer.all.sample
  order = Order.create(
    customer: customer,
    order_date: Faker::Time.backward(days: 30),
    total_amount: 0
  )
  order_details_count = Faker::Number.between(from: 1, to: 5)
  order_details_count.times do
    product = Product.all.sample
    quantity = Faker::Number.between(from: 1, to: 10)
    unit_price = product.price
    order_detail = OrderDetail.create(
      order: order,
      product: product,
      quantity: quantity,
      unit_price: unit_price
    )
    order.total_amount += quantity * unit_price
  end
  order.save
end
