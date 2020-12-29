class TweetsController < ApplicationController
  def index
    @tweets = Entry.tweets.newest_to_oldest
  end

  def show
    @tweet = Entry.tweets.find(params[:id])
  end
end
