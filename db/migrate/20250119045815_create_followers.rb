class CreateFollowers < ActiveRecord::Migration[8.0]
  def change
    create_table :followers do |t|
      t.bigint :user_id
      t.bigint :follower_user_id
      t.datetime :followed_at
      t.boolean :is_active

      t.timestamps
    end
  end
end
