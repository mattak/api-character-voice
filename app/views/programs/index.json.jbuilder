json.array!(@programs) do |program|
  json.extract! program, :id, :title, :from, :characters, :program_staffs
  json.url program_url(program, format: :json)
end
