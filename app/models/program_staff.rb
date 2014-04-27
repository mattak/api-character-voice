class ProgramStaff < ActiveRecord::Base
  belongs_to :program
  belongs_to :staff
end
