# ORIG_ARGV = ARGV.dup
#
# begin
#   old, $VERBOSE = $VERBOSE, nil
#   require File.expand_path('../../../load_paths', __FILE__)
# ensure
#   $VERBOSE = old
# end
#
# require 'active_support/core_ext/kernel/reporting'
# require 'active_support/core_ext/string/encoding'
#
# silence_warnings do
#   Encoding.default_internal = "UTF-8"
#   Encoding.default_external = "UTF-8"
# end
#
# require 'active_support/testing/autorun'
# require 'empty_bool'
#
# ENV['NO_RELOAD'] = '1'
# require 'active_support'
#
# Thread.abort_on_exception = true
#
# # Show backtraces for deprecated behavior for quicker cleanup.
# ActiveSupport::Deprecation.debug = true

# To help opal-minitest print errors.
Encoding.default_external = Encoding::UTF_8

require 'minitest/autorun'
require 'empty_bool'
require 'active_support'

class ActiveSupport::TestCase < Minitest::Test
  def self.test name, &block
    define_method "test_#{name.gsub(/[\W-]+/, '_')}", &block
  end

  def assert_raise error_class, &block
    block.call
    assert false, "Expected to see #{error_class.inspect}, but no exception was raised"
  rescue error_class => error
    error
  rescue => actual_error
    assert false, "Expected to see #{error_class.inspect}, but got #{actual_error.inspect}"
  end

  def assert_nothing_raised(&block)
    block.call
  rescue => e
    assert false, "Expected no error, but got #{e.inspect}"
  end

  def assert_not_empty(object)
    assert !object.empty?, "Expected not empty object, but got: #{object.inspect}"
  end

  def assert_not_same(obj1, obj2)
    assert !obj1.equal?(obj2), "Excepted #{obj1.inspect} and #{obj2.inspect} to be different objects"
  end
end
