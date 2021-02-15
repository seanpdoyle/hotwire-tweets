module SignedIn
  class TweetsController < ApplicationController
    def new
      @tweet = Tweet.new
    end

    def create
      @tweet = Tweet.new(params.require(:tweet).permit(:content))

      if @tweet.valid?
        Entry.enter! @tweet

        redirect_to root_url
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      tweet = Current.user.entries.find(params[:id])

      tweet.trashed!

      redirect_to root_url
    end
  end
end
