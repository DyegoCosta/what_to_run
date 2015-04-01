require 'json'
require 'rspec'

require 'coverage'
require 'coverage_peeker'

LOGS = []
Coverage.start

RSpec.configuration.after(:suite) {
  File.open('run_log.json', 'w') { |f| f.write JSON.dump LOGS }
}

RSpec.configuration.around(:example) do |example|
  before = CoveragePeeker.peek_result
  example.call
  after = CoveragePeeker.peek_result
  LOGS << [ example.full_description, before, after ]
end
