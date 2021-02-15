require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "index renders all Tweets from newest to oldest, excluding replies" do
    minute_old, day_old, day_old_reply, week_old = entries(:minute_old, :day_old, :day_old_reply, :week_old)

    get root_path

    assert_no_tweet day_old_reply
    assert_tweet minute_old, position: 1
    assert_tweet day_old, position: 2
    assert_tweet week_old, position: 3
  end

  test "index excludes Trashed Tweets" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old).each(&:trashed!)

    get root_path

    assert_no_tweet minute_old
    assert_no_tweet day_old
    assert_no_tweet week_old
  end

  test "show raises an ActiveRecord::RecordNotFound error for a Trashed Tweet" do
    minute_old = entries(:minute_old).tap(&:trashed!)

    assert_raises(ActiveRecord::RecordNotFound) { get tweet_path(minute_old) }
  end
end
