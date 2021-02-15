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
end
