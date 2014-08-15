def save_suggestion(title, description, format, track, responsible)
	{
      SecureRandom.hex(2) => {
          'title' => title,
          'description' => description,
          'format' => format,
          'track' => track,
          'responsible' => responsible
      }
  }
end

def delete_suggesion(id)
	get_suggestions.delete(id)
end

def get_suggestion_for(id)
	get_suggestions[id] || get_suggestions[id] = {}
end

def get_suggestion_count
	get_suggestions.length
end

def get_suggestions
  $suggestionsStorage || $suggestionsStorage = {}
end
