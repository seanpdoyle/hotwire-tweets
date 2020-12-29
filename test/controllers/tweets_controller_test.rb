require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "index renders all Tweets from newest to oldest" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old)

    get root_path

    assert_tweet minute_old, position: 1
    assert_tweet day_old, position: 2
    assert_tweet week_old, position: 3
  end
end
