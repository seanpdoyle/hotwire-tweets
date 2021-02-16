require "test_helper"

class SignedIn::UnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "create unsubscribes one User from another" do
    alice, bob = users(:alice, :bob)
    alice.subscribe_to bob

    sign_in_as alice
    assert_difference -> { alice.entries.subscriptions.trashed.count } => +1, -> { alice.publishers.count } => -1 do
      post user_unsubscriptions_path(bob)
    end

    assert_redirected_to user_url(bob)
  end

  test "create gracefully handles a missing subscription" do
    alice, bob = users(:alice, :bob)

    sign_in_as alice
    assert_no_difference [ -> { alice.entries.subscriptions.trashed.count }, -> { alice.publishers.count } ] do
      post user_unsubscriptions_path(bob)
    end

    assert_redirected_to user_url(bob)
  end
end
