require 'what_to_run/minitest'
require 'minitest/autorun'
require File.expand_path('../lib/calculator', File.dirname(__FILE__))

class TestCalculator < MiniTest::Test
  def test_sum
    assert_equal 3, Calculator.sum(1, 2)
  end

  def test_subtract
    assert_equal 1, Calculator.subtract(2, 1)
  end
end
