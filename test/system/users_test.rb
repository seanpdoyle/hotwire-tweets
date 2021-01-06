require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "Paginates a long list of Tweets authored by the User" do
    daysagobot = users(:daysagobot)
    tweets = daysagobot.entries.tweets.newest_to_oldest

    visit user_path(daysagobot)

    assert_tweet tweets.first
    assert_no_tweet tweets.offset(15).first

    click_on "Load more"

    assert_tweet tweets.first
    assert_tweet tweets.offset(15).first
    assert_no_tweet tweets.offset(45).first
    assert_equal current_url, user_url(daysagobot, page: 2)

    click_on "Load more"

    assert_tweet tweets.first
    assert_tweet tweets.offset(15).first
    assert_tweet tweets.offset(45).first
    assert_no_tweet tweets.offset(95).first
    assert_equal current_url, user_url(daysagobot, page: 3)

    click_on "Load more"

    assert_tweet tweets.first
    assert_tweet tweets.offset(15).first
    assert_tweet tweets.offset(45).first
    assert_tweet tweets.offset(95).first
    assert_no_tweet tweets.offset(195).first
    assert_equal current_url, user_url(daysagobot, page: 4)

    click_on "Load more"

    assert_tweet tweets.first
    assert_tweet tweets.offset(15).first
    assert_tweet tweets.offset(45).first
    assert_tweet tweets.offset(95).first
    assert_tweet tweets.offset(195).first
    assert_equal current_url, user_url(daysagobot, page: 5)
  end
end
