require "application_system_test_case"

class SignedIn::TweetsTest < ApplicationSystemTestCase
  test "Tweets a message" do
    sign_in_as :alice
    click_on "New"
    fill_in_rich_text_area "Content", with: "Hello, world."
    click_on "Create Tweet"

    assert_tweet "Hello, world."
  end

  test "Deletes a tweet" do
    minute_old, day_old = entries(:minute_old, :day_old)

    sign_in_as(:alice)
    within_tweet(minute_old) { click_link localize(minute_old.created_at, format: :short) }
    click_on "Delete"

    assert_no_tweet minute_old
    assert_tweet day_old, position: 1
  end

  test "can't Tweet an empty message" do
    sign_in_as :alice

    click_on("New").then { click_on "Create Tweet" }

    assert_rich_text_area "Content", described_by: "can't be blank"
  end
end
