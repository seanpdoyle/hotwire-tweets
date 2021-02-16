require "test_helper"

class SignedIn::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "create subscribes one User to another" do
    alice, bob = users(:alice, :bob)

    sign_in_as alice
    assert_difference -> { alice.entries.subscriptions.count } => +1, -> { alice.publishers.count } => +1 do
      post user_subscriptions_path(bob)
    end

    assert_redirected_to user_url(bob)
  end

  test "create does not create a duplicate subscription" do
    alice, bob = users(:alice, :bob)

    sign_in_as(alice).then { post user_subscriptions_path(bob) }
    assert_no_difference [ -> { alice.entries.subscriptions.count }, -> { alice.publishers.count } ] do
      post user_subscriptions_path(bob)
    end

    assert_redirected_to user_url(bob)
  end
end
