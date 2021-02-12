require "test_helper"

class EntryTest < ActiveSupport::TestCase
  test ".activities includes Tweets" do
    day_old, week_old = entries(:day_old, :week_old)

    activities = Entry.activities

    assert_includes activities, day_old
    assert_includes activities, week_old
  end

  test ".activities excludes Replies" do
    day_old_reply = entries(:day_old_reply)

    activities = Entry.activities

    assert_not_includes activities, day_old_reply
  end

  test ".activities includes Retweets" do
    week_old_retweet = entries(:week_old_retweet)

    activities = Entry.activities

    assert_includes activities, week_old_retweet
  end

  test ".trashed includes Trashed Entries and excludes not Trashed Entries" do
    day_old, week_old = entries(:day_old, :week_old).each(&:trashed!)

    trashed = Entry.trashed

    assert_includes trashed, day_old
    assert_includes trashed, week_old
  end

  test ".not_trashed includes Trashed Entries and excludes not Trashed Entries" do
    day_old, week_old = entries(:day_old, :week_old)

    trashed = Entry.not_trashed

    assert_includes trashed, day_old
    assert_includes trashed, week_old
  end

  test "#trashed? returns true when trashed, false otherwise" do
    day_old = entries(:day_old)

    freeze_time do
      assert_changes -> { day_old.trashed? }, from: false, to: true do
        day_old.trashed!
      end
    end
  end

  test "#trashed! marks the record as trashed" do
    day_old = entries(:day_old)

    freeze_time do
      assert_changes -> { day_old.trashed_at }, from: nil, to: Time.current do
        day_old.trashed!
      end
    end
  end
end
