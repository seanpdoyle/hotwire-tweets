require "application_system_test_case"

module Broadcasts
  module SignedIn
    class TweetsTest < ApplicationSystemTestCase
      test "Subscribes to Stream updates from their followers" do
        alice = users(:alice)
        minute_old = entries(:minute_old)
        new_tweet = Tweet.new(content: "<div>Hello, from Streams</div>")
        new_reply = Tweet.new(content: "<div>I agree</div>")
        new_retweet = Retweet.new(tweet: minute_old.tweet)

        sign_in_as :bob

        assert_tweet minute_old, position: 1

        perform_enqueued_jobs { Entry.enter! new_tweet, creator: alice }

        assert_tweet new_tweet, position: 1
        assert_tweet minute_old, position: 2

        perform_enqueued_jobs { Entry.enter! new_retweet, creator: alice, parent: minute_old }

        assert_retweet new_retweet.entry, position: 1
        assert_tweet new_tweet, position: 2
        assert_tweet minute_old, position: 3

        perform_enqueued_jobs { Entry.enter! new_reply, creator: alice, parent: minute_old }

        assert_no_tweet new_reply
        assert_retweet new_retweet.entry, position: 1
        assert_tweet new_tweet, position: 2
        assert_tweet minute_old, position: 3
      end
    end
  end
end
