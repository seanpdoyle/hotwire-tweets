class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @entries = @user.entries.tweets.newest_to_oldest
  end
end
