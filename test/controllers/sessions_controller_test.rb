require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get 'sessions/show'
    assert_response :success
  end

end
