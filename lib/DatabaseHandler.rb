$EVENT_URL = "cdu2015spring"
def save_comments
  jdata = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$commentsId}"))
  jdata["comments"] = get_comments
  save_to_cloudant(jdata.to_json)
end

def save_suggestions
  jdata = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$suggestionsId}"))
  jdata["suggestions"] = get_suggestions
  save_to_cloudant(jdata.to_json)
end

def save_data
  jdata = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$dataId}"))
  jdata["data"] = get_data
  save_to_cloudant(jdata.to_json)
end

def save_tracks
  jdata = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$tracksId}"))
  jdata["tracks-2014"] = $tracksStorage
  save_to_cloudant(jdata.to_json)
end

def save_to_cloudant(json)
  begin
    @respons =  RestClient.post("#{$DB}/#{$EVENT_URL}/", json, {:content_type => :json, :accept => :json})
    if @respons["ok"] then
      p "OK"
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
end

def load_suggestions
  $suggestionsStorage = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$suggestionsId}"))["suggestions"]
end

def load_comments
  $commentsStorage = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$commentsId}"))["comments"]
end

def load_data
  $dataStorage = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$dataId}"))["data"]
end

def load_tracks
  $tracksStorage = JSON.parse(RestClient.get($DB + "/#{$EVENT_URL}/#{$tracksId}"))["tracks"]
  add_ids_to!($tracksStorage)
  save_tracks
end
