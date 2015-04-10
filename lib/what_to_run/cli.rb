require 'optparse'
require 'shellwords'

module WhatToRun
  class CLI
    def run(argv)
      framework = Array(argv)[0]

      abort 'Must specify a test framework' unless framework

      options = parse_options!(argv)

      begin
        runner = load_runner(framework)
        runner.new(options).run
      rescue LoadError
        abort "Unsupported test framework: #{framework}"
      end
    end

    private

    def parse_options!(argv)
      options = {}

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: what_to_run <framework> [options]'

        opts.on('-e', '--exec EXECUTABLE', 'Alternate test runner executable') do |e|
          options[:exec] = e
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end

      parser.parse!(argv)

      options
    end

    def load_runner(framework)
      require "what_to_run/#{framework}/runner"
      klass_name = "WhatToRun::#{RUNNERS[framework]}::Runner"
      klass_name.split('::').inject(Object) {|x, y| x.const_get(y.to_sym)}
    end

    RUNNERS = {'rspec' => 'RSpec', 'minitest' => 'Minitest'}
  end
end
