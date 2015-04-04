require 'coverage'

require 'coverage_peeker'
require 'what_to_run/tracker'

WhatToRun::Tracker.start

Coverage.start

RSpec.configuration.after(:suite) do
  WhatToRun::Tracker.finish
  Coverage.result
end

RSpec.configuration.around(:example) do |example|
  before = CoveragePeeker.peek_result
  example.call
  after = CoveragePeeker.peek_result
  WhatToRun::Tracker.track example.full_description, before, after
end
