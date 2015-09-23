class Talk < ActiveRecord::Base
  belongs_to :event
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def rating
    value = 0
    self.ratings.each do | rating |
      value += rating.vote
    end
    value
  end

  def has_rated(ip)
    self.ratings.each do | rating |
      if rating.ip == ip
        return true
      end
    end
    false
  end
end
