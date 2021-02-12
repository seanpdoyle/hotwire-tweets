require "test_helper"

class SignedIn::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#destroy logs the User out" do
    sign_in_as :alice

    delete session_path

    assert_redirected_to root_url
    assert_empty session
  end
end
