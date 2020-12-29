require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "create with a valid Tweet" do
    assert_difference -> { Tweet.count } => +1 do
      post tweets_path, params: { tweet: { content: "Hello, world" } }
    end

    assert_redirected_to root_url
    assert_equal "Hello, world", Tweet.last.content
  end

  test "create with an invalid HTML Tweet submission" do
    assert_no_difference -> { Tweet.count } do
      post tweets_path, params: { tweet: { content: "" } }
    end

    assert_response :unprocessable_entity
    assert_select "form", text: /can't be blank/
  end

  test "create with an invalid turbo_stream Tweet submission" do
    assert_no_difference -> { Tweet.count } do
      post tweets_path, params: { tweet: { content: "" } }, headers: { Accept: Mime[:turbo_stream] }
    end

    assert_turbo_stream action: "replace", target: dom_id(Tweet.new, :form)
  end
end
