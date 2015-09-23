class ChangeToEvent < ActiveRecord::Migration
  def change
    rename_column :talks, :track_id, :event_id
    rename_column :suggestions, :track_id, :event_id
  end
end
