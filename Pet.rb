@boardx = 50
@boardy = 20
@empty = " "
@line = "▒"
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}

t = Time.now
@tick_time = 0.8
@tick = 0
@time1 = t
@time2 = t
@frame_count = 0
@frame_rate = 0
@timer = 0
@error = 0
@even = 0

@gross = [5]

@pet = {
  x: 15,
  y: 19,
  born: Time.now,
  direction: "right",
  last_move: t,
  next_move: t + 30,
  target: 4,
  fullness: 100,
  health: 100,
  hygiene: 100,
  obedience: 100,
  positivity: 100,
  strength: 100,
  type: "blob"
}
# Blob width: (-4..5)
# `say =v Bells "d"`

def boardClear
  @board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
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
      @board[@boardy - 1 - y_value][@pet[:x] + x] = @empty if flip == false
      @board[@boardy - 1 - y_value][@pet[:x] - x] = @empty if flip == true
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

  if t > @pet[:last_move] + @tick_time
    movement
    change = true
  end

  draw if change == true
end

def timerControl(t)
  delta = 0
  old_time = @timer
  @even = @tick % 2

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
  @error = "#{@pet[:next_move] - Time.now}\n#{@pet[:x]} - #{@pet[:target]}"
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

def draw
  system "clear" or "cls"
  i = 0
  print "  "
  @boardx.times do |x|
    print "#{x.to_s.split("").last}"
  end
  puts ""
  while i < @board.length
    print "#{i} " if i < 10
    print "#{i}" if i >= 10
    print @board[i].join
    puts "."
    i += 1
  end
  puts @tick
  puts @error
end

loop do
  tick
end
