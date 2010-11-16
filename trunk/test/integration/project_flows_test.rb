
require 'test_helper'

class ProjectFlowsTest < ActionController::IntegrationTest

	def test_list
		login_admin
		post "/project/list"
		assert_response :success
		projects = assigns(:projects)
		assert_equal 3, projects.length
	end


	def test_create
		login_admin
		post "/project/create/", :project => {:name => 'test project 2', :description => 'this handles test project 2', :owner_id => 1, :team_id => 2, :chartered => 'Yes'}
		assert_response :redirect
		follow_redirect!
		assert_equal 4, assigns(:projects).length	
	end

	def test_update
		login_admin
		post "/project/update/", :id => 1, :project => {:name => 'updated name', :description => 'updated desc', :owner_id => 2, :team_id => 1, :chartered => 'No'}
		assert_response :redirect
		follow_redirect!
		assert_equal 3, assigns(:projects).length
	end

	def test_diable
		login_admin
		post '/project/disable/', :id => 2
		assert_response :redirect
		follow_redirect!
		assert_equal false, Project.find(:first, :conditions => ['id = ?', 2]).active	
	end

	def test_disable_fail
		login_basic
		post '/project/disable/', :id => 2
		assert_response :redirect
		follow_redirect!
		assert_equal "You must be a manager to view this page", flash[:error]	

	end

	def test_enable
		login_admin
		post '/project/enable/', :id => 3
		assert_response :redirect
		follow_redirect!
		assert_equal true, Project.find(:first, :conditions => ['id = ?', 3]).active	
	end

	def test_edit_fail
		login_basic
		post "/project/edit/", :id => 1
		assert_response :redirect
		follow_redirect!
		assert_equal 'You must be a manager to view this page', flash[:error]
		assert_template 'entry/index'
	end

	def login_admin
		post "/index/authenticate", :userform => {:username => 'admin1', :password => 'toor'}
		assert_response :redirect
		follow_redirect!
	end

	def login_manager
		post "/index/authenticate", :userform => {:username => 'manager1', :password => 'toor'}
		assert_response :redirect
		follow_redirect!
	end
	def login_basic
		post "/index/authenticate", :userform => {:username => 'basic1', :password => 'toor'}
		assert_response :redirect
		follow_redirect!
	end
end
