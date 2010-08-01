require 'test_helper'

class Cached
  include ConstantCache
  
  attr_accessor :name
  attr_accessor :abbreviation
end

class CacheMethodsTest < Test::Unit::TestCase
  context "A class with ConstantCache mixed in" do
    should "have default options for the cache key and character limit" do
      Cached.reset_cache_options
      assert_equal({:key => :name, :limit => 64}, Cached.cache_options)
    end

    should "all overridden options for key and character limit" do
      Cached.cache_as :abbreviation
      Cached.cache_limit 20
      assert_equal({:key => :abbreviation, :limit => 20}, Cached.cache_options)
    end

    should "revert the limit on characters if less than 1" do
      Cached.cache_limit -10
      assert_equal({:key => :name, :limit => 64}, Cached.cache_options)
    end
  end

  context "ConstantCache" do
    should "be able to cache all instances as constants" do
      c1 = Cached.new
      c1.name = 'al einstein'
      c1.expects(:set_instance_as_constant)

      c2 = Cached.new
      c2.name = 'al franken'
      c2.expects(:set_instance_as_constant)

      Cached.expects(:all).returns([c1, c2])
      ConstantCache.cache!
    end
  end

  context "An instance of a class with ConstantCache mixed in" do
    setup do
      Cached.cache_limit 20
      @cached = Cached.new
    end

    should "create a constant as a reference to the instance" do
      @cached.name = 'al sharpton'
      @cached.set_instance_as_constant
      assert_equal true, Cached.constants.include?("AL_SHARPTON")
      assert_equal @cached, Cached::AL_SHARPTON
    end

    should "not create a constant without a key value" do
      size = Cached.constants.size
      @cached.set_instance_as_constant
      assert_equal size, Cached.constants.size
    end

    should "not raise an exception on duplicate constant" do
      @cached.name = 'buffalo'
      assert_nothing_raised do
        @cached.set_instance_as_constant
        @cached.set_instance_as_constant
      end
    end

    should "truncate long constant names" do
      constant_name = ('a'*20).upcase

      @cached.name = 'a'*65
      @cached.set_instance_as_constant

      assert_equal true, Cached.constants.include?(constant_name)
    end
  end
end
