$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "testgdsauth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "testgdsauth"
  s.version     = Testgdsauth::VERSION
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.homepage    = "localhost:3000"
  s.summary     = "Summary of Testgdsauth."
  s.description = "Description of Testgdsauth."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
end
