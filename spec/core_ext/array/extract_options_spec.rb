require 'spec_helper'

# require 'abstract_unit'
# require 'active_support/core_ext/array'
# require 'active_support/core_ext/hash'

class HashSubclass < Hash
end

class ExtractableHashSubclass < Hash
  def extractable_options?
    true
  end
end

describe Array do
  describe '#extract_options!' do
    it 'extracts options' do
      assert_equal({}, [].extract_options!)
      assert_equal({}, [1].extract_options!)
      assert_equal({ a: :b }, [{ a: :b }].extract_options!)
      assert_equal({ a: :b }, [1, { a: :b }].extract_options!)
    end

    it 'doesnt extract hash subclasses' do
      hash = HashSubclass.new
      hash[:foo] = 1
      array = [hash]
      options = array.extract_options!
      assert_equal({}, options)
      assert_equal([hash], array)
    end

    it 'extracts extractable subclass' do
      hash = ExtractableHashSubclass.new
      hash[:foo] = 1
      array = [hash]
      options = array.extract_options!
      assert_equal({ foo: 1 }, options)
      assert_equal([], array)
    end

    it 'extracts hash with indifferent access' do
      array = [{ foo: 1 }.with_indifferent_access]
      options = array.extract_options!
      assert_equal(1, options[:foo])
    end
  end
end
