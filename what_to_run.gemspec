Gem::Specification.new do |s|
  s.name        = 'what_to_run'
  s.version     = '0.0.0'
  s.date        = '2015-03-30'
  s.summary     = 'Regression test selection'
  s.description = 'Predict which tests are likely to fail after you’ve changed the code'
  s.authors     = ['Aaron Patterson', 'Dyego Costa']
  s.email       = 'dyego@dyegocosta.com'
  s.files       = 'README.md'
  s.files       += Dir.glob("lib/**/*.rb")
  s.homepage    = 'https://github.com/DyegoCosta/what_to_run'
  s.license     = 'MIT'
  s.executables << 'what_to_run'

  s.add_runtime_dependency 'rugged', '~> 0.21', '>= 0.21.0'
end
