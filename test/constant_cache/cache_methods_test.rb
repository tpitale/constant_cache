require File.dirname(__FILE__) + '/../test_helper'

class Cached
  include ConstantCache
  
  attr_accessor :name
  attr_accessor :abbreviation
end

class CacheMethodsTest < Test::Unit::TestCase
  context "A class with ConstantCache mixed in" do
    should "have default options for the cache key and character limit" do
      Cached.stubs(:all).returns([])
      Cached.cache_constants
      Cached.cache_options.should == {:key => :name, :limit => 64}
    end

    should "all overridden options for key and character limit" do
      Cached.stubs(:all).returns([])
      Cached.cache_constants(:key => :abbreviation, :limit => 20)
      Cached.cache_options.should == {:key => :abbreviation, :limit => 20}
    end

    should "revert the limit on characters if less than 1" do
      Cached.stubs(:all).returns([])
      Cached.cache_constants(:limit => -10)
      Cached.cache_options.should == {:key => :name, :limit => 64}
    end

    should "be able to cache all instances as constants" do
      c1 = Cached.new
      c1.name = 'al einstein'
      c1.expects(:set_instance_as_constant)

      c2 = Cached.new
      c2.name = 'al franken'
      c2.expects(:set_instance_as_constant)

      Cached.expects(:all).returns([c1, c2])
      Cached.cache_constants
    end
  end

  context "An instance of a class with ConstantCache mixed in" do
    setup do
      Cached.stubs(:all).returns([])
      Cached.cache_constants(:limit => 20)
      @cached = Cached.new
    end

    should "create a constant as a reference to the instance" do
      @cached.name = 'al sharpton'
      @cached.set_instance_as_constant
      Cached.constants.include?("AL_SHARPTON").should == true
      Cached::AL_SHARPTON.should == @cached
    end

    should "not create a constant without a key value" do
      size = Cached.constants.size
      @cached.set_instance_as_constant
      Cached.constants.size.should == size
    end

    should "raise an exception on duplicate constant" do
      @cached.name = 'buffalo'
      assert_raises ConstantCache::DuplicateConstantError do
        @cached.set_instance_as_constant
        @cached.set_instance_as_constant
      end
    end

    should "truncate long constant names" do
      constant_name = ('a'*20).upcase

      @cached.name = 'a'*65
      @cached.set_instance_as_constant
      
      Cached.constants.include?(constant_name).should == true
    end
  end
end
