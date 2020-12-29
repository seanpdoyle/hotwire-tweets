require "test_helper"

class SignedIn::TweetsControllerTest < ActionDispatch::IntegrationTest
  test "create saves the tweet and attributes it to the author" do
    alice = users(:alice)

    sign_in_as alice
    assert_difference -> { Tweet.count } => +1 do
      post tweets_path, params: { tweet: { content: "<div>Hello, world!</div>" } }
    end

    tweet = alice.entries.tweets.last
    assert_equal alice, tweet.creator
    assert_equal "Hello, world!", tweet.content.to_plain_text
    assert_includes alice.entries.tweets, tweet.entry
  end

  test "create with an invalid HTML Tweet submission" do
    sign_in_as :alice

    assert_no_difference -> { Tweet.count } do
      post tweets_path, params: { tweet: { content: "" } }
    end

    assert_response :unprocessable_entity
    assert_rich_text_area described_by: "can't be blank"
  end

  test "create with an invalid Turbo Stream Tweet submission" do
    sign_in_as :alice

    assert_no_difference -> { Tweet.count } do
      post tweets_path, params: { tweet: { content: "" } }, as: :turbo_stream
    end

    assert_response :unprocessable_entity
    assert_css %(turbo-stream[action="replace"][target="new_tweet"]), count: 1
  end

  test "create requires a signed in session" do
    post tweets_path

    assert_response :forbidden
  end

  test "destroy trashes the tweet" do
    alice = users(:alice)
    tweet = entries(:minute_old)

    sign_in_as alice
    assert_difference -> { alice.entries.tweets.trashed.count } => +1 do
      delete tweet_path(tweet)
    end

    assert_redirected_to root_url
    assert_predicate tweet.reload, :trashed?
  end

  test "destroy on an original tweet does not trash Retweets" do
    alice, bob = users(:alice, :bob)
    minute_old = entries(:minute_old)
    retweet = Entry.enter! Retweet.new(tweet: minute_old.tweet), parent: minute_old, creator: bob

    sign_in_as alice
    assert_difference -> { alice.entries.count } => 0, -> { alice.entries.trashed.tweets.count } => +1, -> { bob.entries.count } => 0 do
      delete tweet_path(minute_old)
    end

    assert_redirected_to root_url
    assert_not_predicate retweet.reload, :trashed?
    assert_predicate minute_old.reload, :trashed?
  end

  test "destroy requires the Current user is the Tweet's author" do
    bob = users(:bob)
    tweet = entries(:minute_old)

    sign_in_as bob
    assert_raises(ActiveRecord::RecordNotFound) do
      delete tweet_path(tweet)
    end
  end

  test "destroy requires a signed in session" do
    tweet = entries(:minute_old)

    delete tweet_path(tweet)

    assert_response :forbidden
  end

  test "index collects Tweets from the User's subscriptions" do
    minute_old, minute_old_reply = entries(:minute_old, :minute_old_reply)
    day_old, day_old_retweet, day_old_reply = entries(:day_old, :day_old_retweet, :day_old_reply)
    week_old, month_old = entries(:week_old, :month_old)
    alice, bob = users(:alice, :bob)
    bob.subscribe_to alice

    sign_in_as(bob).then { get root_url }

    assert_tweet minute_old, position: 1
    assert_retweet day_old_retweet, position: 2
    assert_tweet day_old, position: 3
    assert_tweet week_old, position: 4
    assert_no_tweet minute_old_reply
    assert_no_tweet day_old_reply
    assert_no_tweet month_old
  end
end
