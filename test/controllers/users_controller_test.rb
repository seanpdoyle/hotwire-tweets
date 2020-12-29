require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test "show renders all Tweets from an author, sorted newest to oldest" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old)

    get user_path(users(:alice))

    assert_tweet minute_old, position: 1
    assert_tweet week_old, position: 2
    assert_no_tweet day_old
  end
end
