Gem::Specification.new do |s|
  s.name        = 'what_to_run'
  s.version     = '0.0.1.pre'
  s.date        = '2015-03-30'

  s.summary     = 'Regression test selection'
  s.description = 'Predict which tests are likely to fail after you’ve changed the code'
  s.authors     = ['Aaron Patterson', 'Dyego Costa']
  s.email       = 'dyego@dyegocosta.com'
  s.homepage    = 'https://github.com/DyegoCosta/what_to_run'
  s.license     = 'MIT'

  s.files       = 'README.md'
  s.files       += Dir.glob("lib/**/*.*")
  s.extensions  = %w[ext/coverage_peeker/extconf.rb]

  s.executables << 'what_to_run'
  s.required_ruby_version = '~> 2.3'

  s.add_development_dependency 'rake-compiler', '~> 0.9', '>= 0.9.0'
  s.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'

  s.add_runtime_dependency 'rugged', '~> 0.21', '>= 0.21.0'
end
