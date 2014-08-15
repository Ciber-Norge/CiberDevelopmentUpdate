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
	$tracks[id.to_s] || {}
end

def get_tracks_for_now()
	now = Time.now
	tracks_now = {}
	$tracks.each do | track_id, track_value |
		track_value["program"].each do | track_time, value |
			if (something(now, track_time, value["duration"])) then
				value["room"] = track_value["room"]
				tracks_now[track_time] = value
			end
		end
	end
	tracks_now
end

# TODO Need better name!
def something(now, track_time, duration)
	t_a = track_time.split(/:/)
    end_hour = t_a[0].to_i
    end_minutes = t_a[1].to_i + duration.to_i
    if end_minutes >= 60 then
    	end_hour += 1
    	end_minutes -= 60
    end
    startTime = Time.mktime(now.year, now.month, now.day, t_a[0], t_a[1])
    endTime = Time.mktime(now.year, now.month, now.day, end_hour, end_minutes)

    startTime < now && endTime > now
end

def get_spot_name(id)
	$tracks.each do | track, track_value |
    	track_value["program"].each do | program_id, value |
    		if value["id"] == id then
    			return value["title"]
    		end
    	end
    end
end

def save_data
  save_comments_to_json
  save_suggestions_to_json
  save_data_to_json
end