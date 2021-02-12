class Current < ActiveSupport::CurrentAttributes
  attribute :session

  delegate :user, to: :session
end
