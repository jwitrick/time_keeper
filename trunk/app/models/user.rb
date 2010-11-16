class User < ActiveRecord::Base
 has_many :entries
 validates_presence_of :first_name, :last_name, :username, :password, :email
 validates_length_of :username,
   :in => 6..10            # between 8 and 16 characters
 validates_uniqueness_of :username
 validates_confirmation_of :password, :message => "Passwords do not match"
 validates_format_of :email,
	:with => /^.*@((?:[-a-z0-9]+\.)[a-z]{2,})$/i
	def getIdByUserName(username)
		return User.find(:fist, :conditions => ['username = ?', username]).id
	end
end
