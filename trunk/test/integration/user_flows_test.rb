require 'test_helper'

class UserFlowsTest < ActionController::IntegrationTest
	fixtures :all

	def test_login
		get "/index/login"
		assert_response :success
		post "/index/authenticate", :userform => {:username => 'admin1', :password => 'toor'}
		assert_response :redirect
		follow_redirect!
		assert_template "entry/index"
	end

	def test_makeUserAdmin
		login_admin
		post "/user/make_admin/", :id => '2'
		assert_response :redirect
		follow_redirect!
		assert_template "entry/index"
		@user = User.find(:first, :conditions => ['id =?', '2'])
		assert @user.isAdmin
	end

	def test_makeUserAdmin_fail
		login_manager
		post "/user/make_admin/", :id => '3'
		assert_response :redirect
		follow_redirect!
		assert_template "entry/index"
		@user = User.find(:first, :conditions => ['id =?', '3'])
		assert_equal false, @user.isAdmin
	end

	def test_removeAdmin
		test_makeUserAdmin
		post "/user/remove_admin/", :id => '2'
		follow_redirect!
		@user = User.find(:first, :conditions => ['id =?', '2'])
		assert_equal false, @user.isAdmin
	end
	
	def test_removeAdmin_fail
		login_admin
		post "/user/make_admin/", :id =>'1'
		assert_response :redirect
		follow_redirect!
		assert_template "entry/index"
		@user = User.find(:first, :conditions => ['id =?', '1'])
		assert_equal true, @user.isAdmin
	end

	def test_createUser
		login_admin
		post "/user/new/"
		post "/user/create/", :user => { :username => 'test1234', :first_name => 'test', :last_name => 'test', :email => 'test@test.com', :password => 'toor', :password_confirmation => 'toor', :team_id => '2', :isManager => '1'}
		assert_response :redirect
		follow_redirect!
		@users = User.find(:all)
		assert_equal @users.length, 5
		@user = User.find(:first, :conditions => ['username = ?', 'test1234'])
		assert_equal 'test1234', @user.username
	end

	def test_createUser_fail
		login_admin
		post "/user/new/"
		post "/user/create/", :user => { :username => 'test1', :first_name => 'test', :last_name => 'test', :email => 'test@test.com', :password => 'toor', :password_confirmation => 'toor', :team_id => '2', :isManager => '1'}
		assert_response :success
		assert_template "user/new"
	end

	def test_disableUser
		login_admin
		post "/user/disable/", :id => '2'
		assert_response :redirect
		follow_redirect!
		@user = User.find(:first, :conditions => ['id = ?', '2'])
		assert_equal false, @user.active
	end
	
	def test_enableUser
		login_admin
		@user = User.find(:first, :conditions => ['id = ?', '4'])
		assert_equal false, @user.active
		post "/user/enable/", :id => '4'
		assert_response :redirect
		follow_redirect!
		@user = User.find(:first, :conditions => ['id = ?', '4'])
		assert_equal true, @user.active
	end

	def test_deleteUser
		login_admin
		post "/user/delete/", :id => '4'
		assert_response :redirect
		assert_equal User.find(:all).length, 3	
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
end
