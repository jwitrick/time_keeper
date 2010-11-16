
require 'test_helper'

class EntryFlowsTest < ActionController::IntegrationTest

	def test_createEntries
		login_admin
		post "/entry/create/", :entry => {:name => "created 1", :duration => 3.4, :project_id => 1, :work_type => 'Testing', :description => 'this is a sample description'}
		assert_response :redirect
		follow_redirect!
		current_entries = assigns(:entries_current)
		assert_equal 1, current_entries.length
	end

	def test_show
		login_admin
		post "/entry/show/", :id => 1
		assert_response :success
		entry = assigns(:entry)
		assert_equal 4.3, entry[0].duration
	end

	def test_update
		login_admin
		post "/entry/update/", :id => 1, :entry => {:id => 1, :name => 'updated entry name', :duration => 4.3, :project_id => 1, :description => "added this test entry", :work_type => 'Testing'}
		assert_response :redirect
		follow_redirect!
		entry = Entry.find(:first, :conditions => ['id = ?', 1])
		assert_equal 'updated entry name', entry.name
	end

	def test_delete
		login_admin	
		post "/entry/delete/", :id => 1
		assert_response :redirect
		follow_redirect!
		assert_equal nil, Entry.find(:first, :conditions => ['id =?', 1])
	end

	def test_delete_fail
		login_manager	
		post "/entry/delete/", :id => 1
		assert_response :redirect
		follow_redirect!
		assert_equal 'You can not delete this entry', flash[:notice]
		assert_equal 1, Entry.find(:first, :conditions => ['id =?', 1]).id
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
