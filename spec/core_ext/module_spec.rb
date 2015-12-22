require 'spec_helper'

module One
  Constant1 = "Hello World"
  Constant2 = "What's up?"
end

module Yz
  module Zy
    class Cd
      include One
    end
  end
end

describe 'Module' do
  it 'test_parent' do
    assert_equal Yz::Zy, Yz::Zy::Cd.parent
    assert_equal Yz, Yz::Zy.parent
    assert_equal Object, Yz.parent
  end

  it 'test_parents' do
    assert_equal [Yz::Zy, Yz, Object], Yz::Zy::Cd.parents
    assert_equal [Yz, Object], Yz::Zy.parents
  end
end
