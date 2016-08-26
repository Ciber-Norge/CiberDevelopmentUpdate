class AddUuidToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :uuid, :string
  end
end
