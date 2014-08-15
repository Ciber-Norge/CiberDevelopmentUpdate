def load_tracks_from_json()
	file = File.read('public/json/cdu-tracks-2014.json') # filename to env or something like that
	$tracks = JSON.parse(file)
	add_ids_to!($tracks)
	save_tracks_to_json
end

def save_tracks_to_json()
	File.open('public/json/cdu-tracks-2014.json', 'w') do | file |
		file.write(JSON.pretty_generate($tracks))
	end
end

def add_ids_to!(json)
	json.each do | key, value |
		if value.key?('program') then
			value['program'].each do | inner_key, inner_value |
				unless inner_value.key?('id') then
					inner_value['id'] = SecureRandom.hex(4)
				end
			end
		end
	end
end

def load_suggestions_from_json
  $suggestionsStorage = JSON.parse(File.read('public/json/suggestions.json'))
end

def load_comments_from_json
  $commentsStorage = JSON.parse(File.read('public/json/comments.json'))
end

def load_data_from_json
  $dataStorage = JSON.parse(File.read('public/json/data.json'))
end

def save_comments_to_json
  File.open('public/json/comments.json', 'w') do | file |
    file.write(get_comments.to_json)
  end
end

def save_suggestions_to_json
  File.open('public/json/suggestions.json', 'w') do | file |
    file.write(get_suggestions.to_json)
  end
end

def save_data_to_json
  File.open('public/json/data.json', 'w') do | file |
    file.write(get_data.to_json)
  end
end