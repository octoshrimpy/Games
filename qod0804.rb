require 'rspec'

def happy_number?(num)
  sequence = []
  until sequence.length > 1 && (sequence.first(sequence.length - 2) & sequence.last(2) == sequence.last(2))
    digits = num.to_s.split('').map(&:to_i)
    squared = digits.map { |d| d ** 2 }
    num = squared.inject(:+)
    sequence << num
    return true if num == 1
  end
  false
end

RSpec.describe do
  it { expect(happy_number?(1)).to eql true }
  it { expect(happy_number?(2)).to eql false }
  it { expect(happy_number?(167)).to eql true }
  it { expect(happy_number?(9000)).to eql false }
  it { expect(happy_number?(9001)).to eql true }
end
