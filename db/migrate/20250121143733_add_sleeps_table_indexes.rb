class AddSleepsTableIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :sleeps, [ :user_id, :deleted_at, :start, :duration_seconds ], order: { duration_seconds: :desc }
    add_index :sleeps, [ :user_id, :deleted_at, :start ], order: { start: :desc }
  end
end
