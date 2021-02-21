class MentionsJob < ApplicationJob
  def perform(entry)
    return if entry.trashed?

    entry.tweet.mentioned_users.each do |user|
      Entry.enter! Mention.new(user: user), creator: entry.creator, parent: entry
    end
  end
end
