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

  test "Paginates a long list of Tweets" do
    daysagobot = users(:daysagobot)
    tweets = daysagobot.entries.tweets.newest_to_oldest

    visit root_path

    assert_tweet tweets.first
    assert_no_tweet tweets.offset(15).first

    click_on "Load more"

    assert_tweet tweets.offset(15).first
    assert_no_tweet tweets.first
    assert_no_tweet tweets.offset(45).first

    click_on "Load more"

    assert_tweet tweets.offset(45).first
    assert_no_tweet tweets.offset(15).first
    assert_no_tweet tweets.offset(95).first

    click_on "Load more"

    assert_tweet tweets.offset(95).first
    assert_no_tweet tweets.offset(45).first
    assert_no_tweet tweets.offset(195).first

    click_on "Load more"

    assert_tweet tweets.offset(195).first
    assert_no_tweet tweets.offset(95).first
  end

  test "Searches a feed of Tweets with a query" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old)

    visit root_path
    fill_in("Search", with: "can't wait until tonight").then { send_keys :enter }

    assert_tweet minute_old, position: 1
    assert_no_tweet day_old
    assert_no_tweet week_old
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
