class DUT < Sinatra::Application
  get '/track/now' do
    event_id = Configuration.find_by_name("event").value
    @talks = []
    @tracks = Talk.where('event_id = ?', event_id)
      .select('track').distinct.map { | talk | talk.track }
    haml :'track/now'
  end

  get '/track/all' do
    event_id = Configuration.find_by_name("event").value
    @talks = Talk.where('event_id = ?', event_id).order('time')
    @tracks = Talk.where('event_id = ?', event_id)
      .select('track').distinct.map { | talk | talk.track }
    haml :'track/all'
  end

  get '/track/:track' do | track |
    event_id = Configuration.find_by_name("event").value
    @talks = Talk.where('event_id = ? and track = ?', event_id, track).order('time')
    @tracks = Talk.where('event_id = ?', event_id)
      .select('track').distinct.map { | talk | talk.track }
    haml :"track/track"
  end

  post '/comment/:track/:id' do | track, id |
    event_id = Configuration.find_by_name("event").value
    comment = Comment.new(params["comment"])
    comment.talk_id = id
    comment.event_id = event_id
    comment.save
    redirect 'track/' + track
  end

  post '/ajax/rateit' do
    @talk = Talk.find(params["id"])
    if @talk.nil?
      logger.warn "Couldn't find Talk with id #{params["id"]}"
      return {
        "id" => params["id"], 
        "value" => 0
      }.to_json
    end

    unless @talk.has_rated(request.ip)
      @rating = Rating.new(:talk_id => @talk.id, :vote => params["value"],
                           :ip => request.ip)
      @rating.save
      @talk.ratings.reload
    end
    {
      "id" => @talk.id, 
      "value" => @talk.rating,
      "ratings" => @talk.ratings.size
    }.to_json
  end
end
