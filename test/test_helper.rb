# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "capybara/rails"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class Test::Unit::TestCase
  # Seiten.config[:storage_type]      = :yaml
  # Seiten.config[:storage_file]      = File.join('..', 'fixtures', 'navigation.yml')
  # Seiten.config[:storage_directory] = File.join('app', 'pages')
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
