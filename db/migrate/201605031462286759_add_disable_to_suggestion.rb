class AddDisableToSuggestion < ActiveRecord::Migration
  def change
    add_column :suggestions, :deleted, :boolean, default: '0', null: false
  end
end
