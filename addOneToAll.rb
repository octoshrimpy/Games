string = "
123, -46, 0, -1, 1, 52, 1113245
[8].each { |y| [0, 1].each { |x| coords << [y, x] }}
[7].each { |y| [2, -1].each { |x| coords << [y, x] }}
(2..5).each { |y| [-3, 4].each { |x| coords << [y, x] }}
[1, 6].each { |y| [-2, 3].each { |x| coords << [y, x] }}
[0].each { |y| (-1..2).each { |x| coords << [y, x] }}
"
@hold = []
puts string
puts "\n\n"
string.split("").each do |char|
  if (char =~ /\A[-+]?\d+\z/) == 0 || char == "-"
    @hold << char
  else
    if @hold.length > 0
      num = @hold.join.to_i
      num += 1
      @hold = []
      print num
    end
    num = char
  end
  print num.to_s
end

# 123, -46, 0, -1, 1, 52, 1113245
# [8].each { |y| [0, 1].each { |x| coords << [y, x] }}
# [7].each { |y| [2, -1].each { |x| coords << [y, x] }}
# (2..5).each { |y| [-3, 4].each { |x| coords << [y, x] }}
# [1, 6].each { |y| [-2, 3].each { |x| coords << [y, x] }}
# [0].each { |y| (-1..2).each { |x| coords << [y, x] }}
#
#
#
# 124, -45, 1, 0, 2, 53, 1113246
# [9].each { |y| [1, 2].each { |x| coords << [y, x] }}
# [8].each { |y| [3, 0].each { |x| coords << [y, x] }}
# (3..6).each { |y| [-2, 5].each { |x| coords << [y, x] }}
# [2, 7].each { |y| [-1, 4].each { |x| coords << [y, x] }}
# [1].each { |y| (0..3).each { |x| coords << [y, x] }}
