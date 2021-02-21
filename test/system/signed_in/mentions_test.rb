require "application_system_test_case"

class SignedIn::MentionsTest < ApplicationSystemTestCase
  test "Tweeting a message that mentions a user notifies them" do
    sign_in_as(:alice).then { click_on "New" }
    fill_in_rich_text_area("Content", with: "<div>Hello, @bob</div>")

    perform_enqueued_jobs { click_on "Create Tweet" }

    using_session "bob's session" do
      sign_in_as(:bob)
      toggle_disclosure "Notifications"
      within_disclosure "Notifications" do
        assert_link "alice mentioned you in a tweet."
      end
    end
  end
end
