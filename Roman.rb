# A smaller number in front of a larger number means subtraction, all else means
# addition. For example, IV means 4, VI means 6.
# You would not put more than one smaller number in front of a larger number to
# subtract. For example, IIV would not mean 3.
# You must separate ones, tens, hundreds, and thousands as separate items. That
# means that 99 is XCIX, 90 + 9, but never should be written as IC. Similarly,
# 999 cannot be IM and 1999 cannot be MIM.
# 4999 = MMMM CM XC IX
input = ARGV[0]
roman_to_num = { 'i' => 1, 'v' => 5, 'x' => 10, 'l' => 50, 'c' => 100, 'd' => 500, 'm' => 1000 }
vals = input.downcase.split('').map { |rn| roman_to_num[rn] }
skip = false
converted = vals.map.with_index do |val, idx|
  (skip = false; next) if skip == true
  next_val = vals[idx + 1]
  (next_val.nil? || val >= next_val) ? (val) : (skip = true; next_val - val)
end.compact.inject(:+)
puts "#{converted}"
