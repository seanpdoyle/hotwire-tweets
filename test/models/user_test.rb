require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#subscribe_to creates a subscription from one User to another" do
    alice, bob = users(:alice, :bob)

    assert_difference -> { alice.publishers.count } => +1 do
      alice.subscribe_to bob
    end
  end

  test "#subscribe_to raises an error when self-subscribing" do
    alice = users(:alice)

    assert_raises(ActiveRecord::StatementInvalid) { alice.subscribe_to alice }
  end
end
