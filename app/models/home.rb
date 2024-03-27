class Home < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "heading", "id", "id_value", "message", "updated_at"]
  end
end
