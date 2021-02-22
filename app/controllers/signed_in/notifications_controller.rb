module SignedIn
  class NotificationsController < ApplicationController
    def index
      set_page_and_extract_portion_from Current.user.notifications
    end
  end
end
