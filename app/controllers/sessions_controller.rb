class SessionsController < ApplicationController
  before_action(only: :new) { redirect_to root_url if Current.session.signed_in? }

  def new
    @session = Session.new
  end

  def create
    @session = Current.session
    @session.assign_attributes(session_params)

    if @session.valid? && @session.sign_in!(session)
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
