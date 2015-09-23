class CreateSuggestions < ActiveRecord::Migration
  def up
    create_table :suggestions do | t |
      t.string :title
      t.string :description
      t.string :speaker
      t.string :format
      t.string :track

      t.timestamps null: false
    end
  end

  def down
    drop_table :suggestions
  end
end
