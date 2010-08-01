require 'test_helper'

class CoreExtTest < Test::Unit::TestCase
  context "The String core extension" do
    should "upcase its characters" do
      assert_equal 'TEST', 'test'.constant_name
    end
  
    should "replace whitespace with a single underscore" do
      assert_equal 'TEST_THIS_FORMAT_PLEASE', "test this \tformat\nplease.".constant_name
    end
  
    should "remove leading and trailing whitespace" do
      assert_equal 'TEST', ' test '.constant_name
    end
  
    should "remove non-word characters" do
      assert_equal 'TEST', '!test?'.constant_name
    end
  
    should "not singularize plural name" do
      assert_equal 'TESTS', 'tests'.constant_name
    end
  
    should "return nil when all characters are removed" do
      assert_nil '?'.constant_name
    end
  
    should "collapse multiple underscores" do
      assert_equal 'TEST_ME', 'test__me'.constant_name
    end
  end
end
