require 'rspec'

def to_word(input)
  return input unless input.to_i.to_s == input.to_s
  int = input.to_i
  return 'zero' if int == 0
  numbers_to_name = {
    1000000000000 => 'trillion',
    1000000000 => 'billion',
    1000000 => 'million',
    1000 => 'thousand',
    100 => 'hundred',
    90 => 'ninety',
    80 => 'eighty',
    70 => 'seventy',
    60 => 'sixty',
    50 => 'fifty',
    40 => 'forty',
    30 => 'thirty',
    20 => 'twenty',
    19 => 'nineteen',
    18 => 'eighteen',
    17 => 'seventeen',
    16 => 'sixteen',
    15 => 'fifteen',
    14 => 'fourteen',
    13 => 'thirteen',
    12 => 'twelve',
    11 => 'eleven',
    10 => 'ten',
    9 => 'nine',
    8 => 'eight',
    7 => 'seven',
    6 => 'six',
    5 => 'five',
    4 => 'four',
    3 => 'three',
    2 => 'two',
    1 => 'one'
  }
  str_parts = []
  numbers_to_name.each do |num, name|
    next if num > int
    if int == num
      str_parts << name
    else
      str_parts << to_word(int / num) if int > 100
      str_parts << name
    end
    int -= (num * (int / num))
  end
  str_parts.join(' ')
end

def characters_in_number(num)
  character_count(to_word(num))
end

def character_count(word)
  word.scan(/\w/).length
end

def do_magic(num)
  num.to_i
  return puts "4 is magic" if num == 4
  new_num = characters_in_number(num)
  puts "#{num} is #{new_num}"
  do_magic(new_num)
end

RSpec.describe do
  describe '#character_count' do
    it 'returns the number of letters in a string' do
      expect(character_count('four')).to eql(4)
      expect(character_count('my name is...')).to eql(8)
    end
  end

  describe '#to_word' do
    it 'returns the word-version of a number' do
      expect(to_word(4)).to eql('four')
      expect(to_word(123)).to eql('one hundred twenty three')
      expect(to_word(4321)).to eql('four thousand three hundred twenty one')
    end
  end

  describe '#characters_in_number' do
    it 'returns the number of letters in the word version of a number' do
      expect(characters_in_number(4)).to eql(4)
      expect(characters_in_number(8)).to eql(5)
      expect(characters_in_number(5)).to eql(4)
      expect(characters_in_number(2)).to eql(3)
    end
  end
end

if ARGV[0] != 'four_is_magic.rb'
  do_magic(ARGV[0])
end
