class AddTrackIdToSuggestions < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :track_id, :integer
    remove_column :suggestions, :track
  end

  def self.down
    add_column :suggestions, :track, :string
    remove_column :suggestions, :track_id
  end
end
