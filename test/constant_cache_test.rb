require File.dirname(__FILE__) + '/../test_helper'

class BaseClass < ActiveRecord::Base
  def self.columns; []; end
end

class SimpleClass < BaseClass
  PREDEFINED = 'foo'
  attr_accessor :name, :value
end

class AlternateClass < BaseClass; attr_accessor :name2, :value; end

class CacheAsConstantsTest < Test::Unit::TestCase
  
  def test_cache_should_use_name_as_default
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'one', :value => 'pony')])
    SimpleClass.caches_constants
    assert_equal 'pony', SimpleClass::ONE.value
  end
  
  def test_cache_should_honor_alternate_accessor
    AlternateClass.expects(:find).returns([AlternateClass.new(:name2 => 'foo bar', :value => 'pony')])
    AlternateClass.caches_constants :key => :name2
    assert_equal 'pony', AlternateClass::FOO_BAR.value
  end
  
  def test_cache_with_nil_key_value_should_not_set_constant
    constant_count = SimpleClass.constants.size
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => '?', :value => 'nothing')])
    SimpleClass.caches_constants
    assert_equal constant_count, SimpleClass.constants.size
  end
  
  def test_cache_with_duplicate_constant_name_should_raise_runtime_exception
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'duplicate', :value => 'original'), SimpleClass.new(:name => 'duplicate', :value => 'new')])
    assert_raise(RuntimeError) { SimpleClass.caches_constants }
  end
  
  def test_cache_with_duplicate_constant_name_should_contain_appropriate_exception_message
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'predefined', :value => 'foo')])
    exception_raised = false
    begin
      SimpleClass.caches_constants
    rescue RuntimeError => e
      exception_raised = true
      assert_equal 'Constant SimpleClass::PREDEFINED has already been defined', e.message
    end
    
    assert exception_raised
  end
  
  def test_cache_with_long_value_should_truncate_at_default_length
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'a' * 65, :value => 'overflow')])
    SimpleClass.caches_constants
    assert !SimpleClass.const_defined?('A' * 65)
    assert_equal 'overflow', SimpleClass.const_get('A' * 64).value
  end
  
  def test_cache_with_specified_limit_should_truncate_to_length_specified
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'abcdef', :value => 'foo')])
    SimpleClass.caches_constants :limit => 3
    assert_equal 'foo', SimpleClass::ABC.value
  end
  
  def test_cache_with_invalid_limit_should_not_set_constant
    constant_count = SimpleClass.constants.size
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'invalid', :value => 'one')])
    SimpleClass.caches_constants :limit => 0
    assert_equal constant_count, SimpleClass.constants.size
  end
  
  def test_cache_with_truncated_value_and_limit_should_not_overwrite_constant
    SimpleClass.expects(:find).returns([SimpleClass.new(:name => 'abcdef', :value => 'one'), SimpleClass.new(:name => 'abggh', :value => 'two')])
    assert_raise(RuntimeError) { SimpleClass.caches_constants :limit => 2 }
  end
  
end
