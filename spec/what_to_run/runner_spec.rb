require 'what_to_run/runner'

describe WhatToRun::Runner do
  let(:executable) { 'bundle exec some_executable' }
  let(:runner) { described_class.new(exec: executable) }

  it 'requires a executable' do
    expect { described_class.new }.to \
      raise_error(KeyError, 'key not found: :exec')
  end

  describe '#predicted_example_args' do
    it 'raises an NotImplementedError' do
      expect { runner.send(:command) }.to raise_error \
        NotImplementedError, 'Subclass must override #predicted_example_args'
    end
  end

  describe '#command' do
    it 'is the default executable with predicted example args' do
      args = 'command args'
      allow(runner).to receive(:predicted_example_args).and_return args
      expect(runner.send(:command)).to eq("#{executable} #{args}")
    end
  end

  it_behaves_like 'a runner'
end
