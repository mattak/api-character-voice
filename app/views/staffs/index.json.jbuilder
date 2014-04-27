json.array!(@staffs) do |staff|
  json.extract! staff, :id, :name, :role, :program_staffs
  json.url staff_url(staff, format: :json)
end
