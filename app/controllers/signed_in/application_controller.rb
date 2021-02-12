module SignedIn
  class ApplicationController < ::ApplicationController
    before_action { head :forbidden unless Current.session.signed_in? }
  end
end
