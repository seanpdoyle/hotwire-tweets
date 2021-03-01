ActiveSupport.on_load :action_dispatch_integration_test do
  include(Module.new do
    require "capybara/minitest"
    require "action_text/system_test_helper"

    include Capybara::Minitest::Assertions
    include ActionText::SystemTestHelper

    Capybara.default_normalize_ws = true

    def page
      Capybara.string(document_root_element)
    end
  end)
end
