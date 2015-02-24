require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'securerandom'
require 'chartkick'
require 'rest_client'
require 'viewpoint'

include Viewpoint::EWS

require_relative 'lib/SessionHandler.rb'
require_relative 'lib/DataHandler.rb'
require_relative 'lib/StatsHandler.rb'
require_relative 'lib/CommentHandler.rb'
require_relative 'lib/JsonUtil.rb'
require_relative 'lib/Extender.rb'
require_relative 'lib/SuggestionHandler'

#Global variables
$tracksStorage = nil
$tracksId = "c2f1cd33f59799c8173f441c749f05f3" #"4fb7af13335a80eef9c77139ac426479"
$rate = nil
$DB = "#{ENV['CLOUDANT_URL_CDU']}"

$commentsStorage = nil
$commentsId = "eeab19cf5f204425dc997eae6b5a687d" #"8b8020e66fe6bc11836ac33940390839"
$suggestionsStorage = nil
$suggestionsId = "eb9d723dccf29016e142ce4b5db1c604" #"1a1e50e006fbaa94c2ae571170e35b0a"
$dataStorage = nil
$dataId = "eeab19cf5f204425dc997eae6b7a574b" #"8b8020e66fe6bc11836ac339403baeef"

use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_set_in_a_env_variable'

set :bind, '0.0.0.0'
set :server, :thin

unless CLOUDANT_URL = ENV['CLOUDANT_URL_CDU']
  raise "You must specify the CLOUDANT_URL env variable"
end

unless USERNAME = ENV['USERNAME']
  raise "You must specify the USERNAME env variable"
end

unless PASSWORD = ENV['PASSWORD']
  raise "You must specify the PASSWORD env variable"
end

unless ENDPOINT = ENV['ENDPOINT']
  raise "You must specify the ENDPOINT env variable"
end

unless EMAIL = ENV['EMAIL']
  raise "You must specify the EMAIL env variable"
end  

CLI = Viewpoint::EWSClient.new ENDPOINT, USERNAME, PASSWORD

begin
	load_tracks
  	load_suggestions
  	load_comments
  	load_data
end

before do
  	session[:init] = true
end

get '/' do
	haml :index
end

# Tracks
get '/track/now' do
	params['id'] = 'now'
	haml :now, :locals => {:params => get_tracks_for_now}
end

get '/track/:id' do | id |
	haml :track, :locals => {:params => get_track(id), :id => id}
end

post '/track/:track/:id' do | track, id |
	save_comment(params['id'], params['navn'], params['kommentar'])
	redirect '/track/' + track
end

get '/track/:id/:detail' do | id, details |
	haml :detail
end

# Admin
get '/update' do
	load_tracks
  	load_suggestions
  	load_comments
  	load_data
	redirect '/'
end

get '/save' do
  save_all_data
  redirect '/'
end

get '/carousel' do
	haml :carousel
end

# Ajax
post '/ajax/rateit' do
	id = params['id']
	value = params['value']
	sessionId = session[:session_id]
	unless have_voted?(id, sessionId) and is_integer?(value) then
		add_sessionId_to!(id, sessionId)
		inc_rating_with!(value, id)
		JSON.generate({'id' => id, 'value' => get_rating_for!(id)})
	else
		JSON.generate({'id' => id, 'value' => get_rating_for!(id)})
	end
end

# Stats
get '/stats' do
	haml :stats
end

get '/stats/comments' do
	haml :comments
end

get '/stats/comments/delete' do
	delete_comment(params['id'], params['parent'])
	redirect '/stats/comments'
end

get '/stats/presentation' do
	haml :stats
end

get '/stats/suggestions' do
	haml :suggestions
end

get '/stats/suggestions/delete' do
	delete_suggestion(params['id'])
	redirect '/stats/suggestions'
end

# Call for Papers
get '/cfp' do
	haml :cfp
end

post '/cfp' do
	if params['title'] == "" || params['description'] == "" || params['responsible'] == "" then
		redirect '/cfp'
	end

	suggestion = JSON.pretty_generate(save_suggestion(params['title'], params['description'], params['format'], params['track'], params['responsible']))

	CLI.send_message do |m|
		m.subject = "Nytt foredrag"
	  	m.body    = "Forslag til foredrag mottatt\n\n#{suggestion}"
	  	EMAIL.split(";").each do | recipient |
	  		p recipient.gsub(/\s/,"")
	  		m.to_recipients << recipient.gsub(/\s/,"")
	  	end
	end

	haml :thankyou
end

get '/cfp/suggestions' do
	haml :cfpsuggestions
end

# Errors
not_found do
	status 404
	haml :oops
end
