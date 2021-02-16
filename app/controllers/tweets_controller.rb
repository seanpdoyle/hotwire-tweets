class TweetsController < ApplicationController
  def index
    @tweets = Entry.not_trashed.activities.newest_to_oldest

    if Current.session.signed_in?
      @tweets = @tweets.where(creator: Current.user.publishers).or(@tweets.where(creator: Current.user))
    end
  end

  def show
    @tweet = Entry.not_trashed.tweets.find(params[:id])
    @entries = @tweet.children.not_trashed.replies.newest_to_oldest
  end
end
