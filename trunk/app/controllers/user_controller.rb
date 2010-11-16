class UserController < ApplicationController
include ApplicationHelper
before_filter :require_login
layout 'standard'
	def list
		clearErrorMessage
		@users = User.find(:all)
	end
	def show
		clearErrorMessage
		@user = User.find(params[:id])
		@team = Team.find(@user.team_id)
	end
	def new
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		@user = User.new
		@teams = Team.find(:all)
	end
	def create
		clearErrorMessage
		#puts YAML::dump(params[:user])
		@user = User.new(params[:user])
		@teams = Team.find(:all)
		if @user.save
			redirect_to session[:return_to]
		else
			render :action => 'new'
		end
	end
	def edit
		clearErrorMessage
		session[:return_to] = request.referer
		if hasPermissionToEditUser(session[:user_id], params[:id])
			@user = User.find(params[:id])
			@teams = Team.find(:all)
		else
			flash[:error] = "You dont have permission to edit that user"
			redirect_to session[:return_to] || {:action => 'index', :controller => 'entry'}
		end
	end
	def password
		clearErrorMessage
		session[:return_to] = request.referer
		if hasPermissionToEditUser(session[:user_id], params[:id])
			@user = User.find(params[:id])
			@user.password = ""
		else
			flash[:error] = "You dont have permission to edit that user"
			redirect_to session[:return_to] || {:action => 'index', :controller => 'entry'}
		end
	end
	def update_password
		clearErrorMessage
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to session[:return_to]
		else
			@user.password = ""
			@user.password_confirmation = ""
			render :action => 'password'
		end
	end
	def update
		clearErrorMessage
		@user = User.find(params[:id])
		@teams = Team.find(:all)
		if @user.update_attributes(params[:user])
			redirect_to session[:return_to]
		else
			render :action => 'edit'
		end
	end	
	def delete
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		if isUserAdmin
			User.find(params[:id]).destroy
			redirect_to session[:return_to]
		else
			flash[:notice] = "You must be an admin to delete a user."
			redirect_to session[:return_to]
		end
	end
	def disable
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		if userHasPermissionsToModifyUser(session[:user_id], params[:id])
			@user = User.find(:first, :conditions => ['id = ?', params[:id]])
			if @user.update_attribute :active , '0'
				redirect_to session[:return_to]
			else
				flash[:error] = "Something went wrong"
				redirect_to session[:return_to]
			end
		else
			redirect_to session[:return_to]
		end
	end
	def enable
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		if userHasPermissionsToModifyUser(session[:user_id], params[:id])
			@user = User.find(:first, :conditions => ['id = ?', params[:id]])
			if @user.update_attribute :active , '1'
				redirect_to session[:return_to]
			else
				flash[:error] = "Something went wrong"
				redirect_to session[:return_to]
			end
		else
			redirect_to session[:return_to]
		end
	end
	def make_admin
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		if userHasPermissionsToModifyUser(session[:user_id], params[:id])
			@user = User.find(:first, :conditions => ['id = ?', params[:id]])
			if @user.update_attribute :isAdmin , '1'
				redirect_to session[:return_to]
			else
				flash[:error] = "Something went wrong"
				redirect_to session[:return_to]
			end
		else
			redirect_to session[:return_to]
		end
		
	end
	def remove_admin
		clearErrorMessage
		session[:return_to] = request.referer || "/entry/index"
		if userHasPermissionsToModifyUser(session[:user_id], params[:id])
			@user = User.find(:first, :conditions => ['id = ?', params[:id]])
			if @user.update_attribute :isAdmin , '0'
				redirect_to session[:return_to]
			else
				flash[:error] = "Something went wrong"
				redirect_to session[:return_to]
			end
		else
			redirect_to session[:return_to]
		end
		
	end
end
