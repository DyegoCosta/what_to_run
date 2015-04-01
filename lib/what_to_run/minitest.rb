require 'json'
require 'coverage'
require 'coverage_peeker'

Coverage.start

require 'minitest'

class Minitest::Runnable
  LOGS = []

  Minitest.after_run {
    File.open('run_log.json', 'w') { |f| f.write JSON.dump LOGS }
  }

  class << self
    alias :old_run_one_method :run_one_method

    def run_one_method klass, method_name, reporter
      before = CoveragePeeker.peek_result
      old_run_one_method klass, method_name, reporter
      after = CoveragePeeker.peek_result
      LOGS << [ klass.name, method_name.to_s, before, after ]
    end
  end
end
