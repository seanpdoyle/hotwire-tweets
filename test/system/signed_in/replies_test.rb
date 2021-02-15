require "application_system_test_case"

class SignedIn::RepliesTest < ApplicationSystemTestCase
  test "Reply to a Tweet" do
    day_old, day_old_reply = entries(:day_old, :day_old_reply)

    sign_in_as :bob
    within_tweet(day_old) { click_on "Reply" }
    fill_in_rich_text_area "Content", with: "Tell me about it!"
    click_on "Create Tweet"

    assert_tweet day_old
    assert_tweet "Tell me about it!", position: 1
    assert_tweet day_old_reply, position: 2
  end
end
