require 'test_helper'

class UserTest < ActiveSupport::TestCase
include ApplicationHelper

  def test_find #tests to ensure that all results are retrieved from the database
	@users = User.find(:all)
	assert @users.length == 4, "There 4 results"
	assert_not_equal @users.length, 1	
  end

  def test_isAdmin1_anAdmin
	@user = User.find(:first, :conditions => ['username = ?', 'admin1'])
	assert @user.isAdmin
  end

  def test_isManager1_anManager
	@user = User.find(:first, :conditions => ['username = ?', 'manager1'])
	assert @user.isManager
  end

  def test_isManager1_anAdmin
	@user = User.find(:first, :conditions => ['username = ?', 'manager1'])
	assert_equal(@user.isAdmin, false)
  end
  
  def test_validate_email_fails
	@user = User.find(:first, :conditions => ['username = ?', 'manager1'])
	@user.email = "test"
	assert_equal(@user.save, false)
  end

  def test_validate_password_confirmation_fails
	@user = User.find(:first, :conditions => ['username = ?', 'manager1'])
	@user.password = "test1"
	@user.password_confirmation = "test2"
	assert_equal(@user.save, false)
	
  end

  def test_unique_username
	@user = User.new
	@user.username = "admin1"
	@user.first_name = "test1"
	@user.last_name = "test1"
	@user.password = "12345"
	@user.password_confirmation = "12345"
	@user.email = "test@test.com"
	@user.team_id = '1'
	assert_equal(@user.save, false)
  end
end
