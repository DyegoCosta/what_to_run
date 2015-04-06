require 'what_to_run'

module WhatToRun
  ##
  # Abstract base spec runner
  class Runner
    def run
      if predicted_examples.empty?
        exit 0
      else
        Kernel.exec command
      end
    end

    def command
      fail NotImplementedError, 'Subclass must override #command'
    end

    def predicted_examples
      @predicted_examples ||= WhatToRun.predict
    end
  end
end
