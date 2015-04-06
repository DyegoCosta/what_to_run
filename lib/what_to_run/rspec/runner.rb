require 'what_to_run/runner'
require 'shellwords'

module WhatToRun
  module RSpec
    ##
    # Runs RSpec with predicted examples
    class Runner < WhatToRun::Runner
      DEFAULT_RSPEC_EXECUTABLE = 'bundle exec rspec'.freeze

      attr_reader :rspec_executable

      def initialize(opts = {})
        @rspec_executable = opts[:exec] || DEFAULT_RSPEC_EXECUTABLE
      end

      def command
        "#{rspec_executable} #{predicted_example_args}"
      end

      private

      def predicted_example_args
        args = predicted_examples.flat_map { |example| ['-e', example] }
        Shellwords.join(args)
      end
    end
  end
end
