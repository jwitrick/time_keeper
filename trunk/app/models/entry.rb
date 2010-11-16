class Entry < ActiveRecord::Base
 has_one :user
 has_one :project
 validates_presence_of :name, :description, :duration
 validates_numericality_of :duration
end
