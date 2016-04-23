$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "csv_importer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_importer"
  s.version     = CSVImporter::VERSION
  s.authors     = ["Mark Whitcher"]
  s.email       = ["mark@anidea.co"]
  s.homepage    = "TODO"
  s.summary     = "Imports a CSV file as ActiveRecord instances"
  s.description = "Imports a CSV file as ActiveRecord instances"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
