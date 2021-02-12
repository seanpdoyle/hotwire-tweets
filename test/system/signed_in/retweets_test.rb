require "application_system_test_case"

class SignedIn::RetweetsTest < ApplicationSystemTestCase
  test "Retweet a message to your own feed" do
    minute_old = entries(:minute_old)
    alice, bob = users(:alice, :bob)

    sign_in_as(bob).then { click_on alice.username, match: :first }
    within_tweet(minute_old) { click_on "Retweet" }
    visit(root_path).then { click_on bob.username, match: :first }

    within_tweet minute_old, match: :first do
      assert_button "Retweet", count: 0
      assert_button "Reply", count: 0
    end
  end

  test "Retweeting yourself hides embedded buttons" do
    minute_old = entries(:minute_old)

    sign_in_as :alice
    within_tweet(minute_old) { click_on "Retweet" }

    within_tweet minute_old do
      assert_button "Delete", count: 1
      assert_button "Retweet", count: 0
      assert_button "Reply", count: 0
    end
  end
end
