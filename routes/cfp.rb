class DUT < Sinatra::Application
  get '/cfp' do
    @tracks = Track.order("title DESC")
    haml :"cfp/index"
  end

  post '/cfp' do
    @suggestion = Suggestion.new(params[:suggestion])
    config  = Configuration.find_by_name("event")
    @suggestion.event_id = config.value unless config.nil?

    if @suggestion.save
      redirect 'cfp/suggestions'
    else
      @errors =  @suggestion.errors
      @tracks = Track.order("title DESC")
      haml :"cfp/index"
    end
  end

  get '/cfp/suggestions' do
    event = Configuration.find_by_name("event")
    @suggestions = Suggestion.where("event_id = ?", event.value).order("title DESC")
    haml :"cfp/suggestions"
  end
end
