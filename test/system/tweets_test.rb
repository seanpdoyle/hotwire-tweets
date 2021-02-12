require "application_system_test_case"

class TweetsTest < ApplicationSystemTestCase
  test "Views a feed of Tweets from newest to oldest" do
    minute_old, day_old, day_old_retweet, week_old, week_old_retweet = entries(:minute_old, :day_old, :day_old_retweet, :week_old, :week_old_retweet)

    visit root_path

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet day_old, position: 3
    assert_retweet week_old_retweet, position: 4
    assert_tweet week_old, position: 5
  end

  test "Views a feed of Tweets from an author" do
    alice = users(:alice)
    minute_old, day_old_retweet, week_old, month_old = entries(:minute_old, :day_old_retweet, :week_old, :month_old)

    visit user_path(alice)

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet,  position: 2
    assert_tweet week_old, position: 3
    assert_no_tweet month_old
  end

  test "Visits a Tweet and reads replies" do
    day_old, day_old_reply = entries(:day_old, :day_old_reply)

    visit(root_path).then { click_on localize(day_old.created_at, format: :short), match: :first }

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

  test "Cannot retweet a tweet unless they are signed in" do
    visit root_path

    assert_no_button "Retweet"
  end
end
