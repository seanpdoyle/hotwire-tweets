require "application_system_test_case"

class TweetsTest < ApplicationSystemTestCase
  test "Tweets a message" do
    visit root_path
    click_on "New"
    fill_in "Content", with: "Hello, world."
    click_on "Tweet"

    assert_text "Hello, world."
  end
end
