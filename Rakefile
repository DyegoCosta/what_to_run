require 'rspec/core/rake_task'
require 'rake/extensiontask'

Rake::ExtensionTask.new('coverage_peeker') do |ext|
  ext.lib_dir = 'lib/coverage_peeker'
end

RSpec::Core::RakeTask.new(:spec)

Rake::Task[:spec].prerequisites << :compile

task :default => :spec
