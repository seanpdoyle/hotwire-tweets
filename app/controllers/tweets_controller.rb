class TweetsController < ApplicationController
  def index
    tweets = Tweet.all

    render locals: { tweets: tweets }
  end

  def new
    render locals: { tweet: Tweet.new }
  end

  def create
    tweet = Tweet.new(params.require(:tweet).permit(:content))

    if tweet.save
      redirect_to root_url
    else
      respond_to do |format|
        format.turbo_stream { render locals: { tweet: tweet } }
        format.html { render :new, locals: { tweet: tweet }, status: :unprocessable_entity }
      end
    end
  end
end
