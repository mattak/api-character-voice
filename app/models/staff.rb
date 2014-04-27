class Staff < ActiveRecord::Base
  has_many :program_staffs
  has_many :programs, through: :program_staffs
end
