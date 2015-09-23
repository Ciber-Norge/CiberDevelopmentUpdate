class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do | t |
      t.belongs_to :talk, index: true
      t.integer :vote
      t.string :ip

      t.timestamps null: false
    end
  end
end
