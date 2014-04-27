class Actor < ActiveRecord::Base
  has_many :characters
  has_many :programs
end
