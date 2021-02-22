require "application_system_test_case"

module Broadcasts
  module SignedIn
    class NotificationsTest < ApplicationSystemTestCase
      test "Subscribes to Stream updates to notify the User of new Activity" do
        alice, carol = users(:alice, :carol)
        month_old = entries(:month_old)
        new_tweet = Tweet.new(content: "<div>Ignore</div>")
        new_retweet = Retweet.new(tweet: month_old.tweet)
        new_reply = Tweet.new(content: "<div>I agree</div>")
        new_mention = Tweet.new(content: "<div>Hello, @carol</div>")
        new_subscription = Subscription.new(publisher: carol, subscriber: alice)

        sign_in_as carol
        toggle_disclosure "Notifications"
        within_disclosure "Notifications", expanded: true do
          assert_no_link

          perform_enqueued_jobs { Entry.enter! new_tweet, creator: alice }

          assert_no_link

          perform_enqueued_jobs { Entry.enter! new_retweet, creator: alice, parent: month_old }

          assert_link "alice retweeted one of your tweets."

          perform_enqueued_jobs { Entry.enter! new_reply, creator: alice, parent: month_old }

          assert_link "alice replied to one of your tweets."

          perform_enqueued_jobs {  Entry.enter! new_mention, creator: alice  }

          assert_link "alice mentioned you in a tweet."

          perform_enqueued_jobs {  Entry.enter! new_subscription, creator: alice }

          assert_link "alice started to follow you."
        end
      end
    end
  end
end
