require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new redirects to tweets#index when already authenticated" do
    sign_in_as :alice
    get new_session_path

    assert_redirected_to root_url
  end

  test "#create with a valid username/password pairing writes to the session" do
    alice = users(:alice)

    sign_in_as alice

    assert_redirected_to root_url
    assert_equal alice, Session.find(session).user
  end

  test "#create with empty fields renders" do
    post sessions_path, params: {
      session: { username: "", password: "" }
    }

    assert_response :unprocessable_entity
    assert_field "Username", described_by: "can't be blank"
    assert_field "Password", described_by: "can't be blank"
  end

  test "#create with an invalid username/password pairing renders errors" do
    alice = users(:alice)

    post sessions_path, params: {
      session: { username: alice.username, password: "junk" }
    }

    assert_response :unprocessable_entity
    assert_text "is invalid"
    assert_field "Username", with: alice.username
    assert_field "Password"
  end
end
