require 'io/console'
require 'io/wait'
# Recommended Font settings:
# Horizontal: 4th tick
# Vertical: 0.6

@boardx = 95
@boardy = 30
@empty = " "
@line = "▒"
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}

t = Time.now
@tick_time = 0.8
@tick = 0
@last_interact = t
@time1 = t
@time2 = t
@frame_count = 0
@frame_rate = 0
@timer = 0
@error = 0
@even = 0

@gross = []

@select = 7
@menu = "default"
@options = {
  default: ["Food", "Play", "Train", "Clean", "Medicine", "Lights", "Stats", ""],
  food: [],
  train: [],
  play: [],
  stats: []
}

@pet = {
  x: 15,
  y: 19,
  born: Time.now,
  direction: "right",
  last_beep: t,
  beep: true,
  evolve: t + 60,
  last_move: t,
  next_move: t + 90,
  next_drop: t + (30 * 60),
  stat_drop: t + 2,#FIXME 120
  target: 4,
  weight: 5,
  fullness: 20,
  health: 80,
  hygiene: 10,
  obedience: 20,
  happiness: 20,
  strength: 10,
  type: "blob"
}
# TODO
# http://webspace.ringling.edu/~clopez/bu230/gigapet/essay.html
# Evolve + stages
# Features
#   Feed
#   Play
#   Train
#   Clean
#   Medicine
#   Light
#   Stats
# Weight ++ if over fed
# Training
# Sleep Morning/Night Health ++ if light is off. -- if on
# Death

# Stages:
# Egg ~5-10min
# Blob ~1-2 hours *Lots of attention
# Baby ~1-3 days
# Child ~week
# Adult ~2 weeks
# Senior




# Blob width: (-4..5)

def boardClear
  @board = Array.new(@boardy) { Array.new(@boardx) {@empty} }
end

def drawCoords(coords, origin, flip=false)
  coords.each_with_index do |x_values, index|
    x_values.each do |x|
      drawAt(@boardy-1-index, origin+x, @line) if flip == false
      drawAt(@boardy-1-index, origin-x, @line) if flip == true
    end
  end
end

def drawSpace(coords, flip=false)
  coords.each_with_index do |x_values, y_value|
    (x_values.first..x_values.last).each do |x|
      drawAt(@boardy - 1 - y_value, @pet[:x] + x, @empty) if flip == false
      drawAt(@boardy - 1 - y_value, @pet[:x] - x, @empty) if flip == true
    end
  end
end

def drawAt(y, x, mark)
  @board[y][x] = mark
end

def drawEgg
  px = @pet[:x]
  py = @pet[:y]
  num = @tick % 2
  coords = []
  if @even == 0
    coords << (-1..2).to_a #0
    coords << [-2, -1, 0, 3] #1
    coords << [-3, 0, 1, 4] #2
    coords << [-3, 0, 1, 4] #3
    coords << [-3, 0, 1, 4] #4
    coords << [-3, -1, 0, 4] #5
    coords << [-2, -1, 3] #6
    coords << [2, -1] #7
    coords << [0, 1] #8
  else
    coords << (-2..3).to_a #0
    coords << [-3, 0, 1, 4] #1
    coords << [-3, 0, 1, 4] #2
    coords << [-3, -1, 0, 1, 4] #3
    coords << [-2, -1, 0, 3] #4
    coords << [-1, 2] #5
    coords << [0, 1] #6
  end
  drawSpace(coords)
  drawCoords(coords, @pet[:x])
end

def drawBlob
  px = @pet[:x]
  py = @pet[:y]
  coords = []
  if @pet[:direction] == "still"
    if @even == 0
      coords << (-4..4).to_a #0
      coords << [-4, 4] #1
      coords << [-4, -1, 1, 4] #2
      coords << [-3, -1, 1, 3] #3
      coords << [-2, 2] #4
      coords << (-1..1).to_a #5
    else
      coords << (-3..3).to_a #0
      coords << [-4, 4] #1
      coords << [-4, 4] #2
      coords << [-4, -1, 1, 4] #3
      coords << [-3, -1, 1, 3] #4
      coords << [-2, 2] #5
      coords << (-1..1).to_a #6
    end
  else
    if @even == 0
      coords << (-3..4).to_a #0
      coords << [-4, 4] #1
      coords << [-4, -2, 4] #2
      coords << [-4, -2, 3] #3
      coords << [-3, 2] #4
      coords << (-2..1).to_a #5
    else
      coords << (-3..5).to_a #0
      coords << [-4, 5] #1
      coords << [-4, -2, 4] #2
      coords << [-4, -2, 3] #3
      coords << [-3, 2] #4
      coords << (-2..1).to_a #5
    end
  end
  if @pet[:direction] == "right"
    drawSpace(coords, true)
    drawCoords(coords, @pet[:x], true)
  else
    drawSpace(coords)
    drawCoords(coords, @pet[:x])
  end
end

def drawDung
  @gross.each do |dung_x|
    coords = []
    if @even == 0
      coords << (-1..4).to_a #0
      coords << [-1, 0, 1, 2, 4] #1
      coords << [0, 1, 3] #2
      coords << [-1, 1, 2] #3
      coords << [-2, 1, 4] #4
      coords << [-1, 3] #5
      coords << [4] #6
    else
      coords << [-1, 0, 1, 2, 3, 4] #0
      coords << [-1, 0, 1, 2, 4] #1
      coords << [0, 1, 3] #2
      coords << [1, 2, 3] #3
      coords << [-2, 1, 4] #4
      coords << [-1, 3] #5
      coords << [-2] #6
    end
    drawCoords(coords, dung_x)
  end
end

def tick
  change = false
  t = Time.now
  change = timerControl(t)
  statChecker
  droppingChecker

  if t > @pet[:last_move] + @tick_time
    movement
    change = true
  end

  beepChecker
  draw if change == true
end

def inputChecker(input)
  input = input[0]
  change = true
  case input
  when "x"
    exit
  when "a"
    @select -= 1
  when "d"
    @select += 1
  else
    change = false
  end
  @last_interact = Time.now if change == true

  @select = 0 if @select > 8
  @select = 8 if @select < 0
end

def beepChecker
  t = Time.now
  in_need = (@pet[:health] < 50 || @pet[:hygiene] < 40 || @pet[:obedience] < 40 || @pet[:happiness] < 40 || @pet[:strength] < 40)
  if t > @pet[:last_beep] && @pet[:beep] = true && in_need
    @pet[:last_beep] = t + 600 if t > @pet[:last_beep] + (1.5 * @tick_time)
    # `say -v Bells "d"`
    print "\a"
  end
end

def statChecker
  t = Time.now
  if t > @pet[:stat_drop]
    @pet[:obedience] -= 1
    @pet[:fullness] -= 1
    @pet[:hygiene] -= (1 * @gross.length) + 1
    @pet[:happiness] -= 1
    @pet[:strength] -= 1
    @pet[:stat_drop] = t + (5 * 60)#FIXME Depends on type
    veryHealthy = true
    [@pet[:hygiene], @pet[:happiness], @pet[:strength], @pet[:fullness]].each do |stat|
      if stat < 50
        @pet[:health] -= 1
        veryHealthy = false
      end
    end
    @pet[:health] += 1 if veryHealthy
    if @pet[:health] < 0
      puts "Your pet died!"
      exit
    end
  end
end

def droppingChecker
  t = Time.now
  if t > @pet[:next_drop]
    @gross << @pet[:x]
    @pet[:next_drop] = t + (100 - @pet[:fullness]) + rand(5 * 60 * 60)
  end
end

def timerControl(t)
  delta = 0
  old_time = @timer
  @even = @tick % 2
  @select = 0 if @last_interact + 30 < t

  if @time1 > @time2
    @time2 = t
    delta = @time2 - @time1 if @time2 - @time1 < 3
  else
    @time1 = t
    delta = @time1 - @time2 if @time1 - @time2 < 3
  end
  @frame_count += 1
  @frame_rate += 1
  @timer += delta.round(5)
  @timer = @timer.round(5)

  if t > @pet[:next_move]
    @pet[:next_move] = t + 10 + rand(30)
    @pet[:target] = case @pet[:type]
    when "blob"
      rand(@boardx - 8) + 4
    end
  end

  if old_time.round != @timer.round
    @fps = @frame_rate
    @frame_rate = 0
    change = true
  end
  change ||= false
end

def movement
  boardClear
  even = @tick % 2 == 1 ? true : false
  if @pet[:type] != "egg"
    if @pet[:target] < @pet[:x]
      @pet[:x] -= 1 if even
      @pet[:direction] = "left"
    elsif @pet[:target] > @pet[:x]
      @pet[:x] += 1 if even
      @pet[:direction] = "right"
    else
      @pet[:direction] = "still"
    end
  end
  drawDung
  placePet
  # @error = "#{@pet[:next_move0]000 - Time.now}\n#{@pet[:x]} - #{@pet[:target]}"
  @error = "
  fullness: #{@pet[:fullness]}
  health: #{@pet[:health]}
  hygiene: #{@pet[:hygiene]}
  obedience: #{@pet[:obedience]}
  happiness: #{@pet[:happiness]}
  strength: #{@pet[:strength]}
  "
  @tick += 1
  @pet[:last_move] = Time.now
end

def placePet
  case @pet[:type]
  when "egg"
    drawEgg
  when "blob"
    drawBlob
  end
end

def gui(pos)
  inc = @boardx / 4 #95
  select_pos = inc / 2
  5.times do |iteration|
    if iteration == 2
      string = case @menu
      when "default"
        @options[:default]
      end
      print " "
      menu_items = string.first(4) if pos == 1
      menu_items = string.last(4) if pos == 2
      menu_items.each do |word|
        print "|"
        word += " " if word.length % 2 == 1
        ((@boardx/8) - (word.length/2)).times { print " " }
        print word
        ((@boardx/8) - (word.length/2)).times { print " " }
      end
      puts "|"
    else
      print " "
      @boardx.times do |x|
        if x % inc == 0
          print "|"
        else
          if x % inc == select_pos
            if pos == 1
              where = case x
              when (0..inc)
                1
              when (inc..inc*2)
                2
              when (inc*2..inc*3)
                3
              when (inc*3..inc*4)
                4
              end
            else
              where = case x
              when (0..inc)
                5
              when (inc..inc*2)
                6
              when (inc*2..inc*3)
                7
              when (inc*3..inc*4)
                8
              end
            end
            if @select == where
              if iteration == 0
                print "v"
              elsif iteration == 4
                print "^"
              else
                print " "
              end
            else
              print " "
            end
          else
            print " "
          end
        end
      end
      puts ""
    end
  end
end

def draw
  system "stty -raw echo"
  system "clear" or "cls"
  i = 0
  gui(1)
  (@boardx + 2).times { |x| print "." }
  puts ""
  while i < @board.length
    print ":"
    print @board[i].join
    print ":"
    puts ""
    i += 1
  end
  (@boardx + 2).times { |x| print "˚" }
  puts ""
  gui(2)
  puts @tick
  puts @error
  system "stty raw -echo"
end

prompt = Thread.new do
  loop do
    inputChecker(s = STDIN.getch.downcase)
  end
end

loop do
  tick
end

system "stty -raw echo"
