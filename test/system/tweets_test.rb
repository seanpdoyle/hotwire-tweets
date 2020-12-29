require "application_system_test_case"

class TweetsTest < ApplicationSystemTestCase
  test "Tweets a message" do
    visit root_path
    click_on "New"
    fill_in "Content", with: "Hello, world."

    assert_difference -> { Tweet.count } => +1 do
      click_on("Tweet").then { assert_text "Hello, world." }
    end
  end

  test "can't Tweet an empty message" do
    visit root_path
    click_on "New"

    assert_no_difference -> { Tweet.count } do
      click_on("Tweet").then { assert_text "can't be blank" }
    end
  end
end
