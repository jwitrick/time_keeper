class EntryController < ApplicationController
include ApplicationHelper
include EntryHelper
before_filter :require_login
layout 'standard'
	def index
		@time_current = 0
		@time_past = 0
		time = Time.new
		today_time = time.strftime("%Y-%m-%d 00:00:00")
		past_var = time.yesterday
		past_time = past_var.strftime("%Y-%m-%d 00:00:00")
		end_var = time.advance :days => 1
		tomorrow_time = end_var.strftime("%Y-%m-%d 00:00:00")
		@entries_current = Entry.find(:all, :limit => 5, :conditions => ["user_id = ? and date >= ? and date < ?", session[:user_id], today_time, tomorrow_time])
		@entries_past = Entry.find(:all, :limit => 5,  :conditions => ["user_id = ? and date >= ? and date < ?", session[:user_id], past_time, today_time])
	end
	def user_report
		clearErrorMessage
		default			= 'Date'
		@report_type		= default
		@userReportOptions	= getUserReportBy
	end
	def user_report_suboptions
		#puts YAML::dump(params)
		@report_type		= params[:id]
		if @report_type == 'Date'
		  time = Time.new
		  d_type	= 'Daily'				if params[:date_type] == nil
		  d_type	= params[:date_type]			if params[:date_type] != nil
		  date_options	= getDateItems(d_type, params[:date_range], params[:date_subtype])
		  if params[:change] == 'date_type'
			d_range = date_options[2][0].gsub(/ /, '_')	if d_type == 'Daily'
			d_range = date_options[2][0]			if d_type != 'Daily'
		  else
			d_range = params[:date_range].gsub(/_/, ' ')	if d_type != 'Daily'
			d_range = params[:date_range]			if d_type == 'Daily'
		  end
		  d_subtype	= 'Project'				if params[:date_subtype] == nil
		  @date_array	= userDateRangeCalculator(@report_type, d_type+'_'+d_range, time)
		  entry_data = Array.new
		  entry_data.push(session[:user_id])
		  @date_array.each do |d|
			entry_data.push(d)
		  end
		  entry_data.push(params[:date_subtype])
		  entries = createUserReportQuery(entry_data)
		  respond_to do |format|
		  	format.json { render :json => {
		  			:dateoptions		=> date_options[0],
					:dateoptions_sel	=> date_options[1], 
					:daterange		=> date_options[2],
					:daterange_sel		=> date_options[3].gsub(/_/, ' '),
					:datesuboptions 	=> date_options[4],
					:datesubtype_sel	=> date_options[5],
					:entries		=> entries
					}
			}
		  end
		elsif @report_type  == 'Project'
		  @sub_options		= getUserReportSubOptions(@report_type, "All")
		  @user			= getCurrentUser(session[:user_id]) 
		  @projects		= getProjectsForUser(@user.team_id)
		  @project		= @projects[0].name				if params[:project] == nil
		  @project		= params[:project].gsub(/_/, " ")		if params[:project] != nil
		  @project_opt		= @sub_options[0]				if params[:project_option] == nil
		  @project_opt		= params[:project_option].gsub(/_/, " ")	if params[:project_option] != nil
		  respond_to do |format|
			format.json { render :json => {
					:projects		=> @projects,
					:project		=> @project,
					:project_options	=> @sub_options,
					:project_opt		=> @project_opt
					}
			}
		  end
		elsif @report_type == 'Chartered'
		  @sub_options		= getUserReportSubOptions(@report_type, 'All')
		  @range_sel		= @sub_options[0] 				if params[:chartered_range] == nil
		  @range_sel		= params[:chartered_range].gsub(/_/, " ")	if params[:chartered_range] != nil
		  respond_to do |format|
			format.json { render :json => {
					:range_sel	=> @range_sel,
					:range		=> @sub_options
					}
			}
		  end
		elsif @report_type == 'NonChartered'
		  @sub_options		= getUserReportSubOptions(@report_type, 'All')
		  @range_sel		= @sub_options[0]				if params[:chartered_range] == nil
		  @range_sel		= params[:chartered_range].gsub(/_/, " ")	if params[:chartered_range] != nil
		  respond_to do |format|
			format.json { render :json => {
					:range_sel	=> @range_sel,
					:range		=> @sub_options
					}
			}
		  end
		end
	end
	def list
		clearErrorMessage
		@entries = Entry.find(:all)
		@totaltime = 0
	end
	def show
		clearErrorMessage
		session[:return_to] = request.referer
		@entry = Entry.find(:all, :conditions => ["id = ? and user_id = ?", params[:id], session[:user_id]])
	end
	def new
		clearErrorMessage
		session[:return_to] = request.referer
		@entry = Entry.new
		@user = getCurrentUser(session[:user_id]) 
		@projects = getProjectsForUser(@user.team_id)
	end
	def create
		session[:return_to] = "/entry" if session[:return_to] == nil
		@entry = Entry.new(params[:entry])
		@entry.user_id = session[:user_id]
		if @entry.date == nil
			time = Time.new
			@entry.date = time.strftime("%Y-%m-%d %H:%M:%S")
		end
		if @entry.save
			redirect_to session[:return_to] or "/entry"
		else
			@user = getCurrentUser(session[:user_id]) 
			@projects = getProjectsForUser(@user.team_id)
			render :action => 'new'
		end
	end
	def edit
		clearErrorMessage
		session[:return_to] = request.referer
		@entry = Entry.find(params[:id])
		@user = getCurrentUser(session[:user_id]) 
		@workValue = @entry.work_type
		@projects = getProjectsForUser(@user.team_id)
	end
	def update
		@entry = Entry.find(params[:id])
		if @entry.update_attributes(params[:entry])
			redirect_to session[:return_to] || '/entry/index'
		else
			@user = getCurrentUser(session[:user_id]) 
			@workValue = @entry.work_type
			@projects = getProjectsForUser(@user.team_id)
			render :action => 'edit'
		end
	end
	def delete
		if isUserAdmin
			Entry.find(params[:id]).destroy
			redirect_to session[:return_to] || '/entry/index'
		else
			flash[:notice] = "You can not delete this entry"
			redirect_to session[:return_to] || "/entry/index"
		end
	end
end
