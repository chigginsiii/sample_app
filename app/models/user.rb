class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed # source = what we're aliasing with 'followed_users'
  has_many :reverse_relationships, foreign_key: :followed_id, class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # all lowercase emails
  before_save { self.email = email.downcase }
  before_create :create_remember_token
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

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  private

    def email_down(email)
      self.email = email.downcase
    end

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
