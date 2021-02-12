module SignedIn
  class SessionsController < ApplicationController
    def destroy
      Current.session.destroy(session)

      redirect_to root_url
    end
  end
end
