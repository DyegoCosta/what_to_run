shared_examples 'a runner' do
  describe '#run' do
    let(:command) { 'my test command' }

    before do
      allow(runner).to receive(:predicted_examples).and_return(predicted_examples)
    end

    before do
      allow(runner).to receive(:command).and_return(command)
    end

    context 'when predicted examples is not empty' do
      let(:predicted_examples) { ['Example 1', 'Example 2'] }

      it 'calls Kernel#exec with the test runner command' do
        expect(Kernel).to receive(:exec).with(command)
        runner.run
      end
    end

    context 'when predicted examples is empty' do
      let(:predicted_examples) { [] }

      it 'exits gracefully' do
        expect { runner.run }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(0)
        end
      end
    end
  end
end
