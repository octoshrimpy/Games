require 'io/console'
require 'io/wait'
# Recommended Font settings:
# Horizontal: 4th tick
# Vertical: 0.6
# Settings -> Sound -> Tink

@boardx = 93
@boardy = 30
@empty = " "
@line = "\e[47m \e[0m"
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}

t = Time.now
@tick_time = 0.8
@tick = 0
@force_update = false
@last_interact = t
@time1 = t
@time2 = t
@frame_count = 0
@frame_rate = 0
@lights_on = true
@timer = 0
@error = 0
@active = false
@even = 0
@food = []

@gross = []

@select = 4
@menu = "default"
@options = {
  default: ["Food", "Play", "Train", "Clean", "Medicine", "Lights", "Stats", ""],
  food: ["Meat", "Pizza", "Cookie", "Cake", "", "", "", ""],
  train: ["Run", "Lift", "Spar", "Jump", "", "", "", ""],
  medicine: ["Vitamin", "Shot", "Emergency", "", "", "", "", ""],
  play: ["Ball", "Catch", "", "", "", "", "", ""],
  stats: ["Health", "Hunger", "Hygiene", "Obedience", "Strength", "Weight", "", ""]
}

@pet = {
  x: @boardx/2,
  y: 19,
  born: Time.now,
  direction: "right",
  last_beep: t,
  evolve: t + 60,
  last_move: t,
  next_move: t + 90,
  next_drop: t + (10 * 60),
  stat_drop: t + 120,
  target: 80,
  weight: 3.0,
  fullness: 600,
  health: 400,
  hygiene: 400,
  obedience: 500,
  happiness: 60,
  strength: 600,
  type: "egg"
}
@max = {
  fullness: 850,
  health: 500,
  hygiene: 500,
  obedience: 1000,
  happiness: 100,
  strength: 800
}

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

def foodCoords(food)
  coords = []
  case food
  when "meat" #26
    coords << [-4] #0
    coords << [-3] #1
    coords << [-2] #2
    coords << [-3, -2, -1, 0] #3
    coords << [-2, -1, 0, 1] #4
    coords << [-2, -1, 0, 1, 2] #5
    coords << [-1, 1, 2, 3] #6
    coords << [0, 2, 3] #7
    coords << [1, 2, 4] #8
  when "pizza" #20
    coords << [0] #0
    coords << [-1, 0, 1] #1
    coords << [-2, -1, 1] #2
    coords << [-3, -2, 0, 1, 2] #3
    coords << [-2, -1, 0, 2] #4
    coords << [0, 1, 2] #5
    coords << [3] #6
  when "cookie" #25
    coords << [0, 1] #0
    coords << [-1, 1, 2] #1
    coords << [-2, 0, 1, 3] #2
    coords << [-2, -1, 0, 1, 2, 3] #3
    coords << [-2, -1, 1, 3] #4
    coords << [-1, 0, 1, 2] #5
    coords << [0, 1] #6
  when "cake" #22
    coords << [-3, -2, -1, 0, 1, 2] #0
    coords << [-3, -2, -1, 0, 1, 2] #1
    coords << [-3, -1, 0, 1] #2
    coords << [-3, 0] #3
    coords << [-3, -1] #4
    coords << [-3, -2] #5
  when "vitamin" #22
    coords << [1, 2] #0
    coords << [0, 3] #1
    coords << [0, 3] #2
    coords << [0, 3] #3
    coords << [0, 1, 2, 3] #4
    coords << [0, 1, 2, 3] #5
    coords << [0, 1, 2, 3] #6
    coords << [1, 2] #7
  end
  return coords
end

def wiperCoords(height, multiplier)
  coords = []
  height.times do |y|
    coords[y] = y <= height / 2 ?
      y + 1 :
      (height*2 - y*2)/2
  end
  wiper = []
  coords.each_with_index do |length, y|
    length.times do |x|
      multiplier.times do |m|
        wiper << [y+(height*m), x]
      end
    end
  end
  wiper.each { |wipe| @board[wipe[0]][wipe[1]] = @line }
  return wiper
end

def tick
  change = false
  @t = Time.now
  change = timerControl
  statChecker if @t > @pet[:stat_drop]
  droppingChecker if @t > @pet[:next_drop]

  if @t > @pet[:last_move] + @tick_time && @active == false
    movement
    change = true
  end
  animate if @active != false

  beepChecker if @t > @pet[:last_beep]
  draw if change == true || @force_update == true
  @force_update = false
end

def inputChecker(input)
  input = input[0]
  case input
  when "x"
    exit
  when "a"
    @select -= 1
  when "d"
    @select += 1
  when "w"
    if @menu != "default"
      @select = @options[:default].index(@menu.capitalize) + 1
      @menu = "default"
    else
      @select = 0
    end
  when "s"
    activity(@menu, @select)
  end
  @last_interact = Time.now

  length = case @menu
  when "default"
    (@options[:default] - [""]).length
  when "food"
    (@options[:food] - [""]).length
  when "train"
    (@options[:train] - [""]).length
  when "medicine"
    (@options[:medicine] - [""]).length
  when "play"
    (@options[:play] - [""]).length
  when "stats"
    (@options[:stats] - [""]).length
  else
    (@options[:default] - [""]).length
  end
  @select = @menu == "default" ? 0 : 1 if @select > length
  @select = length if (@select < 0 && @menu == "default") || (@select < 1 && @menu != "default")
  beeper(1)
  @force_update = true
end

def activity(menu, selection)
  case menu
  when "default"
    case selection
    when 1 # Food
      @menu = "food"
    when 2 # Play
      @menu = "play"
    when 3 # Train
      @menu = "train"
    when 4 # Clean
      animate("clean") if @lights_on
    when 5 # Medicine
      @menu = "medicine"
    when 6 # Lights
      @lights_on = @lights_on ? false : true
    when 7 # Stats
      @menu = "stats"
    when 8 #
    end
  when "food"
    case selection
    when 1 # Meat
      consume("meat")
    when 2 # Pizza
      consume("pizza")
    when 3 # Cookie
      consume("cookie")
    when 4 # Cake
      consume("cake")
    when 5 #
    when 6 #
    when 7 #
    when 8 #
    end
  when "train"
    case selection
    when 1 # Run
      @pet[:strength] += 150
    when 2 # Lift
    when 3 # Spar
    when 4 # Jump
      # Menus can be shown, but actions cannot be done if @active == true
    when 5 #
    when 6 #
    when 7 #
    when 8 #
    end
  when "medicine"
    case selection
    when 1 # Vitamin
      consume("vitamin")
    when 2 # Shot
    when 3 # Emergency
    when 4 #
    when 5 #
    when 6 #
    when 7 #
    when 8 #
    end
  when "play"
    case selection
    when 1 # Ball
    when 2 # Catch
    when 3 #
    when 4 #
    when 5 #
    when 6 #
    when 7 #
    when 8 #
    end
  when "stats"
    case selection
    when 1 # Health
    when 2 # Hunger
    when 3 # Hygiene
    when 4 # Obedieance
    when 5 # Strength
    when 6 # Weight
    when 7 #
    when 8 #
    end
  end
  if menu != "default"
    @menu = "default"
    @select = 0
  else
    @select = 1
  end
end

# weight: 5,
# fullness: 2,
# health: 80,
# hygiene: 1,
# obedience: 2,
# happiness: 2,
# strength: 0,
# Rename consume to different. Send all actions through it to upgrade stats

def consume(food)
  animate(food) if @pet[:type] != "egg"
  case food
  when "meat"
    case @pet[:type]
    when "blob"
      @pet[:fullness] += 50
      @pet[:weight] += 2 if @pet[:fullness] > @max[:fullness]
    end
  when "pizza"
    case @pet[:type]
    when "blob"
      @pet[:happiness] -= 3
      @pet[:fullness] += 35
      @pet[:weight] += 1
      @pet[:weight] += 1 if @pet[:fullness] > @max[:fullness]
      @pet[:obedience] -= 1
    end
  when "cookie"
    case @pet[:type]
    when "blob"
      @pet[:happiness] += 5
      @pet[:fullness] += 25
      @pet[:weight] += 1
      @pet[:weight] += 2 if @pet[:fullness] > @max[:fullness]
      @pet[:obedience] += 1
    end
  when "cake"
    case @pet[:type]
    when "blob"
      @pet[:fullness] += 50
      @pet[:weight] += 5
      @pet[:weight] += 5 if @pet[:fullness] > @max[:fullness]
    end
  when "vitamin"
    case @pet[:type]
    when "blob"
      @pet[:health] += @pet[:health] < 80 ? 5 : -5
      @pet[:fullness] -= 5
      @pet[:happiness] -= 10
    end
  end
  allowedValueChecker
end

def animate(picture = false)
  # Eating displays pet look-alike at center screen that eats
  if picture
    boardClear
    case picture
    when "clean"
      number_of_wipers = 5
      @food = wiperCoords(@boardy/number_of_wipers, number_of_wipers)
      drawDung
    else
      @food = foodCoords(picture)
    end
    @active = picture
  else
    @menu = "default"
    @select = 0
    case @active
    when "clean"
      new_wiper = []
      @food.each do |y, x|
        @board[y][x] = @empty if !@food.include?([y, x-1])
        if x != @boardx
          new_wiper << [y, x+1]
          @board[y][x+1] = @line
        else
          @food -= [y, x]
        end
      end
      @food = new_wiper
      draw
      if @food.length <= 0
        @active = false
        @gross = []
      end
    else
      new_food = []
      @food.each do |y, x|
        # Take away the top right pixels ------------------------------------- TODO
        # Delay
        # Remove particles
        # Draw each food particle
      end
      @food = new_food
      draw
      if @food.length <= 0
        @active = false
      end
    end
  end
end

def play(action)
end

def evolveController
  @pet[:type] = case @pet[:type]
  when "egg"
    @pet[:evolve] = Time.now + (1.5 * 60 * 60 * 24)
    "blob"
  end
  beeper(3)
end

def beepChecker
  if (@pet[:health] < 50 || @pet[:hygiene] < 40 || @pet[:happiness] < 40)
    @pet[:last_beep] = Time.now + (10 * 60)
    # `say -v Bells "d"`
    beeper(5)
  end
end

def beeper(beeps=1)
  beeps.times do |beep|
    print "\a"
    sleep 0.1
  end
end

def statChecker
  @pet[:obedience] -= 1
  @pet[:fullness] -= 1
  @pet[:hygiene] -= @gross.length
  @pet[:hygiene] += 1 if @gross.length == 0
  @pet[:happiness] -= 1
  @pet[:strength] -= 1
  @pet[:stat_drop] = Time.now + 30
  veryHealthy = true
  [[@pet[:hygiene], @max[:hygiene]], [@pet[:happiness], @max[:happiness]], [@pet[:strength], @max[:strength]], [@pet[:fullness], @max[:fullness]]].each do |stat|
    if stat[0] < stat[1]/2
      @pet[:health] -= 1
      @pet[:weight] -= 0.1
      veryHealthy = false
    end
    if stat[0] <= 0
      @pet[:health] -= 1
      @pet[:weight] -= 0.1
    end
  end
  allowedValueChecker
  @pet[:health] += 1 if veryHealthy
  if @pet[:health] < 0
    puts "Your pet died!"
    exit
  end
end

def allowedValueChecker
  @pet[:weight] = @pet[:weight].round(1)
  @pet[:weight] = 0 if @pet[:weight] < 0
  @pet[:fullness] = 0 if @pet[:fullness] < 0
  @pet[:fullness] = @max[:fullness] if @pet[:fullness] > @max[:fullness]
  @pet[:health] = @max[:health] if @pet[:health] > @max[:health]
  @pet[:hygiene] = 0 if @pet[:hygiene] < 0
  @pet[:hygiene] = @max[:hygiene] if @pet[:hygiene] > @max[:hygiene]
  @pet[:obedience] = 0 if @pet[:obedience] < 0
  @pet[:obedience] = @max[:obedience] if @pet[:obedience] > @max[:obedience]
  @pet[:happiness] = 0 if @pet[:happiness] < 0
  @pet[:happiness] = @max[:happiness] if @pet[:happiness] > @max[:happiness]
  @pet[:strength] = 0 if @pet[:strength] < 0
  @pet[:strength] = @max[:strength] if @pet[:strength] > @max[:strength]
end

def droppingChecker
  @gross << @pet[:x]
  @pet[:next_drop] =@t+ (100 - @pet[:fullness]) + rand(6 * 60 * 60)
end

def timerControl
  delta = 0
  old_time = @timer
  @even = @tick % 2
  if @last_interact + 30 < @t
    @menu = "default"
    @select = 0
  end

  if @time1 > @time2
    @time2 = @t
    delta = @time2 - @time1 if @time2 - @time1 < 3
  else
    @time1 = @t
    delta = @time1 - @time2 if @time1 - @time2 < 3
  end
  @frame_count += 1
  @frame_rate += 1
  @timer += delta.round(5)
  @timer = @timer.round(5)

  if @t > @pet[:next_move]
    @pet[:next_move] = @t + 10 + rand(30)
    @pet[:target] = case @pet[:type]
    when "blob"
      rand(@boardx - 8) + 4
    end
  end

  evolveController if @t > @pet[:evolve]

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
      when "food"
        @options[:food]
      when "train"
        @options[:train]
      when "medicine"
        @options[:medicine]
      when "play"
        @options[:play]
      when "stats"
        @options[:stats]
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
  if @lights_on == false
    @board.each_with_index do |col, y|
      col.each_with_index do |row, x|
        @board[y][x] = @line
      end
    end
  end
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
  puts "
    fullness: #{@pet[:fullness]*100/@max[:fullness]}
    health: #{@pet[:health]*100/@max[:health]}
    hygiene: #{@pet[:hygiene]*100/@max[:hygiene]}
    obedience: #{@pet[:obedience]*100/@max[:obedience]}
    happiness: #{@pet[:happiness]*100/@max[:happiness]}
    strength: #{@pet[:strength]*100/@max[:strength]}
    weight: #{@pet[:weight]}lbs
  "
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
