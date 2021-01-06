class TweetsController < ApplicationController
  def index
    set_page_and_extract_portion_from Tweet.order(created_at: :desc)

    render locals: { tweets: @page.records, page: @page }
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
