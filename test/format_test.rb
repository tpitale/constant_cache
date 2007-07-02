require File.dirname(__FILE__) + '/../test_helper'

class FormatTest < Test::Unit::TestCase
  
  def test_to_const_should_uppercase_characters
    assert_equal 'Test', Viget::Format.to_const('test')
  end
  
  def test_to_const_should_replace_whitespace_with_single_underscore
    assert_equal 'TestThisFormatPlease', Viget::Format.to_const("test this  format\tplease")
  end
  
  def test_to_const_should_remove_leading_and_trailing_whitespace
    assert_equal 'Test', Viget::Format.to_const(' test ')
  end
  
  def test_to_const_should_remove_non_word_characters
    assert_equal 'Test', Viget::Format.to_const('!test.?')
  end
  
  def test_to_const_should_return_nil_if_all_chars_removed
    assert_nil Viget::Format.to_const('?')
  end
  
end