require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test "show renders all Tweets from an author, sorted newest to oldest" do
    minute_old, day_old_retweet, week_old, month_old = entries(:minute_old, :day_old_retweet, :week_old, :month_old)

    get user_path(users(:alice))

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet week_old, position: 3
    assert_no_tweet month_old
  end

  test "show excludes Trashed activities" do
    minute_old = entries(:minute_old).tap(&:trashed!)

    get user_path(users(:alice))

    assert_no_tweet minute_old
  end
end
