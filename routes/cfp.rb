class DUT < Sinatra::Application
  get '/cfp' do
    @tracks = Track.find_each
    haml :"cfp/index"
  end

  post '/cfp' do
    @suggestion = Suggestion.new(params[:suggestion])
    config  = Configuration.find_by_name("event")
    @suggestion.event_id = config.value unless config.nil?

    if @suggestion.save
      redirect to("cfp/thank-you?uuid=#{@suggestion.uuid}")
    else
      @errors =  @suggestion.errors
      @tracks = Track.order("title DESC")
      haml :"cfp/index"
    end
  end

  get '/cfp/thank-you' do
    @secret_link = "/cfp/suggestions/#{params[:uuid]}/edit"
    haml :"cfp/thankyou"
  end

  get '/cfp/suggestions/:uuid/edit' do | uuid |
    @tracks = Track.find_each
    @suggestion = Suggestion.find_by_uuid(uuid)
    haml :"cfp/edit_suggestion"
  end

  post '/cfp/suggestions/:uuid/edit' do | uuid |
    @suggestion = Suggestion.find_by_uuid(uuid)
    if params.has_key?('delete')
      @suggestion.deleted = true
      @suggestion.save
      redirect 'cfp/suggestions'
    end

    @suggestion.update(params[:suggestion])

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
