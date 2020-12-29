require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::TranslationHelper
  include TweetsTestHelper

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
