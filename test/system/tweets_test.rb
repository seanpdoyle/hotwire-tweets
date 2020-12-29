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

  test "Visits a Tweet" do
    day_old= entries(:day_old)

    visit(root_path).then { click_on localize day_old.created_at, format: :short }

    assert_tweet day_old
  end
end
