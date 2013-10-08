require 'spec_helper'
require 'active_support/core_ext/string'
require 'inflector_test_cases'

module InflectorTestCases
describe 'String' do
  # include InflectorTestCases

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
    it "camel to underscore" do
      CamelToUnderscore.each do |camel, underscore|
        camel.underscore.should eq(underscore)
      end

      "HTMLTidy".underscore.should eq("html_tidy")
      "HTMLTidyGenerator".underscore.should eq("html_tidy_generator")
    end

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

  describe '#camelize' do
    it 'camelizes' do
      CamelToUnderscore.each do |camel, underscore|
        underscore.camelize.should == camel
      end
    end

    it 'accepts :lower to keep the first letter lowercase' do
      'Capital'.camelize(:lower).should == 'capital'
    end
  end
end
end
