# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = %q{scylla}
  s.version     = "0.5.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ashwin Hegde"]
  s.email       = %q{ahegde@zendesk.com}
  s.homepage    = %q{http://github.com/hashwin/scylla}
  s.summary     =  %q{Ruby port of Textcat language guesser}
  s.description = %q{Allows for text categorization by guessing the language of a given text using n-grams}
  s.licenses = ["MIT"]
  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency("rake")
  s.add_development_dependency("bundler")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("ruby-debug")

  s.executables = ["scylla"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.require_paths = ["lib"]
  s.files        = Dir.glob("**/*")
  s.test_files   = Dir.glob("test/**/*")
  s.require_paths = [".", 'lib']
  
end