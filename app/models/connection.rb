class Connection < ApplicationRecord
  belongs_to :ip, foreign_key: :ip_address
  belongs_to :user
end
