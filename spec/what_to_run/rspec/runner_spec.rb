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

  describe '#command' do
    let(:escaped_example_args) do
      '-e One\ plus\ one\ equals\ two ' \
        '-e Two\ times\ two\ equals\ four'
    end

    subject { runner.command }

    context 'with default exectuable' do
      it 'is the base rspec executable with an argument for each predicted example' do
        is_expected.to eq("bundle exec rspec #{escaped_example_args}")
      end
    end

    context 'with an alternate executable specified' do
      let(:runner) do
        described_class.new(exec: './bin/rspec')
      end

      it 'is the specified executable with an argument for each predicted example' do
        is_expected.to eq("./bin/rspec #{escaped_example_args}")
      end
    end
  end
end
