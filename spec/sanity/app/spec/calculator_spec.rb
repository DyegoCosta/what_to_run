require 'what_to_run/rspec'
require File.expand_path('../lib/calculator', File.dirname(__FILE__))

describe Calculator do
  describe '.sum' do
    it 'sums two numbers' do
      expect(Calculator.sum(1, 2)).to eq(3)
    end

    it 'subtract two numbers' do
      expect(Calculator.subtract(2, 1)).to eq(1)
    end
  end
end
