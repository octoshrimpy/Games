@empty = ". "
@mark = "• "
input = "
123, -46, 0, -1, 1, 52, 1113245
[8].each { |y| [0, 1].each { |x| coords << [y, x] }}
[7].each { |y| [2, -1].each { |x| coords << [y, x] }}
(2..5).each { |y| [-3, 4].each { |x| coords << [y, x] }}
[1, 6].each { |y| [-2, 3].each { |x| coords << [y, x] }}
[0].each { |y| (-1..2).each { |x| coords << [y, x] }}
"

art = "
   •••
  •   •
 • • • •
•  • •  •
•       •
•       •
 •••••••
"

def incrementAll(string, increment)
  hold = []
  puts string
  puts ""
  array = string.split("")
  array.each do |char|
    if (char =~ /\A[-+]?\d+\z/) == 0 || char == "-"
      hold << char
    else
      if hold.length > 0
        num = hold.join.to_i
        num += 1
        hold = []
        print num
      end
      num = char
    end
    print num.to_s
  end
end

def pixelartToFunction(pixel_art, live="x", dead=" ")
  lines = pixel_art.split("\n")
  lines -= [""]
  placements = Array.new(lines.length) { [] }
  lines.reverse.each_with_index do |line, line_num|
    line.split("").each_with_index do |char, char_pos|
      placements[line_num] << char_pos if char == live
    end
  end
  min = placements.sort_by { |y_values| y_values.first }.first.first
  max = placements.sort_by { |y_values| y_values.last }.last.last
  width = max - min
  center = (width.to_f / 2).round
  @boardy = placements.length
  @boardx = max + 1
  @board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
  draw = []
  placements.each_with_index do |coords, index|
    x_values = []
    coords.each do |x|
      x_values << x - center
      draw << [index + 1, x]
    end
    puts "[#{index}].each { |y| [#{x_values.join(", ")}].each { |x| coords << [y, x] }}"
  end

  draw.each do |coord|
    @board[-coord[0]][coord[1]] = @mark
  end
  i = 0
  print "  "
  @boardx.times do |x|
    print "#{x} " if x < 10
    print "#{x}" if x >= 10
  end
  puts ""
  while i < @board.length
    print "#{i} " if i < 10
    print "#{i}" if i >= 10
    puts @board[i].join
    i += 1
  end
end

pixelartToFunction(art, "•", " ")


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
