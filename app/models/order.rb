class Order < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "id", "id_value", "order_date", "total_amount", "updated_at"]
  end
end
