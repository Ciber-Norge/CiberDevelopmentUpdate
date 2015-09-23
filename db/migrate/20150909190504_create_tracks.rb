class CreateTracks < ActiveRecord::Migration
  def up
    create_table :tracks do | t |
      t.string :title
      t.date :date
      t.string :room

      t.timestamps null: false
    end

    create_table :talks do | t |
      t.belongs_to :track, index: true

      t.string :title
      t.string :description
      t.string :speaker
      t.string :format
      t.time :time

      t.timestamps null: false
    end

    create_table :comments do | t |
      t.belongs_to :talk, index: true

      t.string :comment
      t.string :author

      t.timestamps null: false
    end
  end

  def down
    drop_table :tracks
    drop_table :talks
    drop_table :comments
  end
end
