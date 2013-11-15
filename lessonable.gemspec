$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem"s version:
require "lessonable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lessonable"
  s.version     = Lessonable::VERSION
  s.authors     = ["Graham Powrie"]
  s.email       = ["graham@theworkerant.com"]
  s.homepage    = "theworkerant.com"
  s.summary     = "Business logic for businesses that provide lessons"
  s.description = "Business logic for businesses that provide lessons"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency "cancan"
  s.add_dependency "cancan_strong_parameters"
  s.add_dependency "stripe"

  s.add_development_dependency "mysql2"
  
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "guard-rspec"  
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "timecop" 
  s.add_development_dependency "json_spec" 
  
  s.add_development_dependency "slim" 
  
  
end
