require 'opal-rspec'
require 'opal-activesupport'
require 'active_support/inflector'

module TestUnitHelpers
  def assert actual
    expect(actual).to be_truthy
  end

  def assert_nil actual
    expect(actual).to be_nil
  end

  def assert_equal actual, expected
    expect(expected).to eq(actual)
  end

  def assert_raise error, &block
    expect(&block).to raise_error(error)
  end
end

RSpec.configure do |config|
  config.include TestUnitHelpers
end

