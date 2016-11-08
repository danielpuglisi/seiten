# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "capybara/rails"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  setup do
    Seiten::PageStore.set_current_page_store(storage_language: :en)
  end
  # Seiten.config[:storage_type]      = :yaml
  # Seiten.config[:storage_file]      = # File.join('dummy', '', 'navigation.yml')
  # Seiten.config[:storage_directory] = # File.join('app', 'pages')
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  setup do
    Seiten::PageStore.set_current_page_store(storage_language: :en)
  end
end
