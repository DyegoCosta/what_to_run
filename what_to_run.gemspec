Gem::Specification.new do |s|
  s.name        = 'what_to_run'
  s.version     = '1.0.0'
  s.date        = '2015-04-12'

  s.summary     = 'Regression test selection'
  s.description = 'Predict which tests are likely to fail after you’ve changed the code'
  s.authors     = ['Aaron Patterson', 'Dyego Costa']
  s.email       = 'dyego@dyegocosta.com'
  s.homepage    = 'https://github.com/DyegoCosta/what_to_run'
  s.license     = 'MIT'

  s.files       = ['README.md', 'Rakefile']
  s.files       += Dir.glob("ext/**/*.*")
  s.files       += Dir.glob("lib/**/*.rb")
  s.extensions  = %w[ext/coverage_peeker/extconf.rb]

  s.executables << 'what_to_run'
  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rake-compiler', '~> 0.9', '>= 0.9.0'

  s.add_runtime_dependency 'rugged', '~> 0.21', '>= 0.21.0'
  s.add_runtime_dependency 'sqlite3', '~> 1.3', '>= 1.3.10'
end
