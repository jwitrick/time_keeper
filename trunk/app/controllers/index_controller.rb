class IndexController < ApplicationController
	layout 'standard'
  def authenticate
	if session[:user_id] != nil
		redirect_to '/entry/index'
	else
	   #puts YAML::dump(params)
	   #puts YAML::dump("USerform:")
	   #puts YAML::dump(params[:userform])
	   #puts YAML::dump("End USerform:")
	   @user = User.new(params[:userform])
	    #find records with username,password
	   valid_user = User.find(:first,:conditions => ["username = ? and password = ?",@user.username, @user.password])
	        #if statement checks whether valid_user exists or not
		if valid_user
	       		 #creates a session with username
			session[:user_id]	= valid_user.id
			session[:isManager]	= valid_user.isManager
			session[:isAdmin]	= valid_user.isAdmin
	        	#redirects the user to our private page.
			#redirect_to :action => 'entry/list'
			redirect_to '/entry/index'
		else
			flash[:notice] = "Invalid User/Password"
			redirect_to :action=> 'login'
		end
	end
  end

  def login
	reset_session
  end

  def private
	if !session[:user_id]
		redirect_to :action=> 'login'
	end
  end

  def logout
	  if session[:user_id]
		  reset_session
		 # redirect_to '/index/login'
	  end
		  redirect_to :action => 'login'
  end

end
