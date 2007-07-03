require File.dirname(__FILE__) + '/../test_helper'

class FormatTest < Test::Unit::TestCase
  
  def test_constant_name_should_uppercase_characters
    assert_equal 'Test', 'test'.constant_name
  end
  
  def test_constant_name_should_replace_whitespace_with_single_underscore
    assert_equal 'TestThisFormatPlease', "test this  format\tplease".constant_name
  end
  
  def test_constant_name_should_remove_leading_and_trailing_whitespace
    assert_equal 'Test', ' test '.constant_name
  end
  
  def test_constant_name_should_remove_non_word_characters
    assert_equal 'Test', '!test.?'.constant_name
  end
  
  def test_constant_name_should_return_nil_if_all_chars_removed
    assert_nil '?'.constant_name
  end
  
end