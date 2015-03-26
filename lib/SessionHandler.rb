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

def add_sessionId_to!(id, sessionId)
  get_data[id.to_s]["sessionId"] << sessionId
end

def get_sessionId_for!(id)
  get_item_with!(id)["sessionId"] || get_item_with!(id)["sessionId"] = []
end

def get_item_with!(id)
  get_data[id.to_s] || get_data[id.to_s] = {}
end

def get_data()
  $dataStorage || $dataStorage = {}
end
