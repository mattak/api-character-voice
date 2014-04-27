json.array!(@program_staffs) do |program_staff|
  json.extract! program_staff, :id, :staff_id, :program_id, :role
  json.url program_staff_url(program_staff, format: :json)
end
