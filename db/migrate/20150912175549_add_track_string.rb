class AddTrackString < ActiveRecord::Migration
  def change
    add_column :suggestions, :track, :string
    add_column :talks, :track, :string
  end
end
