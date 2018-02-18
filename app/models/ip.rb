class Ip < ApplicationRecord
  self.primary_key = 'address'

  has_many :connections
  has_many :users, through: :connections

  has_many :posts
end
