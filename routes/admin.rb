class DUT < Sinatra::Application
  before do
    # check for admin role
  end

  get '/admin' do
    @configurations = {}
    Configuration.order("created_at DESC").each do | c |
      @configurations[c.name] = c.value
    end
    @events = Event.order("created_at DESC")
    haml :"admin/index"
  end

  post '/admin' do
    params["config"].each do | c |
      config = Configuration.find_by_name(c[0])
      config.value = c[1]
      config.save
    end

    redirect 'admin'
  end

  get '/admin/events' do
    @events = Event.order("title DESC")
    haml :"admin/events"
  end

  post '/admin/events' do
    @event = Event.new(params["event"])
    if @event.save
      redirect 'admin/events'
    else
      @events = Event.order("title DESC")
      @errors = @event.errors
      haml :"admin/events"
    end
  end

  get '/admin/events/:id/edit' do | id |
    @event = Event.find(id)
    haml :"admin/event_edit"
  end

  post '/admin/events/:id/edit' do | id |
    @event = Event.find(id)
    @event.update(params["event"])
    redirect 'admin/events'
  end

  get '/admin/suggestions' do
    event = Configuration.find_by_name("event")
    @suggestions = Suggestion.where("event_id = ?", event.value).order("title DESC")
    @tracks = Track.order("title DESC")
    haml :"admin/suggestions"
  end

  post '/admin/suggestions' do
    @suggestion = Suggestion.find(params["id"])
    @talk = Talk.new("event_id" => @suggestion.event_id, "time" => params["time"],
                     "title" => @suggestion.title, "description" => @suggestion.description,
                     "speaker" => @suggestion.speaker, "format" => @suggestion.format,
                     "track" => params["track"])
    if @talk.save
      redirect 'admin/suggestions'
    # else
      # @suggestions = Suggestion.order("created_at DESC")
      # @tracks = Track.order("title DESC")
      # @errors =  @suggestion.errors
      # haml :"admin/suggestions"
    end
    redirect 'admin/suggestions'
  end

  get '/admin/tracks' do
    @tracks = Track.order("title DESC")
    haml :"admin/tracks"
  end

  post '/admin/tracks' do
    @track = Track.new(params["track"])
    @track.save
    redirect 'admin/tracks'
  end

  get '/admin/talks' do
    event = Configuration.find_by_name("event")
    @talks = Talk.where("event_id = ?", event.value).order("title DESC")
    @tracks = Track.order("title DESC")
    haml :"admin/talks"
  end

  post '/admin/talks' do
    talk = Talk.find(params[:id])
    redirect 'admin/talks' unless talk
    if params.has_key?('delete')
      talk.destroy
    else
      talk.time = params['time']
      talk.track = params['track']
      talk.save
    end
    redirect 'admin/talks'
  end

  get '/admin/comments' do
    event_id = Configuration.find_by_name("event").value
    @comments = Comment.where('event_id = ?', event_id).order('talk_id')
    haml :"admin/comments"
  end

  post '/admin/comments' do
    comment = Comment.find(params[:id])
    comment.destroy if comment
    redirect 'admin/comments'
  end
end
