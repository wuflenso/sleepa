class AddFollowerTableIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :followers, [:user_id, :follower_user_id, :is_active, :followed_at], order: { followed_at: :desc }
    add_index :followers, [:follower_user_id, :is_active, :followed_at], order: { followed_at: :desc }
  end
end
