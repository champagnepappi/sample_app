require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
    assert_select "h5", "Its me again testing"
  end

  test "should get cv" do
    get :cv
    assert_response :success
    assert_select "h1", "WELCOME TO MY WORLD"
    assert_select "h2", "Contact Me"
    assert_select "li", "About"
    assert_select "p" , "Online"
    assert_select "p" , "Email"
    assert_select "p" , "Bondo"
    assert_select "div", "Copyrights 2016"
    assert_select "title", "CV | #{@base_title}"
end
end
