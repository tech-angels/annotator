$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "annotator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "annotator"
  s.version     = Annotator::VERSION
  s.authors     = ["Tech-Angels", "Kacper Cieśla"]
  s.email       = ["kacper.ciesla@tech-angels.com"]
  s.homepage    = "https://github.com/tech-angels/annotator"
  s.summary     = "Annotate your models and keep your comments about fields."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activerecord", "~> 3.0"

  s.add_development_dependency "sqlite3"
end
