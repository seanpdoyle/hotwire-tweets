require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::TranslationHelper
  include CapybaraTestHelper
  include TweetsTestHelper

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def sign_in_as(user)
    username =
      case user when Symbol then users(user).username
      else user.username
      end

    visit new_session_path
    fill_in "Username", with: username
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end
