class User < ApplicationRecord

  attr_accessor :remember_token

  has_many :hosted_events, foreign_key: :host_id, class_name: 'Event', dependent: :destroy
  has_many :invites, foreign_key: :attendee_id, dependent: :destroy
  has_many :attended_events, through: :invites


  validates :name, presence: true, length: {minimum: 4, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: {minimum: 8, maximum: 25 }, allow_nil: true
  # validates :password, presence: true, length: {minimum: 8, maximum: 25 }
  has_secure_password  # this takes care of checking the password_confirmation


  # Needed for the "Remember Me" box feature:

  #to store a secure "remember_token" that can't be viewed
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?     BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  # this creates the remember_token that gets stored in the cookie and in the database user table
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # this is the method to call the above method User.new_token
  def remember
    self.remember_token = User.new_token
    # place the token in the database
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # when a user logs out
  def forget
    update_attribute(:remember_digest, nil)
  end

  # verify if the remember_token exists & matches the database
  def authenticated?(remember_token)
    # checks if the token exists:
    return false if remember_digest.nil?
    # if exists, check if it matches the database:
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # NOTE! REMEMBER THAT AT THIS POINT FOR REMEMBER TOKEN TO WORK YOU NEED TO ADD A NEW COLUM TO THE DATABASE USER TABLE.
  # THIS INVOLVES TYPING INTO TERMINAL:
  # rails generate migration add_remember_digest_to_users remember_digest:string

  #then:  rails db:migrate

end
