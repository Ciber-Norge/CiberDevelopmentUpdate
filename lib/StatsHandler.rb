def get_number_of_votes()
	sum = 0
	get_data.each do | key, value |
		sum += value["rating_count"] || 0
	end
	sum
end

def get_number_of_votes_for(id)
	get_item_with!(id)["rating_count"] || 0
end

def get_average_of_votes()
	sum = 0
	votes = get_number_of_votes
	get_data.each do | key, value |
		sum += value["rating"].sum || 0
	end
	unless sum == 0 or votes == 0
		return sum / votes
	end
	0
end

def get_average_of_votes_for(id)
	sum = get_item_with!(id)["rating"].sum
	votes = get_number_of_votes_for(id)
	unless sum == 0 or votes == 0
		return sum / votes
	end
	0
end

def get_votes_for_stats_for(id)
	values = {}
	get_item_with!(id)["rating"].uniq.each do | value |
		values[:"Stemt #{value}"] = get_item_with!(id)["rating"].count(value)
	end
	values
end