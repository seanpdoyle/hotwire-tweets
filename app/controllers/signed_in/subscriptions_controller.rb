module SignedIn
  class SubscriptionsController < ApplicationController
    def create
      user = User.find(params[:user_id])
      Current.user.subscribe_to user

      redirect_back_or_to user_url(user)
    end
  end
end
