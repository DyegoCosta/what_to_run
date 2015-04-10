require 'what_to_run/minitest/runner'

describe WhatToRun::Minitest::Runner do
  let(:runner) { described_class.new }

  let(:predicted_examples) do
    [
      'Calculator#test_one_plus_one_equals_two',
      'My Calculator#test two times two equals four'
    ]
  end

  before do
    allow(WhatToRun).to receive(:predict).and_return(predicted_examples)
  end

  it_behaves_like 'a runner'

  describe '#command' do
    let(:escaped_example_args) do
      "TESTOPTS=\"--name\\=/\\^Calculator\\" \
        "#test_one_plus_one_equals_two\\$\\|\\" \
        "^My\\ Calculator\\#test\\ two\\" \
        " times\\ two\\ equals\\ four\\$/\""
    end

    subject { runner.command }

    context 'with default executable' do
      it 'is the base minitest executable with a name argument' do
        is_expected.to \
          eq("bundle exec rake test #{escaped_example_args}")
      end
    end

    context 'with an alternate executable specified' do
      let(:runner) do
        described_class.new(exec: 'rake test')
      end

      it 'is the specified executable with a name argument' do
        is_expected.to eq("rake test #{escaped_example_args}")
      end
    end
  end
end
