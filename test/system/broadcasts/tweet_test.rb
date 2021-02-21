require "application_system_test_case"

module Broadcasts
  class TweetTest < ApplicationSystemTestCase
    test "Subscribes to Stream updates for the thread" do
      alice = users(:alice)
      minute_old, minute_old_reply = entries(:minute_old, :minute_old_reply)
      new_tweet = Tweet.new(content: "<div>Hello, from Streams</div>")
      new_reply = Tweet.new(content: "<div>I agree</div>")
      new_retweet = Retweet.new(tweet: minute_old.tweet)

      visit tweet_path(minute_old)

      assert_tweet minute_old, count: 1
      assert_tweet minute_old_reply, position: 1

      perform_enqueued_jobs { Entry.enter! new_tweet, creator: alice }

      assert_no_tweet new_tweet
      assert_tweet minute_old, count: 1
      assert_tweet minute_old_reply, position: 1

      perform_enqueued_jobs { Entry.enter! new_retweet, creator: alice, parent: minute_old }

      assert_tweet minute_old, count: 1
      assert_tweet minute_old_reply, position: 1

      perform_enqueued_jobs { Entry.enter! new_reply, creator: alice, parent: minute_old }

      assert_tweet minute_old, count: 1
      assert_tweet new_reply, position: 1, count: 1
      assert_tweet minute_old_reply, position: 2
    end
  end
end
