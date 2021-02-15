module SignedIn
  class RepliesController < ApplicationController
    def new
      @tweet = Entry.not_trashed.tweets.find(params[:tweet_id])
      @reply = Tweet.new
    end

    def create
      @tweet = Entry.not_trashed.tweets.find(params[:tweet_id])
      @reply = Tweet.new params.require(:tweet).permit(:content)

      if @reply.valid?
        Entry.enter! @reply, parent: @tweet

        redirect_to tweet_url(@tweet)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
end
