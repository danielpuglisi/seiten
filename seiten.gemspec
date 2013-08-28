$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seiten/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seiten"
  s.version     = Seiten::VERSION
  s.authors     = ["Daniel Puglisi"]
  s.email       = ["pulleasy@gmail.com"]
  s.homepage    = "http://danielpuglisi.com"
  s.summary     = "Static Pages for Rails."
  s.description = "Seiten lets you create static pages for your Rails project and provides you with some cool navigational helper likes breadcrumb or custom navigations."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"

  s.add_development_dependency "rails", "~> 3.2"
  s.add_development_dependency "sqlite3", "~> 1.3.7"
  s.add_development_dependency "capybara", "~> 2.1.0"
end
