require 'spec_helper'

describe 'Kernel' do
  it 'adds class_eval to Object' do
    o = Object.new
    class << o; @x = 1; end
    assert_equal 1, o.class_eval { @x }
  end
end
