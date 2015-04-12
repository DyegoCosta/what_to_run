require 'what_to_run'

module WhatToRun
  ##
  # Abstract base spec runner
  class Runner
    attr_reader :executable, :collect

    def initialize(opts = {})
      @executable = opts.fetch(:exec)
    end

    def run
      if predicted_examples.empty?
        exit 0
      else
        Kernel.exec command
      end
    end

    private

    def command
      "#{executable} #{predicted_example_args}"
    end

    def predicted_example_args
      fail NotImplementedError, 'Subclass must override #predicted_example_args'
    end

    def predicted_examples
      @predicted_examples ||= WhatToRun.predict
    end
  end
end
