class Connection < ApplicationRecord
  self.primary_keys = :user_id,:ip_address

  belongs_to :user
end
