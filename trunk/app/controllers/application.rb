# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c09122127cd9e8e65c790b5f70a7a3fc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def current_user
    @_current_user ||= session[:user_id] && User.find(:first, :conditions => ['id = ?', session[:user_id]]).id
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section" 
      redirect_to root_url # Prevents the current action from running
    end
  end

  def require_admin
    unless isUserAdmin
      flash[:error] = "You must be an admin to view this page"
      redirect_to '/entry/index' #root_url
    end
  end

  def require_manager
    unless isUserManager
	flash[:error] = "You must be a manager to view this page"
	redirect_to '/entry/index' #root_url
    end
  end

  # The logged_in? method simply returns true if the user is logged in and
  # false otherwise. It does this by "booleanizing" the current_user method
  # we created previously using a double ! operator. Note that this is not
  # common in Ruby and is discouraged unless you really mean to convert something
  # into true or false.
  def logged_in?
    !!current_user
  end

  def reset_session
	session[:isUserManager] = nil
	session[:user_id] = nil
	session[:isUserAdmin] = nil
  end

end
