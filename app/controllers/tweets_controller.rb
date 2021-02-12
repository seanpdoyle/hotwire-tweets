class TweetsController < ApplicationController
  def index
    @tweets = Entry.not_trashed.tweets.newest_to_oldest
  end

  def show
    @tweet = Entry.not_trashed.tweets.find(params[:id])
  end
end
