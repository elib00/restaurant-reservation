class User < ApplicationRecord
  has_secure_password

  enum role: { customer: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
