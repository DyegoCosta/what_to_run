require 'what_to_run/rspec/runner'

describe WhatToRun::RSpec::Runner do
  let(:runner) { described_class.new }

  let(:predicted_examples) do
    [
      'One plus one equals two',
      'Two times two equals four'
    ]
  end

  before do
    allow(WhatToRun).to receive(:predict).and_return(predicted_examples)
  end

  it_behaves_like 'a runner'

  describe '#predicted_example_args' do
    it 'builds escaped args' do
      escaped_args = '-e One\ plus\ one\ equals\ two ' \
        '-e Two\ times\ two\ equals\ four'

      expect(runner.send(:predicted_example_args)).to eq(escaped_args)
    end
  end

  describe '#executable' do
    it 'uses default executable if none is given' do
      expect(runner.send(:executable)).to \
        eq('bundle exec rspec')
    end

    it 'uses custom executable if it is given' do
      executable = 'rake spec'
      runner = described_class.new(exec: executable)
      expect(runner.send(:executable)).to eq(executable)
    end
  end
end
