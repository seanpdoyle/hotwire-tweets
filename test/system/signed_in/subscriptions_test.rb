require "application_system_test_case"

class SignedIn::SubscriptionsTest < ApplicationSystemTestCase
  test "subscribing to a creator publishes their tweets to your feed" do
    alice, carol = users(:alice, :carol)
    minute_old, day_old_retweet, week_old, month_old = entries(:minute_old, :day_old_retweet, :week_old, :month_old)

    sign_in_as(carol).then { assert_no_tweet(minute_old) }
    visit user_path(alice)
    within_tweet(minute_old) { click_on alice.username }.then { click_on "Follow" }
    visit root_path

    assert_tweet minute_old, position: 1
    assert_tweet day_old_retweet.parent, position: 2
    assert_tweet week_old, position: 3
    assert_tweet month_old, position: 4
  end

  test "a User cannot follow themselves" do
    alice = users(:alice)

    sign_in_as(alice).then { click_on alice.username, match: :first }

    assert_no_text "Follow"
  end
end
