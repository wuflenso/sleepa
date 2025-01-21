class Follower < ApplicationRecord
  belongs_to :user

  CACHE_PREFIX_USER_FOLLOWINGS = "class_followers-followings-user_id:".freeze
  CACHE_EXPIRY_USER_FOLLOWINGS = 1.day
  CACHE_PREFIX_USER_FOLLOWINGS_USER_IDS_ONLY = "class_followers-followings_user_ids-user_id:".freeze
  CACHE_EXPIRY_USER_FOLLOWINGS_USER_IDS_ONLY = 1.day
  CACHE_PREFIX_USER_FOLLOWERS = "class_followers-followers-user_id:".freeze
  CACHE_EXPIRY_USER_FOLLOWERS = 1.day

  validates :user_id, presence: true
  validates :follower_user_id, presence: true
  validates :follower_user_id, comparison: { other_than: :user_id }

  after_save :invalidate_cache

  class << self
    def get_followers(user_id)
      Rails.cache.fetch("#{CACHE_PREFIX_USER_FOLLOWERS}#{user_id}", expires_in: CACHE_EXPIRY_USER_FOLLOWERS) do
        self.where(user_id: user_id).where(is_active: true)&.order(followed_at: "desc")
      end
    end

    def get_user_followings(follower_user_id)
      Rails.cache.fetch("#{CACHE_PREFIX_USER_FOLLOWINGS}#{follower_user_id}", expires_in: CACHE_EXPIRY_USER_FOLLOWINGS) do
        followings = self.where(follower_user_id: follower_user_id).where(is_active: true)&.order(followed_at: "desc")

        Rails.cache.write("#{CACHE_PREFIX_USER_FOLLOWINGS_USER_IDS_ONLY}#{follower_user_id}", followings.pluck(:user_id), expires_in: CACHE_EXPIRY_USER_FOLLOWINGS_USER_IDS_ONLY)
        followings
      end
    end

    def get_followings_user_ids(follower_user_id)
      Rails.cache.fetch("#{CACHE_PREFIX_USER_FOLLOWINGS_USER_IDS_ONLY}#{follower_user_id}", expires_in: CACHE_EXPIRY_USER_FOLLOWINGS_USER_IDS_ONLY) do
        self.where(follower_user_id: follower_user_id).where(is_active: true)&.order(followed_at: "desc").pluck(:user_id)
      end
    end

    def get_follower_details(followed_user_id, follower_user_id)
      self.where(user_id: followed_user_id).where(follower_user_id: follower_user_id).where(is_active: true).first
    end

    def follow(followed_user_id, follower_user_id)
      unless self.get_follower_details(followed_user_id, follower_user_id).nil?
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
    self
  end

  def invalidate_cache
    # maybe a transaction is better
    Rails.cache.delete("#{CACHE_PREFIX_USER_FOLLOWERS}#{self.user_id}")
    Rails.cache.delete("#{CACHE_PREFIX_USER_FOLLOWINGS}#{self.follower_user_id}")
    Rails.cache.delete("#{CACHE_EXPIRY_USER_FOLLOWINGS_USER_IDS_ONLY}#{self.follower_user_id}")
  end
end
