class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @entries = @user.entries.not_trashed.activities.newest_to_oldest
  end
end
