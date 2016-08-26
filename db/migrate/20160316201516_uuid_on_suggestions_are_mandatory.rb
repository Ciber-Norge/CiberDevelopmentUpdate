class UuidOnSuggestionsAreMandatory < ActiveRecord::Migration
  def change
    change_column :suggestions, :uuid, :string, null: false
  end
end
