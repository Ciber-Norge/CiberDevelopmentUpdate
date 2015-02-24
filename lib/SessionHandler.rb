def is_active_url?(url)
	"active" if url.kind_of?(String) and\
  	request.path_info.eql? url or request.path_info.start_with? url
end

def is_integer?(value)
	Integer(value) rescue false
end

def get_file(filename)
	File.read(filename)
end

def get_track(id)
	$tracksStorage[id.to_s] || {}
end

def is_running_now(time, duration)
  is_track_running_now(Time.now, time, duration)
end

def get_tracks_for_now()
	now = Time.now
	tracks_now = {}
	$tracksStorage.each do | track_id, track_value |
		track_value["program"].each do | track_time, value |
			if (is_track_running_now(now, track_time, value["duration"])) then
				value["room"] = track_value["room"]
        value["time"] = track_time
				tracks_now[track_id] = value
        tracks_now["starts"] = track_time
			end
		end
	end
	tracks_now
end

def is_track_running_now(now, track_time, duration)
	t_a = track_time.split(/:/)
  end_hour = t_a[0].to_i
  end_minutes = t_a[1].to_i + duration.to_i
  while end_minutes >= 60 do
  	end_hour += 1
  	end_minutes -= 60
  end
  startTime = Time.mktime(now.year, now.month, now.day, t_a[0], t_a[1])
  endTime = Time.mktime(now.year, now.month, now.day, end_hour, end_minutes)
  
  startTime < now && endTime > now
end

def get_spot_name(id)
	$tracksStorage.each do | track, track_value |
    	track_value["program"].each do | program_id, value |
    		if value["id"] == id then
    			return value["title"]
    		end
    	end
    end
end

def save_all_data
  save_comments
  save_suggestions
  save_data
end
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
