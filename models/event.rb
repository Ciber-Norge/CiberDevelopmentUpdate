class Event < ActiveRecord::Base
  has_many :suggestions, dependent: :destroy
  has_many :talks, dependent: :destroy

  validates :title, :start_date, presence: true
end
