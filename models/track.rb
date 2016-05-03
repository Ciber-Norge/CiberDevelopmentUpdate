class Track < ActiveRecord::Base
  validates :title, presence: true

  default_scope -> { order('title DESC') }
end
