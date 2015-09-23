class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do | t |
      t.string :title
      t.string :place
      t.string :description
      t.string :cfp_description
      t.date :start_date 

      t.timestamps null: false
    end
  end

  def down
    drop_table :events
  end
end
