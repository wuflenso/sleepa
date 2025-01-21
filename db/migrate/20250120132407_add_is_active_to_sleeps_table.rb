class AddIsActiveToSleepsTable < ActiveRecord::Migration[8.0]
  def change
    add_column :sleeps, :deleted_at, :datetime
  end
end
