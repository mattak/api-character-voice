if @ranks == nil || @ranks.size < 1 || @ranks == [nil]
  json.array! []
else
  json.array!(@ranks) do |rank|
    actor = rank[:actor]
    json.extract! rank, :count, :actor
    json.actor do
      json.extract! actor, :id, :name, :birth, :programs, :characters
    end
    json.url actor_url(actor, format: :json)
  end
end
