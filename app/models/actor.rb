class Actor < ActiveRecord::Base
  has_many :characters
  has_many :programs, through: :characters
end
