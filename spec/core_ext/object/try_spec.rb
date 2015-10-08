require 'spec_helper'

describe Object do
  describe '#try' do
    before do
      @string = "Hello"
    end

    it 'nonexisting method' do
      method = :undefined_method
      assert !@string.respond_to?(method)
      assert_nil @string.try(method)
    end

    it 'nonexisting method with arguments' do
      method = :undefined_method
      assert !@string.respond_to?(method)
      assert_nil @string.try(method, 'llo', 'y')
    end

    it 'nonexisting method bang' do
      method = :undefined_method
      assert !@string.respond_to?(method)
      assert_raise(NoMethodError) { @string.try!(method) }
    end

    it 'nonexisting method with arguments bang' do
      method = :undefined_method
      assert !@string.respond_to?(method)
      assert_raise(NoMethodError) { @string.try!(method, 'llo', 'y') }
    end

    it 'valid method' do
      assert_equal 5, @string.try(:size)
    end

    it 'argument forwarding' do
      assert_equal 'Hey', @string.try(:sub, 'llo', 'y')
    end

    it 'block forwarding' do
      assert_equal 'Hey', @string.try(:sub, 'llo') { |match| 'y' }
    end

    it 'nil to type' do
      assert_nil nil.try(:to_s)
      assert_nil nil.try(:to_i)
    end

    it 'false try' do
      assert_equal 'false', false.try(:to_s)
    end

    it 'try only block' do
      assert_equal @string.reverse, @string.try { |s| s.reverse }
    end

    it 'try only block bang' do
      assert_equal @string.reverse, @string.try! { |s| s.reverse }
    end

    it 'try only block nil' do
      ran = false
      nil.try { ran = true }
      assert_equal false, ran
    end

    it 'try with instance eval block' do
      assert_equal @string.reverse, @string.try { reverse }
    end

    it 'try with instance eval block bang' do
      assert_equal @string.reverse, @string.try! { reverse }
    end

    it 'try with private method bang' do
      klass = Class.new do
        private

        def private_method
          'private method'
        end
      end

      # Opal doesn't currently support private methods
      # assert_raise(NoMethodError) { klass.new.try!(:private_method) }
    end

    it 'try with private method' do
      klass = Class.new do
        private

        def private_method
          'private method'
        end
      end

      # Opal doesn't currently support private methods
      # assert_nil klass.new.try(:private_method)
    end
  end
end
