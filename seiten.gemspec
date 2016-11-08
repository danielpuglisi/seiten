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

  s.add_development_dependency "rails", ">= 4.2"
  s.add_development_dependency "capybara", "~> 2.10"
end
