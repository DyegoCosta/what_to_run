require 'what_to_run/runner'
require 'shellwords'

module WhatToRun
  module Minitest
    class Runner < WhatToRun::Runner
      DEFAULT_EXECUTABLE = 'bundle exec rake test'.freeze

      def initialize(opts = {})
        super({exec: DEFAULT_EXECUTABLE}.merge(opts))
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
