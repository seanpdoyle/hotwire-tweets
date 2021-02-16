module SignedIn
  class UnsubscriptionsController < ApplicationController
    def create
      user = User.find(params[:user_id])
      Current.user.unsubscribe_from user

      redirect_back_or_to user_url(user)
    end
  end
end
