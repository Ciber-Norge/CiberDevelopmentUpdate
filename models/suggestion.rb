class Suggestion < ActiveRecord::Base
  belongs_to :event

  validates :title, :description, :speaker, :format, :track, presence: true
end
