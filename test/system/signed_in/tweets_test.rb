require "application_system_test_case"

class SignedIn::TweetsTest < ApplicationSystemTestCase
  test "Tweets a message" do
    sign_in_as :alice
    click_on "New"
    fill_in_rich_text_area "Content", with: "Hello, world."
    click_on "Create Tweet"

    assert_tweet "Hello, world."
  end

  test "Deletes a tweet" do
    minute_old, day_old, day_old_retweet, week_old, week_old_retweet = entries(:minute_old, :day_old, :day_old_retweet, :week_old, :week_old_retweet)

    sign_in_as(:bob)

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet day_old, position: 3
    assert_retweet week_old_retweet, position: 4
    assert_tweet week_old, position: 5

    within_retweet(week_old_retweet) { click_on "Delete" }

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet day_old, position: 3
    assert_tweet week_old, position: 4
  end

  test "can't Tweet an empty message" do
    sign_in_as :alice

    click_on("New").then { click_on "Create Tweet" }

    assert_rich_text_area "Content", described_by: "can't be blank"
  end
end
