require "application_system_test_case"

class TweetsTest < ApplicationSystemTestCase
  test "Views a feed of Tweets from newest to oldest" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old)

    visit root_path

    assert_tweet minute_old, position: 1
    assert_tweet day_old, position: 2
    assert_tweet week_old, position: 3
  end

  test "Views a feed of Tweets from an author" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old)

    visit root_path
    within_tweet(minute_old) { click_on minute_old.creator.username }

    assert_tweet minute_old, position: 1
    assert_tweet week_old, position: 2
    assert_no_tweet day_old
  end

  test "Visits a Tweet and reads replies" do
    day_old, day_old_reply = entries(:day_old, :day_old_reply)

    visit(root_path).then { click_on localize day_old.created_at, format: :short }

    assert_tweet day_old
    assert_tweet day_old_reply, position: 1
  end

  test "Cannot tweet unless logged in" do
    visit root_path

    assert_no_text "New"
  end

  test "Cannot reply unless logged in" do
    day_old = entries(:day_old)

    visit tweet_path(day_old)

    assert_no_button "Reply"
  end

  test "Cannot delete a tweet unless they authored it" do
    visit root_path

    assert_no_button "Delete"
  end
end
