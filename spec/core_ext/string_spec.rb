require 'spec_helper'
require 'active_support/core_ext/string'

describe 'String' do

  describe "#demodulize" do
    it "removes any preceding module name from the string" do
      "Foo::Bar".demodulize.should == "Bar"
      "Foo::Bar::Baz".demodulize.should == "Baz"
    end

    it "has no affect on strings with no module seperator" do
      "SomeClassName".demodulize.should == "SomeClassName"
    end
  end

  describe '#underscore' do
    it "replaces '-' in dasherized strings with underscores" do
      "well-hello-there".underscore.should == "well_hello_there"
    end

    it "converts single all-upcase strings into lowercase" do
      "OMG".underscore.should == "omg"
    end

    it "splits word bounderies and seperates using underscore" do
      "AdamBeynon".underscore.should == "adam_beynon"
    end

    it "does not split when 2 or more capitalized letters together" do
      "HTMLParser".underscore.should == "html_parser"
    end
  end

  describe '#dasherize' do
    it 'dasherizes' do
      {
        "street"                => "street",
        "street_address"        => "street-address",
        "person_street_address" => "person-street-address",
      }.each_pair do |underscore, dashes|
        underscore.dasherize.should == dashes
      end
    end
  end
end
