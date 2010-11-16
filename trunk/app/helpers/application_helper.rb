# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def getProjectName(project_id)
		@project = Project.find(:first, :conditions => ["id = ?",  project_id])
		return @project.name
	end
	def getCurrentUser(id)
		return User.find(:first, :conditions => ["id = ?", id])
	end
	def getOnlyDate(timestamp)
		@date = timestamp.to_s.split(' ')
		return @date[0]
	end
	def getUserName
		@user = getCurrentUser(session[:user_id])
		return @user.username
	end
	def getUserNameById(id)
		@user = getCurrentUser(id)
		return @user.username
	end
	def getCurrentDate
		date = Time.new
		return date.strftime("%a %B %d %Y")
	end
	def getYesterdaysDate
		date = Time.new
		date = date.yesterday
		return date.strftime("%a %B %d %Y")
	end
	def isUserManager
		if session[:isManager] == nil
			if session[:user_id] == nil
				session[:isManager] = false
			else
				@user = User.find(:first, :conditions => ["id = ?", session[:user_id]])
				puts YAML::dump("I get here..............................")
				session[:isManager] = @user.isManager
			end
		end
		return session[:isManager]
	end
	def isUserAdmin
		if session[:isAdmin] == nil
			@user = User.find(:first, :conditions => ["id = ?", session[:user_id]])
			session[:isAdmin] = @user.isAdmin
		end
		return session[:isAdmin]
	end
	def getWork_type
		work = Array.new
		work.push('New Development')
		work.push('Bug Fix')
		work.push('Testing')
		return work
	end
	def getCharteredArray
		work = Array.new
		work.push('No')
		work.push('Yes')
		return work
	end
	def getManagers
		return User.find(:all, :conditions => ['active = 1 and isManager = 1'])
	end
	def getAllTeams
		return Team.find(:all)
	end
	def getUsersBy(field, value)
		return User.find(:all, :conditions => ['active = 1 and '+field+' = ?', value])
	end
	def getTeamNameById(id)
		return getTeamById(id).name
	end
	def getManagedTeams(user_id)
		return Team.find(:all, :conditions => ['owner_id = ?', user_id])
	end
	def getTeamById(id)
		result = Team.find(:first, :conditions => ['id = ?', id])
		return result	
	end
	def hasPermissionToEditUser(logged_user_id, other_user_id)
		@other_user = User.find(:first, :conditions => ['id = ?', other_user_id])
		if @other_user.active and logged_user_id.to_s == other_user_id.to_s or isUserAdmin
			return true
		else
			if @other_user.active and isUserManager and !@other_user.isAdmin
				return true
			else
				return false
			end
		end
	end
	def userHasPermissionsToModifyUser(logged_user_id, other_user_id)
		if isUserAdmin and logged_user_id.to_s != other_user_id.to_s
			return true
		else
			return false
		end
	end
	def getProjectsForUser(team_id)
		if isUserManager or isUserAdmin
			return @projects = Project.find(:all)
		else 
			return Project.find(:all, :conditions => ['team_id = ?', team_id])
		end
	end
	def clearErrorMessage()
		flash[:error] = ""
	end
end
