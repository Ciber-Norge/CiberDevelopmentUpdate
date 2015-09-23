class DUT < Sinatra::Application
  get '/track/now' do
    haml :now
  end

  get '/track/:track' do | track |
    @tracks = Track.order("title DESC")
    @talks = Talk.where("track = ?", track)
    haml :"track/track"
  end

  post '/comment/:track/:id' do | track, id |
    comment = Comment.new(params["comment"], :talk_id => id)
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
