require File.dirname(__FILE__) + '/../../spec_helper'

describe String, "with constant_name method" do
  
  before { String.send(:include, ConstantCache::Format) }
  
  it "should upcase its characters" do
    'test'.constant_name.should == 'TEST'
  end
  
  it "should replace whitespace with a single underscore" do
    "test this \tformat\nplease.".constant_name.should == 'TEST_THIS_FORMAT_PLEASE'
  end
  
  it "should remove leading and trailing whitespace" do
    ' test '.constant_name.should == 'TEST'
  end
  
  it "should remove non-word characters" do
    '!test?'.constant_name.should == 'TEST'
  end
  
  it "should not singularize plural name" do
    'tests'.constant_name.should == 'TESTS'
  end
  
  it "should return nil when all characters are removed" do
    '?'.constant_name.should be_nil
  end
  
  it "should collapse multiple underscores" do
    'test__me'.constant_name.should == 'TEST_ME'
  end
  
end
