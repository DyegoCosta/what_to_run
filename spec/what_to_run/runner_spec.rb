require 'what_to_run/runner'

describe WhatToRun::Runner do
  let(:runner) { described_class.new }

  describe '#command' do
    it 'raises an AbstractMethodError' do
      expect { runner.command }.to raise_error(
        NotImplementedError, 'Subclass must override #command'
      )
    end
  end

  it_behaves_like 'a runner'
end
