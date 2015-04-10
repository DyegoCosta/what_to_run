require 'what_to_run/cli'
require 'what_to_run/rspec/runner'

describe WhatToRun::CLI do
  describe '#run' do
    it 'aborts when no test framework is provided' do
      expect {subject.run(nil)}.to \
        raise_error 'Must specify a test framework'
    end

    it 'aborts when provided test framework isnt supported' do
      expect {subject.run(['foo'])}.to \
        raise_error 'Unsupported test framework: foo'
    end
  end

  describe '#parse_options!' do
    def call(*args)
      subject.send(:parse_options!, *args)
    end

    it 'parses execute' do
      expect(call(["--exec", "echo"])).to eq(exec: "echo")
    end

    it 'parses e' do
      expect(call(["-e", "echo"])).to eq(exec: "echo")
    end
  end

  describe '#load_runner' do
    def call(type)
      subject.send(:load_runner, type)
    end

    it 'requires and load rspec runner' do
      expect(subject).to receive(:require).with('what_to_run/rspec/runner')
      expect(call('rspec')).to eq(WhatToRun::RSpec::Runner)
    end

    it 'fails to load inexistent runner' do
      expect {call('foo')}.to raise_error(LoadError)
    end
  end
end
