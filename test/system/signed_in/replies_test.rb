require "application_system_test_case"

class SignedIn::RepliesTest < ApplicationSystemTestCase
  test "Reply to a Tweet" do
    minute_old = entries(:minute_old)

    sign_in_as :bob
    within_tweet(minute_old) { click_on "Reply" }
    fill_in_rich_text_area "Content", with: "Tell me about it!"
    click_on "Create Tweet"

    assert_tweet minute_old
    assert_tweet "Tell me about it!", position: 1
  end
end
