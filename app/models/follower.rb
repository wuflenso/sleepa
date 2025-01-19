class Follower < ApplicationRecord
  belongs_to :user

  class << self
    def get_followers(user_id)
      self.where(user_id: user_id).where(is_active: true)&.order(followed_at: "desc")
    end

    def get_user_followings(follower_user_id)
      self.where(follower_user_id: follower_user_id).where(is_active: true)&.order(followed_at: "desc")
    end

    def follow(followed_user_id, follower_user_id)
      unless get_follower_detail(followed_user_id, follower_user_id).nil?
        raise StandardError.new("user already followed")
      end

      follower = Follower.new(user_id: followed_user_id, follower_user_id: follower_user_id)
      follower.is_active = true
      follower.followed_at = Time.current
      follower.save!
      follower
    end
  end

  def unfollow
    self.is_active = false
    self.save!
  end
end
