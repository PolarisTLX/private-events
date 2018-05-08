class User < ApplicationRecord

  validates :name, presence: true, length: {minimum: 4, maximum: 25 }
  validates :password, presence: true, length: {minimum: 8, maximum: 25 }, allow_nil: true
  # validates :password, presence: true, length: {minimum: 8, maximum: 25 }
  has_secure_password  # this takes care of checking the password_confirmation

end
