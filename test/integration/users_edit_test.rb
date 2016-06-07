require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:kevin)
  end

  test "unsuccessfull edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: { name: "", eamil: "foo@invalid", password: "foo", password_confirmation: "bar" }
  	assert_template 'users/edit'
  end

  test "successful edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	name = "foo bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user: {name: name, email: email, password: "", password_confirmation: "" }
  	assert_not flash.empty?
  	assert_redirected_to @user
  	@user.reload
  	assert_equal @user.name, name
  	assert_equal @user.email, email
  end
end
