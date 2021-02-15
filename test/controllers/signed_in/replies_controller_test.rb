require "test_helper"

class SignedIn::RepliesControllerTest < ActionDispatch::IntegrationTest
  test "create saves the tweet and groups it in the thread of replies" do
    bob = users(:bob)
    week_old = entries(:week_old)

    sign_in_as bob
    assert_difference -> { bob.entries.tweets.count } => +1, -> { week_old.children.replies.count } => +1 do
      post tweet_replies_path(week_old), params: { tweet: { content: "<div>First!</div>" } }
    end

    assert_redirected_to(tweet_path(week_old)).then { follow_redirect! }
    assert_includes week_old.children.replies, bob.entries.last
    assert_tweet "First!"
  end

  test "create with an invalid HTML Tweet submission" do
    alice = users(:alice)
    day_old = entries(:day_old)

    sign_in_as alice
    assert_no_difference [ -> { alice.entries.tweets.count }, -> { day_old.children.replies.count } ] do
      post tweet_replies_path(day_old), params: { tweet: { content: "" } }
    end

    assert_response :unprocessable_entity
    assert_rich_text_area described_by: "can't be blank"
  end

  test "create raises ActiveRecord::RecordNotFound for a Trashed subject" do
    day_old = entries(:day_old).tap(&:trashed!)

    sign_in_as :alice
    assert_raises ActiveRecord::RecordNotFound do
      post tweet_replies_path(day_old)
    end
  end

  test "new raises ActiveRecord::RecordNotFound for a Trashed subject" do
    day_old = entries(:day_old).tap(&:trashed!)

    sign_in_as :alice
    assert_raises ActiveRecord::RecordNotFound do
      get new_tweet_reply_path(day_old)
    end
  end
end
