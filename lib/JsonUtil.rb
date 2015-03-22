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
