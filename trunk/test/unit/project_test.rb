require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def test_getAll
	@projects = Project.find(:all)
	assert @projects.length == 3
	assert_not_equal @projects.length, 2
  end

  def test_uniqueName
	@project = Project.new
	@project.name = 'production'
	@project.description = " "
	@project.owner_id = '1'
	@project.chartered = '1'
	@project.team_id = '1'
	assert_equal @project.save, false
  end
end
