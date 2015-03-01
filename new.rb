
@board = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
@board.each_with_index do |coord, y|
  coord.each_with_index do |pos, x|
    print "#{@board[y][x]} "
  end
  puts ""
end
puts "\n"


(-1..1).each do |vert|
  (-1..1).each do |horz|
    # if [horz, vert] != [0, 0]
      # print "(#{vert}, #{horz})"
      print "#{@board[(vert + 0) % 3][(horz + 0) % 3]} "
    # end
  end
  puts ""
end
