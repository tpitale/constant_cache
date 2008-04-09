require File.dirname(__FILE__) + '/../../spec_helper'

describe SimpleClass, "with constant_cache mix-in" do

  before { @value = 'pony' }

  it "should set some default options" do
    enable_caching(SimpleClass)
    SimpleClass.cache_options.should == {:key => :name, :limit => 64}
  end
  
  it "should overwrite default options when passed new ones" do
    additional_options = {:key => :new_key, :limit => 100}

    enable_caching(SimpleClass, [], additional_options)
    SimpleClass.cache_options.should == additional_options
  end
  
  it "should use name as the default constant key" do
    enable_caching(SimpleClass, [{:name => 'one', :value => @value}])
    SimpleClass::ONE.value.should == @value
  end
  
  it "should not set constant when value is nil" do
    proc = lambda { enable_caching(SimpleClass, [{:name => '?', :value => @pony}]) }
    proc.should_not change(SimpleClass.constants, :size)
  end
  
  it "should raise an exception with message when encountering a duplicate constant" do
    proc = lambda { enable_caching(SimpleClass, [{:name => 'duplicate'}, {:name => 'duplicate'}]) }
    proc.should raise_error(ConstantCache::DuplicateConstantError, 'Constant SimpleClass::DUPLICATE has already been defined')
  end
  
  it "should truncate long constant names" do
    enable_caching(SimpleClass, [{:name => 'a' * 65, :value => @value}])
    SimpleClass.const_get('A' * 64).value.should == @value
  end

  it "should honor configuration of truncation point" do
    enable_caching(SimpleClass, [{:name => 'abcdef', :value => @value}], {:limit => 3})
    SimpleClass::ABC.value.should == @value
  end
  
  it "should raise an exception when truncated constant names collide" do
    proc = lambda { enable_caching(SimpleClass, [{:name => 'abcd'}, {:name => 'abef'}], {:limit => 2}) }
    proc.should raise_error(ConstantCache::DuplicateConstantError)
  end
  
  it "should raise an exception when an invalid limit is set" do
    limit = 0
    proc = lambda { SimpleClass.caches_constants(:limit => limit) }
    proc.should raise_error(ConstantCache::InvalidLimitError, "Limit of #{limit} is invalid")
  end
end

describe AlternateClass, "with constant_cache mix-in" do

  it "should allow override of key" do
    enable_caching(AlternateClass, [{:name2 => 'foo bar', :value => @value}], {:key => :name2})
    AlternateClass::FOO_BAR.value.should == @value
  end

end
