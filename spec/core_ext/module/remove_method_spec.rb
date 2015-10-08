require 'spec_helper'

module RemoveMethodTests
  class A
    def do_something
      return 1
    end
  end
end

describe Module do
  describe '#remove_possible_method' do
    it 'removes method from an object' do
      RemoveMethodTests::A.class_eval{
        self.remove_possible_method(:do_something)
      }
      assert !RemoveMethodTests::A.new.respond_to?(:do_something)
    end
  end

  describe '#redefine_method' do
    it 'redefines method in an object' do
      RemoveMethodTests::A.class_eval{
        self.redefine_method(:do_something) { return 100 }
      }
      assert_equal 100, RemoveMethodTests::A.new.do_something
    end
  end
end
