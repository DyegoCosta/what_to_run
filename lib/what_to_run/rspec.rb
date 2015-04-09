configure = -> do
  require 'coverage'
  require 'coverage_peeker'
  require 'what_to_run/tracker'

  Coverage.start

  RSpec.configuration.before(:suite) do
    WhatToRun::Tracker.start
  end

  RSpec.configuration.after(:suite) do
    WhatToRun::Tracker.finish
    Coverage.result
  end

  RSpec.configuration.around(:each) do |example|
    before = CoveragePeeker.peek_result
    example.call
    after = CoveragePeeker.peek_result

    WhatToRun::Tracker.track \
      example.metadata[:full_description], before, after
  end
end

configure.call if ENV['COLLECT']
