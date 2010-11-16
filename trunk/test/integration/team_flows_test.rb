require 'test_helper'

class TeamFlowsTest < ActionController::IntegrationTest
	fixtures :all

	def test_teamList
		login_admin
		post "/team/list/"
		assert_response :success
	end

	def test_teamShow
		login_admin
		post "/team/show/", :id => '1'
		assert_response :success
	end

	def test_teamShow_fail
		login_admin
		post "/team/show/", :id => '4'
		assert_response :missing
	end

	def test_teamEdit
		login_admin
		post "/team/edit/", :id => '1'
		assert_response :success
	end

	def test_teamEdit_fail
		login_admin
		post "/team/edit/", :id => '4'
		assert_response :missing
	end

	def test_teamUpdate_teamName
		login_admin
		@team = Team.find(:first, :conditions => ['id =?', '1'])
		post "/team/update/", :id => '1', :team => {:name => 'test12345', :owner_id => @team.owner_id}
		assert_response :redirect 
		@team = Team.find(:first, :conditions => ['id =?', '1'])
		assert_equal 'test12345', @team.name
	end

	def test_teamUpdate_teamName_fail
		login_admin
		@team = Team.find(:first, :conditions => ['id =?', '2'])
		post "/team/update/", :id => '2', :team => {:name => 'team1', :owner_id => @team.owner_id}
		assert_response :error
		@team = Team.find(:first, :conditions => ['id =?', '2'])
		assert_equal 'team2', @team.name
	end

	def test_teamUpdate_teamOwner
		login_admin
		@team = Team.find(:first, :conditions => ['id =?', '1'])
		post "/team/update/", :id => '1', :team => {:name => @team.name, :owner_id => '2'}
		assert_response :redirect 
		@team = Team.find(:first, :conditions => ['id =?', '1'])
		assert_equal 2, @team.owner_id
	end

	def test_teamCreate
		login_admin
		@teams = Team.find(:all)
		post "/team/create/", :team => {:name => 'newTeam', :owner_id => '3'}
		assert_response :redirect
		follow_redirect!
		assert_not_equal @teams.length, Team.find(:all).length
	end

	def test_teamCreate_fail
		login_admin
		@teams = Team.find(:all)
		post "/team/create/", :team => {:name => 'team1', :owner_id => '3'}
		assert_response :success
		assert_equal @teams.length, Team.find(:all).length
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
