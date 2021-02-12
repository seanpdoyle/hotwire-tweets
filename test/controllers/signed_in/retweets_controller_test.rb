require "test_helper"

class RetweetsControllerTest < ActionDispatch::IntegrationTest
  test "create saves the tweet and attributes it to the author" do
    minute_old = entries(:minute_old)
    alice, bob = users(:alice, :bob)

    sign_in_as bob
    assert_difference -> { bob.entries.tweets.count } => 0, -> { bob.entries.retweets.count } => +1 do
      post tweet_retweets_path(minute_old)
    end

    retweet = bob.entries.retweets.last
    assert_redirected_to root_url
    assert_equal bob, retweet.creator
    assert_equal alice, retweet.parent.creator
    assert_equal minute_old, retweet.parent
  end

  test "create raises an ActiveRecord::RecordNotFound for a Trashed Tweet" do
    minute_old = entries(:minute_old).tap(&:trashed!)

    sign_in_as :bob
    assert_raises ActiveRecord::RecordNotFound do
      post tweet_retweets_path(minute_old)
    end
  end

  test "destroy trashes a retweet without trashing the original Tweet" do
    alice, bob = users(:alice, :bob)
    entry = entries(:minute_old)
    retweet = Entry.enter! Retweet.new(tweet: entry.tweet), parent: entry, creator: bob

    sign_in_as bob
    assert_difference -> { alice.entries.trashed.count } => 0, -> { bob.entries.retweets.trashed.count } => +1 do
      delete retweet_path(retweet)
    end

    assert_redirected_to root_url
    assert_predicate retweet.reload, :trashed?
    assert_not_predicate entry.reload, :trashed?
  end
end
