require "minitest/autorun"

module Palindrome
  def palindrome?(str)
    return false if str.nil?
    chars = str.to_s.downcase.gsub(/\W/, '')
    chars == chars.reverse
  end
end

class TestPalindrome < Minitest::Test
  include Palindrome

  # Not Palindromes
  def test_nil
    assert_equal(false, palindrome?(nil))
  end

  def test_num
    assert_equal(false, palindrome?(54))
  end

  def test_word
    assert_equal(false, palindrome?('word'))
  end

  # Palindromes
  def test_char
    assert_equal(true, palindrome?('a'))
  end

  def test_num_palindrome
    assert_equal(true, palindrome?(5445))
  end

  def test_racecar
    assert_equal(true, palindrome?('racecar'))
  end

  def test_quote
    assert_equal(true, palindrome?("'racecar'"))
  end

  def test_tacocat
    assert_equal(true, palindrome?('tacocat'))
  end

  def test_sentence
    assert_equal(true, palindrome?("Some men interpret nine memos."))
  end

  def test_sentence2
    assert_equal(true, palindrome?("Gateman sees name, garageman sees nametag."))
  end

end
