class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @entries = @user.entries.not_trashed.activities.newest_to_oldest

    if params[:q].present?
      @entries = @entries.containing(params[:q])
    end
  end
end
