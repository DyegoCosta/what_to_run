require 'what_to_run/runner'
require 'shellwords'

module WhatToRun
  module RSpec
    class Runner < WhatToRun::Runner
      DEFAULT_EXECUTABLE = 'bundle exec rspec'.freeze

      def initialize(opts = {})
        super({exec: DEFAULT_EXECUTABLE}.merge(opts))
      end

      private

      def predicted_example_args
        args = predicted_examples.flat_map { |example| ['-e', example] }
        Shellwords.join(args)
      end
    end
  end
end
