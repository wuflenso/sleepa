class CreateSleeps < ActiveRecord::Migration[8.0]
  def change
    create_table :sleeps do |t|
      t.datetime :start
      t.datetime :end
      t.bigint :duration_seconds
      t.bigint :user_id

      t.timestamps
    end
  end
end
