require 'test_helper'
require 'user_controller'

class UserControllerTest < ActionController::TestCase
 fixtures :users

 def setup
	@controller	= UserController.new
	@request	= ActionController::TestRequest.new
#	@response	= ActionController::TestResponse.new
 end

# def test_edit
#	get :edit, :id => '2'
#	#puts YAML::dump(@response)
#	puts YAML::dump(@user)
#	assert_not_nil assigns(@user)
#	#assert_equal assigns(@user).length, 1
#	assert_equal users(:admin1).isAdmin, assigns(@user).isAdmin
# end

end
