$:.push File.expand_path("../lib", __FILE__)

require "breeze/apply_online/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "breeze_apply_online"
  s.version     = Breeze::ApplyOnline::VERSION
  s.authors     = ["Matt Powell, Blair Neate, Isaac Freeman"]
  s.email       = ["isaac@leftclick.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Blorgh."
  s.description = "TODO: Description of Blorgh."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  # s.add_dependency "jquery-rails"

  #s.add_development_dependency "sqlite3"
end
