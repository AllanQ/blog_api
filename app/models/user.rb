class User < ApplicationRecord
  has_many :connections
  has_many :ips, through: :connections

  has_many :posts
end
