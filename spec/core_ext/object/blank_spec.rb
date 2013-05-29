require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'empty_bool'

describe 'Object#blank?' do
  BLANK = [ EmptyTrue.new, nil, false, '', '   ', "  \n\t  \r ", '　', [], {} ]
  NOT   = [ EmptyFalse.new, Object.new, true, 0, 1, 'a', [nil], { nil => 0 } ]

  BLANK.each do |v|
    describe "The value of #{v.inspect}" do
      it 'is #blank?' do
        v.blank?.should == true
      end

      it 'is not #present?' do
        v.present?.should == false
      end

      it 'has nil #presence' do
        v.presence.should == nil
      end
    end
  end

  NOT.each do |v|
    describe "The value of #{v.inspect}" do
      it 'is not #blank?' do
        v.blank?.should == false
      end

      it 'is not #present?' do
        v.present?.should == true
      end

      it 'has self #presence' do
        v.presence.should == v
      end
    end
  end
end
