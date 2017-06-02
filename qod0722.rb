require "minitest/autorun"

module Tester
  def reverse_phrase(str)
    str.gsub(/[\w'\-]*/) { |match| match.reverse }
  end
end
​
class TestReverser < Minitest::Test
  include Tester

  def test_reverse_simple_string
    assert_equal('dna', reverse_phrase('and'), 'simple word reverse fails 1')
    assert_equal('eht', reverse_phrase('the'), 'simple word reverse fails 2')
    assert_equal('Allen', reverse_phrase('nellA'), 'simple word reverse fails 3 with cap')
    assert_equal('racecar', reverse_phrase('racecar'), 'one word palindrome is not unchanged')
  end
  ​
  def test_reverse_simple_phrase
    assert_equal('kcoR dna lloR', reverse_phrase('Rock and Roll'), 'simple word reverse fails 1')
    assert_equal('peeK eht htiaf', reverse_phrase('Keep the faith'), 'simple word reverse fails 2')
  end
  ​
  def test_reverse_phrase_with_punctuation
    assert_equal('raeD ybbA, I deen pleh.', reverse_phrase('Dear Abby, I need help.'), 'punctuation in place fails')
  end
  ​
  def test_multiple_spaces_between_words
    assert_equal('kcoR  dna  lloR', reverse_phrase('Rock  and  Roll'), 'multiple spaces between words fails')
  end
  ​
  def test_multiple_spaces_between_words_and_punctuation
    assert_equal("kcoR  dna  lloR t'nia esion noitullop.", reverse_phrase("Rock  and  Roll ain't noise pollution."), 'multiple spaces between words fails')
  end
end
