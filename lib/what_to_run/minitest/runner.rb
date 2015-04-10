require 'what_to_run/runner'
require 'shellwords'

module WhatToRun
  module Minitest
    class Runner < WhatToRun::Runner
      DEFAULT_MINITEST_EXECUTABLE = 'bundle exec rake test'.freeze

      attr_reader :minitest_executable

      def initialize(opts = {})
        @minitest_executable = opts[:exec] || DEFAULT_MINITEST_EXECUTABLE
      end

      def command
        "#{minitest_executable} #{predicted_example_args}"
      end

      private

      def predicted_example_args
        patterns = predicted_examples.flat_map do |example|
          "^#{example}$"
        end

        examples = patterns.join('|')

        name_arg = Shellwords.escape("--name=/#{examples}/")

        "TESTOPTS=\"#{name_arg}\""
      end
    end
  end
end
