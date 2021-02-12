ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

Rails.root.join("test", "test_helpers").glob("**/*.rb").each { require _1 }

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include CapybaraTestHelper
  include TweetsTestHelper

  def sign_in_as(user)
    username =
      case user when Symbol then users(user).username
      else user.username
      end

    post sessions_path, params: {
      session: { username: username, password: "password" }
    }
  end
end
