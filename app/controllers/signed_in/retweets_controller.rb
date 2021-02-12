module SignedIn
  class RetweetsController < ApplicationController
    def create
      entry = Entry.not_trashed.tweets.find(params[:tweet_id])

      Entry.enter! Retweet.new(tweet: entry.tweet), parent: entry

      redirect_back_or_to root_url
    end

    def destroy
      entry = Current.user.entries.retweets.find(params[:id])

      entry.trashed!

      redirect_back_or_to root_url
    end
  end
end
