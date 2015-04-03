require 'coverage'

require 'coverage_peeker'
require 'what_to_run/tracker'

Coverage.start

RSpec.configuration.after(:suite) {WhatToRun::Tracker.dump}

RSpec.configuration.around(:example) do |example|
  before = CoveragePeeker.peek_result
  example.call
  after = CoveragePeeker.peek_result
  WhatToRun::Tracker.track before, after, example.full_description
end
