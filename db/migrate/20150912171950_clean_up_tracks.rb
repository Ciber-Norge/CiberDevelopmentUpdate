class CleanUpTracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :room
  end
end
