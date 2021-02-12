class ApplicationController < ActionController::Base
  before_action { Current.session = Session.find session }
end
