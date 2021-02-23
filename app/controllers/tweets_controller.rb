class TweetsController < ApplicationController
  def index
    tweets = Entry.not_trashed.activities.newest_to_oldest

    if params[:q].present?
      tweets = tweets.containing(params[:q])
    end

    if Current.session.signed_in?
      tweets = tweets.where(creator: Current.user.publishers).or(tweets.where(creator: Current.user))
    end

    set_page_and_extract_portion_from tweets
  end

  def show
    @tweet = Entry.not_trashed.tweets.find(params[:id])
    entries = @tweet.children.not_trashed.replies.newest_to_oldest

    if params[:q].present?
      entries = entries.containing(params[:q])
    end

    set_page_and_extract_portion_from entries
  end
end
