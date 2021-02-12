require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "invalid session renders errors" do
    visit(new_session_path).then { click_button "Sign in" }

    assert_field "Username", described_by: "can't be blank"
    assert_field "Password", described_by: "can't be blank"
  end
end
