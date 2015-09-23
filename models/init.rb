require 'pg'

db_url = ENV['DATABASE_URL'] || 'postgres://postgres:postgres@localhost/dut'
db = URI.parse(db_url)

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

require_relative 'suggestion'
require_relative 'configuration'
require_relative 'track'
require_relative 'talk'
require_relative 'comment'
require_relative 'event'
require_relative 'rating'
