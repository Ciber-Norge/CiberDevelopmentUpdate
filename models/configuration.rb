class Configuration < ActiveRecord::Base
  def to_s
    "#{self.name}: #{self.value}"
  end
end
