class ProjectController < ApplicationController
include ApplicationHelper
before_filter :require_login
before_filter :require_manager
layout 'standard'
	def list
		clearErrorMessage
		@projects = Project.find(:all)
	end
	def show
		clearErrorMessage
		@project = Project.find(params[:id])
	end
	def new
		clearErrorMessage
		session[:return_to] = request.referer
		@project = Project.new
		@users = User.find(:all, :conditions => ['active = 1'])
		@teams = getManagedTeams(session[:user_id])
	end
	def create
		clearErrorMessage
		@project = Project.new(params[:project])
		if params[:project][:chartered] == 'Yes'
			@project.chartered = 1
		else
			@project.chartered = 0
		end
		if @project.save
			redirect_to session[:return_to] || '/project/list'
		else
			render :action => 'new'
		end
	end
	def edit
		clearErrorMessage
		session[:return_to] = request.referer || '/project/list'
		@project = Project.find(params[:id])
	    if @project.owner_id != session[:user_id] && getTeamById(@project.team_id).owner_id != session[:user_id]
		flash[:error] = "You can not edit that "
		redirect_to session[:return_to] || {:action => 'index', :controller => 'entry'}
	    else
		if @project.chartered
			@charteredValue = 'Yes'
		else
			@charteredValue = 'No'
		end
		@teams = getManagedTeams(session[:user_id])
	   end
	end
	def update
		clearErrorMessage
		@project = Project.find(params[:id])
		if params[:project][:chartered] == 'Yes'
			params[:project][:chartered] = 1
		else
			params[:project][:chartered] = 0
		end
		if @project.update_attributes(params[:project])
			redirect_to session[:return_to] || '/project/list'
		else
			render :action => 'edit'
		end
	end	
	def disable
		clearErrorMessage
		@project = Project.find(params[:id])
		if @project.update_attribute :active, "0"
			redirect_to session[:return_to] || '/project/list'
		else
			flash[:notice] = "Something went wrong"
			redirect_to session[:return_to] || '/entry/index'
		end
	end
	def enable
		clearErrorMessage
		@project = Project.find(params[:id])
		if @project.update_attribute :active, "1"
			redirect_to session[:return_to] || '/project/list'
		else
			flash[:notice] = "Something went wrong"
			redirect_to session[:return_to] || '/entry/index'
		end
	end
	def delete
		clearErrorMessage
		if isUserAdmin 
			Project.find(params[:id]).destroy
			redirect_to session[:return_to] || '/project/list'
		else
			flash[:notice] = "You must be an admin to delete a project."
			redirect_to session[:return_to] || '/entry/index'
		end
	end
end
