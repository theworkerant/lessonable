$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lessonable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lessonable"
  s.version     = Lessonable::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Lessonable."
  s.description = "TODO: Description of Lessonable."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.1"

  s.add_development_dependency "mysql2"
end
