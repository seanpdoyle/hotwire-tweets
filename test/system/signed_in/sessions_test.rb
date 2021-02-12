require "application_system_test_case"

class SignedIn::SessionsTest < ApplicationSystemTestCase
  test "Can sign out" do
    sign_in_as :alice

    assert_no_text "Sign in"

    toggle_disclosure("actions").then { click_on "Sign out" }

    assert_text "Sign in"
  end
end
