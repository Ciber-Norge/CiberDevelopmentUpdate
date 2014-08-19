require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'securerandom'
require 'chartkick'
require 'rufus-scheduler'

require_relative 'lib/SessionHandler.rb'
require_relative 'lib/DataHandler.rb'
require_relative 'lib/StatsHandler.rb'
require_relative 'lib/CommentHandler.rb'
require_relative 'lib/JsonUtil.rb'
require_relative 'lib/Extender.rb'
require_relative 'lib/SuggestionHandler'

#Global variables
$tracks = nil
$rate = nil

$commentsStorage = nil
$suggestionsStorage = nil
$dataStorage = nil

enable :sessions
use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_set_in_a_env_variable'

set :bind, '0.0.0.0'
set :server, :thin

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  puts Time.now
  puts 'Saving to file'
  save_data
end

begin
	load_tracks_from_json
  load_suggestions_from_json
  load_comments_from_json
  load_data_from_json
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
	load_tracks_from_json
	redirect '/'
end

get '/save' do
  save_data
  redirect '/'
end

get '/carousel' do
	haml :carousel
end

# Ajax
post '/ajax/rateit' do
	p "hello"
	id = params['id']
	value = params['value']
	ip = request.ip
	unless have_voted?(id, ip) and is_integer?(value) then
		add_ip_to!(id, ip)
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

get '/stats/presentation' do
	haml :stats
end

get '/stats/suggestions' do
	haml :suggestions
end

get '/stats/suggestions/slett' do
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

	save_suggestion(params['title'], params['description'], params['format'], params['track'], params['responsible'])
	haml :thankyou
end

# Errors
not_found do
	status 404
	haml :oops
end