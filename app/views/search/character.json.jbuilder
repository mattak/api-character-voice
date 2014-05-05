if @characters == [nil]
  json.array! []
else
  json.array!(@characters) do |character|
    next if character == nil
    json.extract! character, :id, :name
    json.actor = character.actor
    json.url character_url(character, format: :json)
  end
end
