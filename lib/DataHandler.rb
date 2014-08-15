def get_rating_for!(id)
	if get_item_with!(id)["rating"].nil?
		init_rating_for!(id)
	end
	sum = get_item_with!(id)["rating"].sum
	if sum.nil? then return 0 end

	sum / get_item_with!(id)["rating_count"]
end

def inc_rating_with!(rating, id)
	if get_item_with!(id)["rating"].nil? then
		init_rating_for!(id)
	end
	
	get_item_with!(id)["rating_count"] += 1
	get_item_with!(id)["rating"] << rating.to_f
end

def init_rating_for!(id)
	get_item_with!(id)["rating"] = []
	get_item_with!(id)["rating_count"] = 0
end

def have_voted?(id, ip)
	get_ip_for!(id).include? ip
	false
end

def add_ip_to!(id, ip)
	get_data[id.to_s]["ip"] << ip
end

def get_ip_for!(id)
	get_item_with!(id)["ip"] || get_item_with!(id)["ip"] = []
end

def get_item_with!(id)
	get_data[id.to_s] || get_data[id.to_s] = {}
end

def get_data()
	$dataStorage || $dataStorage = {}
end