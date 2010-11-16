class Project < ActiveRecord::Base
 has_many :entries
 validates_presence_of :name, :description
 validates_uniqueness_of :name
end
