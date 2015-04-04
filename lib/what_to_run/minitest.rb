require 'coverage'

require 'coverage_peeker'
require 'what_to_run/tracker'

WhatToRun::Tracker.start

Coverage.start

require 'minitest'

class Minitest::Runnable
  Minitest.after_run {WhatToRun::Tracker.finish}

  class << self
    alias :old_run_one_method :run_one_method

    def run_one_method klass, method_name, reporter
      before = CoveragePeeker.peek_result
      old_run_one_method klass, method_name, reporter
      after = CoveragePeeker.peek_result
      WhaToRun::Tracker.track "#{klass.name}##{method_name.to_s}", before, after
    end
  end
end
