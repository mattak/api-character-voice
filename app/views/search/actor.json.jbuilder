if @programs == nil || @programs.size < 1 || @programs == [nil]
  json.array! []
else
  json.array!(@actors) do |actor|
    json.extract! actor, :id, :name, :birth, :characters, :programs
    json.url actor_url(actor, format: :json)
  end
end
