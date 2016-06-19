require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: "kevin santos", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "    "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "   "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 51 + "@gmail.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_addresses|
  		@user.email = valid_addresses
  		assert @user.valid?, "#{valid_addresses.inspect} should be valid"
  		end
  	end
  	test "email validation should reject invalid addresses" do
  		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
  		invalid_addresses.each do |invalid_addresses|
  			@user.email = invalid_addresses
  			assert_not @user.valid?, "#{invalid_addresses.inspect} should be invalid"
  		end
  	end

  	test "email addresses should be unique" do
    	dupilicate_user = @user.dup
    	dupilicate_user.email = @user.email.upcase
    	@user.save
    	assert_not dupilicate_user.valid?
  	end  

    test "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5
      assert_not @user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    kevin = users(:kevin)
    dave  = users(:dave)
    assert_not kevin.following?(dave)
    kevin.follow(dave)
    assert kevin.following?(dave)
    assert dave.followers.include?(kevin)
    kevin.unfollow(dave)
    assert_not kevin.following?(dave)
  end

  test "feed should have the right posts" do
    kevin  = users(:kevin)
    junior = users(:junior)
    dave   = users(:dave)
    # Posts from followed user
    junior.microposts.each do |post_following|
      assert kevin.feed.include?(post_following)
    end
    # Posts from self
    kevin.microposts.each do |post_self|
      assert kevin.feed.include?(post_self)
    end
    # Posts from unfollowed user
    dave.microposts.each do |post_unfollowed|
      assert_not kevin.feed.include?(post_unfollowed)
    end
  end
end
