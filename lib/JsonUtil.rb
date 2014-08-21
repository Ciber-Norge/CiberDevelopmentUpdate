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