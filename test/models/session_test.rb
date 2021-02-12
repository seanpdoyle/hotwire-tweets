require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "invalid when username is blank" do
    session = Session.new(username: "")

    valid = session.validate :sign_in

    assert_not valid
    assert_includes session.errors, :username
  end

  test "invalid when password is blank" do
    session = Session.new(password: "")

    valid = session.validate :sign_in

    assert_not valid
    assert_includes session.errors, :password
  end

  test "invalid when User does not exist" do
    record = Session.new(username: "junk", password: "junk")
    session = {}

    valid = record.sign_in!(session)

    assert_not valid
    assert_includes record.errors, :base
    assert_empty session
  end

  test "invalid when username and password pairing are incorrect" do
    alice = users(:alice)
    record = Session.new(username: alice.username, password: "junk")
    session = {}

    valid = record.sign_in!(session)

    assert_not valid
    assert_includes record.errors, :base
  end

  test "#sign_in! writes to the Session" do
    alice = users(:alice)
    session = {}

    record = Session.new username: alice.username, password: "password"
    signed_in = record.sign_in!(session)

    assert signed_in
    assert_empty record.errors
    assert_equal alice, record.user
    assert_equal alice.id, session[:user_id]
  end

  test "#destroy clears the session" do
    alice = users(:alice)
    session = { user_id: alice.id }
    record = Session.find(user_id: alice.id)

    record.destroy(session)

    assert_empty session
  end

  test "#signed_in? returns true when there is an associated User" do
    alice = users(:alice)

    session = Session.new user: alice

    assert_predicate session, :signed_in?
  end

  test "#signed_in? returns false when there is no User" do
    session = Session.new

    assert_not_predicate session, :signed_in?
  end
end
