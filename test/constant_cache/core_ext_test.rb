require File.dirname(__FILE__) + '/../test_helper'

class CoreExtTest < Test::Unit::TestCase
  context "The String core extension" do
    should "upcase its characters" do
      'test'.constant_name.should == 'TEST'
    end
  
    should "replace whitespace with a single underscore" do
      "test this \tformat\nplease.".constant_name.should == 'TEST_THIS_FORMAT_PLEASE'
    end
  
    should "remove leading and trailing whitespace" do
      ' test '.constant_name.should == 'TEST'
    end
  
    should "remove non-word characters" do
      '!test?'.constant_name.should == 'TEST'
    end
  
    should "not singularize plural name" do
      'tests'.constant_name.should == 'TESTS'
    end
  
    should "return nil when all characters are removed" do
      '?'.constant_name.should be(nil)
    end
  
    should "collapse multiple underscores" do
      'test__me'.constant_name.should == 'TEST_ME'
    end

    should "convert dashes to underscores" do
      'test-me'.constant_name.should == 'TEST_ME'
    end
  end
end

