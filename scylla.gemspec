Gem::Specification.new do |s|
  s.name = %q{scylla}
  s.version = "0.9.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ashwin Hegde"]
  s.date = %q{2012-01-27}
  s.default_executable = %q{scylla}
  s.description = %q{Allows for text categorization by guessing the language of a given text using n-grams}
  s.email = %q{ahegde@zendesk.com}
  s.executables = ["scylla"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files       = Dir['lib/**/*'] + %w(README.rdoc)
  s.test_files  = Dir['test/**/*']
  s.executables = ['scylla']
  s.homepage = %q{http://github.com/hashwin/scylla}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.3}
  s.summary = %q{Ruby port of Textcat language guesser}
end

