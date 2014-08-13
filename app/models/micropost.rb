class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order("created_at DESC") }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by(user)
    # this was auto-method from :followed_users, but we're going direct SQL
    followed_user_ids = 'SELECT user_id FROM relationships WHERE follower_id = :user_id'
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end

end
