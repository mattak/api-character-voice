class Program < ActiveRecord::Base
  # attr_accessor :id, :title, :from
  has_many :characters
  has_many :actors, through: :characters
  has_many :program_staffs
  has_many :staffs, through: :program_staffs
end
