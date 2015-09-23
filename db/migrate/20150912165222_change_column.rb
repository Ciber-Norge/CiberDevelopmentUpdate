class ChangeColumn < ActiveRecord::Migration
  def change
    remove_column :tracks, :date, :room
  end
end
