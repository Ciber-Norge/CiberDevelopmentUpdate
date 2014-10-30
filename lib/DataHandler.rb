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

def have_voted?(id, sessionId)
	get_sessionId_for!(id).include? sessionId
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