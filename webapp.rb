require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'config/app_config.rb'

class DUT < Sinatra::Application
  register Sinatra::R18n

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
  end
end

require_relative 'models/init'
require_relative 'routes/init'
