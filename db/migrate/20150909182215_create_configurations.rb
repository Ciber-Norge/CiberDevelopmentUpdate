class CreateConfigurations < ActiveRecord::Migration
  def up
    create_table :configurations do | t |
      t.string :name
      t.string :value

      t.timestamps null: false
    end
  end

  def down
    drop_table :configurations
  end
end
