class TeamController < ApplicationController
include ApplicationHelper
before_filter :require_login
before_filter :require_manager
layout 'standard'
	def list
		clearErrorMessage
		@teams = Team.find(:all)
	end
	def show
		clearErrorMessage
		session[:return_to] = request.referer
		@team = Team.find(params[:id])
		@team_members = getUsersBy('team_id', params[:id])
		@projects = Project.find(:all, :conditions => ["team_id = ?", params[:id]])
	end
	def new
		clearErrorMessage
		session[:return_to] = request.referer
		@team = Team.new
		@managers = getManagers
	end
	def create
		clearErrorMessage
		@team = Team.new(params[:team])
		session[:return_to] = "/entry/index" if session[:return_to] == nil
		@managers = getManagers
		if @team.owner_id == nil
			@team.owner_id = session[:user_id]
		end	
		if @team.save
			redirect_to session[:return_to]
		else
			render :action => 'new'
		end
	end
	def edit
		clearErrorMessage
		session[:return_to] = request.referer
		@team = Team.find(params[:id])
		@managers = getManagers
	end
	def update
		@team = Team.find(params[:id])
		session[:return_to] = "/entry/index" if session[:return_to] == nil
		clearErrorMessage
		if @team.update_attributes(params[:team])
			redirect_to session[:return_to]
		else
			render :action => 'edit'
		end
	end
	def delete
		clearErrorMessage
		session[:return_to] = request.referer
		Team.find(params[:id]).destroy
		redirect_to session[:return_to]
	end
end
