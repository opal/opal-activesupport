require 'opal-rspec'
require 'opal-activesupport'
require 'active_support/inflector'

module TestUnitHelpers
  def assert actual
    expect(actual).to be_truthy
  end

  def assert_equal actual, expected
    actual.should == expected
  end
end

RSpec.configure do |config|
  config.include TestUnitHelpers
end

