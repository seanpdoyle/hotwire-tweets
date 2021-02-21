require "application_system_test_case"

class SignedIn::NotificationsTest < ApplicationSystemTestCase
  test "contains notifications for entries the User is involved in" do
    sign_in_as(:alice).then { toggle_disclosure "Notifications" }

    within_disclosure "Notifications" do
      assert_link "bob replied to one of your tweets."
      assert_link "bob retweeted one of your tweets."
      assert_link "bob started to follow you."
    end

    click_link("bob started to follow you.").then { assert_button "Follow" }
  end

  test "is omitted when the visitor is not signed in" do
    visit root_path

    assert_no_selector :disclosure_button, "Notifications"
  end
end
