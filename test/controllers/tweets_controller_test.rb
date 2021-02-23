require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "index renders all Tweets from newest to oldest, excluding replies" do
    minute_old, day_old, day_old_retweet, day_old_reply, week_old, week_old_retweet = entries(:minute_old, :day_old, :day_old_retweet, :day_old_reply, :week_old, :week_old_retweet)

    get root_path

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet day_old, position: 3
    assert_retweet week_old_retweet, position: 4
    assert_tweet week_old, position: 5
    assert_no_tweet day_old_reply
  end

  test "index includes Retweets" do
    day_old_retweet, week_old_retweet = entries(:day_old_retweet, :week_old_retweet)

    get root_path

    assert_retweet day_old_retweet
    assert_retweet week_old_retweet
  end

  test "index excludes Trashed Tweets" do
    minute_old, day_old, week_old = entries(:minute_old, :day_old, :week_old).each(&:trashed!)

    get root_path

    assert_no_tweet minute_old
    assert_no_tweet day_old
    assert_no_tweet week_old
  end

  test "index includes Retweets but omits the Trashed Tweet's contents" do
    week_old, week_old_retweet = entries(:week_old, :week_old_retweet)

    week_old.trashed!.then { get root_path }

    assert_no_tweet week_old
    assert_no_tweet week_old_retweet
    assert_tweet "Tweet Deleted"
  end

  test "index with a search query excludes unreleated Tweets" do
    minute_old, day_old, week_old, eight_days_ago = entries(:minute_old, :day_old, :week_old, :tweet_from_8_days_ago)

    get root_path(q: "can't wait until")

    assert_tweet minute_old, position: 1
    assert_tweet day_old, position: 2
    assert_tweet week_old, position: 3
    assert_no_tweet eight_days_ago
  end

  test "show raises an ActiveRecord::RecordNotFound error for a Trashed Tweet" do
    minute_old = entries(:minute_old).tap(&:trashed!)

    assert_raises(ActiveRecord::RecordNotFound) { get tweet_path(minute_old) }
  end
end
