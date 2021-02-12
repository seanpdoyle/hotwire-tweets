require "test_helper"

class TweetTest < ActiveSupport::TestCase
  test "valid when the plain-text content's length is less than 280 characters" do
    tweet = Tweet.new(content: "<div>#{"!" * 280}</div>")

    valid = tweet.validate

    assert valid
    assert_empty tweet.errors
  end

  test "invalid when the content is empty" do
    tweet = Tweet.new(content: "")

    valid = tweet.validate

    assert_not valid
    assert_includes tweet.errors, :content
  end

  test "invalid when the plain-text content's length is more than 280 characters" do
    tweet = Tweet.new(content: "<div>#{"!" * 281}</div>")

    valid = tweet.validate

    assert_not valid
    assert_includes tweet.errors, :content
  end
end
