if @programs == nil || @programs.size < 1 || @programs == [nil]
  json.array! []
else
  json.array!(@programs) do |program|
    next if program == nil
    json.extract! program, :id, :title, :from

    json.characters(program.characters) do |character|
      json.extract! character, :id, :name
      json.actor character.actor
    end

    json.url program_url(program, format: :json)
  end
end

