require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  def test_find
	@teams = Team.find(:all)
	assert @teams.length == 3, "There are 3 results"
	assert_not_equal @teams.length, 1
  end 

  def test_getAllTeamsBelongingToUser1
	@teams = Team.find(:all, :conditions => ['owner_id =?', '1'])
	assert_equal @teams.length, 2
  end

  def test_unique_name
	@team = Team.new
	@team.name = 'team3'
	@team.owner_id = '2'
	assert_equal @team.save, false
  end
end
