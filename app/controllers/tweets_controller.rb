class TweetsController < ApplicationController
  def index
    tweets = Tweet.all

    render locals: { tweets: tweets }
  end

  def new
    render locals: { tweet: Tweet.new }
  end

  def create
    Tweet.create!(params.require(:tweet).permit(:content))

    redirect_to root_url
  end
end
