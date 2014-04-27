json.array!(@characters) do |character|
  json.extract! character, :id, :name, :program_id, :actor_id
  json.url character_url(character, format: :json)
end
