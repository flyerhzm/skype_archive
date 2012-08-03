# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skype_archive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Richard Huang"]
  gem.email         = ["flyerhzm@gmail.com"]
  gem.description   = %q{skype archive client}
  gem.summary       = %q{skype archive for gii hackathon}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "skype_archive"
  gem.require_paths = ["lib"]
  gem.version       = SkypeArchive::VERSION

  gem.add_dependency "sqlite3"
  gem.add_dependency "sequel"
  gem.add_dependency "activesupport"
  gem.add_dependency "rest-client"
  gem.add_dependency "json"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "webmock"
end
