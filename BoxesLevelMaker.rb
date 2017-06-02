require 'io/console'
require 'io/wait'
#00202003030302010110101111121214141415171702020510
@out = []

def get_info

  c = 0
  bx = 0
  by = 0
  px = 0
  wrap = 0
  py = 0
  box1 = 0
  box2 = 0
  wall1 = 0
  wall2 = 0
  hole1 = 0
  hole2 = 0


  puts "Welcome to the level maker for Boxes!"
  puts "Please input the size of the level you would like to make as two numbers seperated by a space."
  puts "If one number is used, a square of that size will be created. Min = 5, Max = 30"
  puts "(Does not include border walls)"
  c = gets.chomp
  puts "\n"
  if c.include?(" ")
    c = c.split(" ").map(&:to_i)
    bx = c[0]
    by = c[1]
  else
    bx = c.to_i
    by = c.to_i
  end
  bx = 5 if bx <= 5
  bx = 30 if bx >= 30
  by = 5 if by <= 5
  by = 30 if by >= 30
  puts "Your map will be #{bx} x #{by}\n\n"

  puts "Would you like a border around the edges?"
  puts "Default yes. Type N or No to deactivate."
  wrap = gets.chomp.downcase
  if ["n", "no"].include?(wrap)
    wrap = 1 #0 = build walls
  else
    wrap = 0
    bx += 2
    by += 2
  end
  if wrap == 0
    puts "Your map will be enclosed by walls.\n\n"
  else
    puts "Your map will be open.\n\n"
  end

  puts "Please input the starting coordinates of the player, separated by a space."
  puts "A single number will result in both coordinates being identical."
  c = gets.chomp
  if c.include?(" ")
    c = c.split(" ").map(&:to_i)
    px = c[0]
    py = c[1]
  else
    px = c.to_i
    py = c.to_i
  end
  px = bx if px >= bx
  px = 1 if px < 1
  py = by if py >= by
  py = 1 if py < 1
  puts "Starting coordinates of the player will be #{px}, #{py}.\n\n"
  if wrap == 1
    px -= 1
    py -= 1
  end

  box = []
  i = 0
  h = 1
  box_count = 0
  puts "Please input coordinates of a box, separated by a space."
  while h == 1
    c = gets.chomp.downcase
    if ["n", "no"].include?(c) && box_count > 0
      h = 0
    else
      if c.include?(" ")
        c = c.split(" ").map(&:to_i)
        box1 = c[0]
        box2 = c[1]
      else
        box1 = c.to_i
        box2 = c.to_i
      end
      box1 -= 1 if box1 > bx
      box1 = 1 if box1 < 1
      box2 -= 1 if box2 > by
      box2 = 1 if box2 < 1
      if wrap == 0
        box[box_count] = [box1, box2]
      else
        box[box_count] = [box1-1, box2-1]
      end
      box_count += 1
      puts "Box placed at #{box1}, #{box2}."
      box1 = 0
      box2 = 0
      puts "Please type coordinates for another or type N or No to move on to wall placement."
    end
  end
  puts "\n\n"

  wall = []
  i = 0
  h = 1
  wall_count = 0
    puts "Please input coordinates of a wall, separated by a space."
  while h == 1
    c = gets.chomp.downcase
    if ["n", "no"].include?(c)
      h = 0
    else
      if c.include?(" ")
        c = c.split(" ").map(&:to_i)
        wall1 = c[0]
        wall2 = c[1]
      else
        wall1 = c.to_i
        wall2 = c.to_i
      end
      a = "wall"
      wall1 -= 1 if wall1 > bx
      wall1 = 1 if wall1 < 1
      wall2 -= 1 if wall2 > by
      wall2 = 1 if wall2 < 1
      if wrap == 0
        wall[wall_count] = [wall1, wall2]
      else
        wall[wall_count] = [wall1-1, wall2-1]
      end
      wall_count += 1
      puts "Wall placed at #{wall1}, #{wall2}."
      puts "Please type coordinates for another or type N or No to move on to hole placement."
    end
  end
  puts "\n\n"

  hole = []
  i = 0
  h = 1
  hole_count = 0
  while h == 1
    puts "Please input coordinates of a hole, separated by a space."
    c = gets.chomp.downcase
    if ["n", "no"].include?(c) && hole_count > 0
      h = 0
    else
      if c.include?(" ")
        c = c.split(" ").map(&:to_i)
        hole1 = c[0]
        hole2 = c[1]
      else
        hole1 = c.to_i
        hole2 = c.to_i
      end
      hole1 -= 1 if hole1 > bx
      hole1 = 1 if hole1 < 1
      hole2 -= 1 if hole2 > by
      hole2 = 1 if hole2 < 1
      if wrap == 0
        hole[hole_count] = [hole1, hole2]
      else
        hole[hole_count] = [hole1-1, hole2-1]
      end
      hole_count += 1
      puts "Hole placed at #{hole1}, #{hole2}."
      puts "Please type coordinates for another or type N or No to move on to breaks."
    end
  end
  puts "\n\n"

  # puts wrap
  string_maker(wrap)
  # puts "width #{bx}"
  string_maker(bx)
  # puts "height #{by}"
  string_maker(by)
  # puts "px #{px}"
  string_maker(px)
  # puts "py #{py}"
  string_maker(py)
  # puts "bx count #{box_count}"
  string_maker(box_count)
  # puts "wl cnt #{wall_count}"
  string_maker(wall_count)
  @out << "00" #No doors
  # puts "hl cnt #{hole_count}"
  string_maker(hole_count)
  while box_count > 0
    box_count -= 1
    # puts " bx cnt #{box_count}"
    string_maker(box[box_count][0])
    # puts "bx x #{box[box_count][0]}"
    string_maker(box[box_count][1])
    # puts "bx y #{box[box_count][1]}"
  end
  while wall_count > 0
    wall_count -= 1
    # puts "wl cnt #{wall_count}"
    string_maker(wall[wall_count][0])
    # puts "wl x #{wall[wall_count][0]}"
    string_maker(wall[wall_count][1])
    # puts "wl y #{wall[wall_count][1]}"
  end
  while hole_count > 0
    hole_count -= 1
    # puts "hl cnt #{hole_count}"
    string_maker(hole[hole_count][0])
    # puts "hl x #{hole[hole_count][0]}"
    string_maker(hole[hole_count][1])
    # puts "hl y #{hole[hole_count][1]}"
  end

  if wrap == 0
    h = 1
      puts "Please input x or y followed by a value to make a break point in the wall for wrapping."
    while h == 1
      len = gets.chomp.downcase
      lon = 0
      if ["n", "no"].include?(len)
        h = 0
      else
        if ["x", "y"].include?(len[0]) #Checks if first letter is X or Y
          if len[0] == "x"
            xy = 0
          elsif len[0] == "y"
            xy = 1
          end
          if len.include?(" ") #Checks if a space follows letter
            len = len.split(" ").map(&:to_i) #Separate letter and num
            if len[1] != nil #Verifies there IS a num
              lon = len[1]
            elsif len[1] == nil
              lon = 1
            end
            if xy == 0
              string_maker(lon)
              @out << "00"
            elsif xy == 1
              @out << "00"
              string_maker(lon)
            end
          end
        end
      end
      #If x, out << xx00 if y, out << 00yy
      puts "Please type coordinates for another or type N or No to finish."
    end
    #Still need to make the breaker
  end
end

def string_maker(inp)
  if inp
    inp = "0" + inp.to_s if inp < 10
  else
    inp = "00"
  end
  @out << inp
end

get_info
puts @out.join
`echo "\n"#{@out.join} >> ./Saves/Box_sf.txt`
#Now write it to the file.

#File.open("./Saves/Box_sf.txt", 'a+')

#Needs to subtract 1 from each coordinate if no walls.


# if wrap == 0
#   same
# else
#   -1
# end
# c = gets.chomp
# puts "\n"
# if c.include(" ")
#   c = c.split(" ").map(&:to_i)
#   bx = c[0]
#   by = c[1]
# else
#   bx = c.to_i
#   by = c.to_i
# end
# bx = 7 if bx <= 7
# bx = 32 if bx >= 32
# by = 7 if by <= 7
# by = 32 if by >= 32

##WBxByPxPy#b#w#d#h1x1y2x2y3x3y1x1y2x2ydxdyhxhypxpy
=begin
Walls, 0 = True, else = false
Board x
Board y
Player start x
Player start y
# of boxes on map
# of walls on map
# of holes on map
coordinate of each box
coords of each wall
coords of each hole
coords of each break/wrap(Only used if walls is true)
=end
