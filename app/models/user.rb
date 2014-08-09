class User < ActiveRecord::Base
  # all lowercase emails
  before_save { self.email = email.downcase }

  # simple presence and length
  validates :name, presence: true, length: { maximum: 50 }

  # little more complex withpresence, ruby regex format
  # and finally, uniqueness!
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {  case_sensitive: false }

  has_secure_password
  validates :password, length: {  minimum: 6 }

  #   has_secure_password implements:
  #   :password and :password_confirmation init params
  #   validate: present and both match
  #   find user by email address, match pw to digest, return user or false
end
