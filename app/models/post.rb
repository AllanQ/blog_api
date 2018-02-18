class Post < ApplicationRecord
  belongs_to :user
  belongs_to :ip, foreign_key: :ip_address
end
