class DUT < Sinatra::Application
  get '/' do
    site_mode = Configuration.find_by_name("site_mode")
    if site_mode.value == "track"
      event_id = Configuration.find_by_name("event").value
      @tracks = Talk.where('event_id = ?', event_id).select('track').distinct.map { | talk |
        talk.track
      }
      haml :index_track
    else
      haml :index_cfp
    end
  end
end
