# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "capybara/rails"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Seiten.config[:pages_dir] = 'test/dummy/app/pages'

FIXTURES_DIR = File.join(File.dirname(__FILE__), 'fixtures')
