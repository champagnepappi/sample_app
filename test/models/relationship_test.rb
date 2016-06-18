require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    kevin = users(:kevin)
    junior  = users(:junior)
  	@relationship = Relationship.new(follower_id: kevin.id, followed_id: junior.id)
  end


  test "should be valid" do
  	assert @relationship.valid?
  end

  test "should require a follower_id" do
  	@relationship.follower_id = nil
  	assert_not @relationship.valid?
  end

  test "should require followed_id" do
  	@relationship.followed_id = nil
  	assert_not @relationship.valid?
  end
end
