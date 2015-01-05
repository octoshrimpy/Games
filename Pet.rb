@boardx = 60
@boardy = 20
@empty = "  "
@line = "• "
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}

t = Time.now
@tick_time = 0.5
@tick = 0
@time1 = t
@time2 = t
@frame_count = 0
@frame_rate = 0
@timer = 0
@error = 0

@pet = {
  x: 30,
  y: 19,
  born: Time.now,
  direction: "right",
  last_move: t,
  next_move: t + 20,
  target: 54,
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

def drawCoords(coords, flip=false)
  coords.each do |coord|
    drawAt(@pet[:y]-coord[0], @pet[:x]+coord[1], @line) if flip == false
    drawAt(@pet[:y]-coord[0], @pet[:x]-coord[1], @line) if flip == true
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
  if num == 0
    # Shape
    [8].each { |y| [0, 1].each { |x| coords << [y, x] }}
    [7].each { |y| [2, -1].each { |x| coords << [y, x] }}
    (2..5).each { |y| [-3, 4].each { |x| coords << [y, x] }}
    [1, 6].each { |y| [-2, 3].each { |x| coords << [y, x] }}
    [0].each { |y| (-1..2).each { |x| coords << [y, x] }}
    # Stripe
    [1, 5, 6].each { |y| [-1].each { |x| coords << [y, x] }}
    (1..5).each { |y| [0].each { |x| coords << [y, x] }}
    (2..4).each { |y| [1].each { |x| coords << [y, x] }}
  else
    # Shape
    [6].each { |y| [0, 1].each { |x| coords << [y, x] }}
    [5].each { |y| [-1, 2].each { |x| coords << [y, x] }}
    [4].each { |y| [-2, 3].each { |x| coords << [y, x] }}
    (1..3).each { |y| [-3, 4].each { |x| coords << [y, x] }}
    [0].each { |y| (-2..3).each { |x| coords << [y, x] }}
    # Stripe
    [3, 4].each { |y| [-1].each { |x| coords << [y, x] }}
    (1..4).each { |y| [0].each { |x| coords << [y, x] }}
    (1..3).each { |y| [1].each { |x| coords << [y, x] }}
  end
  drawCoords(coords)
end

def drawBlob
  px = @pet[:x]
  py = @pet[:y]
  num = @tick % 2
  coords = []
  if @pet[:direction] == "still"
    if num == 0
      # Shape
      [5].each { |y| (-1..1).each { |x| coords << [y, x] }}
      [4].each { |y| [-2, 2].each { |x| coords << [y, x] }}
      [3].each { |y| [-3, 3].each { |x| coords << [y, x] }}
      [1, 2].each { |y| [-4, 4].each { |x| coords << [y, x] }}
      [0].each { |y| (-4..4).each { |x| coords << [y, x] }}
      # Eyes
      [2, 3].each { |y| [-1, 1].each { |x| coords << [y, x] }}
    else
      # Shape
      [6].each { |y| (-1..1).each { |x| coords << [y, x] }}
      [5].each { |y| [-2, 2].each { |x| coords << [y, x] }}
      [4].each { |y| [-3, 3].each { |x| coords << [y, x] }}
      [1, 2, 3].each { |y| [-4, 4].each { |x| coords << [y, x] }}
      [0].each { |y| (-3..3).each { |x| coords << [y, x] }}
      # Eyes
      [4, 3].each { |y| [-1, 1].each { |x| coords << [y, x] }}
    end
  else
    if num == 0
      # Shape
      [5].each { |y| (-2..1).each { |x| coords << [y, x] }}
      [4].each { |y| [-3, 2].each { |x| coords << [y, x] }}
      [3].each { |y| [-4, 3].each { |x| coords << [y, x] }}
      [1, 2].each { |y| [-4, 4].each { |x| coords << [y, x] }}
      [0].each { |y| (-3..4).each { |x| coords << [y, x] }}
      # Eyes
      [2, 3].each { |y| [-2].each { |x| coords << [y, x] }}
    else
      # Shape
      [5].each { |y| (-2..1).each { |x| coords << [y, x] }}
      [4].each { |y| [-3, 2].each { |x| coords << [y, x] }}
      [3].each { |y| [-4, 3].each { |x| coords << [y, x] }}
      [2].each { |y| [-4, 4].each { |x| coords << [y, x] }}
      [1].each { |y| [-4, 5].each { |x| coords << [y, x] }}
      [0].each { |y| (-3..5).each { |x| coords << [y, x] }}
      # Eyes
      [2, 3].each { |y| [-2].each { |x| coords << [y, x] }}
    end
  end
  if @pet[:direction] == "right"
    drawCoords(coords, true)
  else
    drawCoords(coords)
  end
end

def tick
  change = false
  t = Time.now
  change = timerControl(t)

  if t > @pet[:last_move] + @tick_time
    movement if @pet[:type] != "egg"
    change = true
  end

  draw if change == true
end

def timerControl(t)
  delta = 0
  old_time = @timer

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
    @pet[:next_move] = t + 10 + rand(50)
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
  if @pet[:type] != "egg"
    if @pet[:target] < @pet[:x]
      @pet[:x] -= 1 if @tick % 2 == 1
      @pet[:direction] = "left"
    elsif @pet[:target] > @pet[:x]
      @pet[:x] += 1 if @tick % 2 == 1
      @pet[:direction] = "right"
    else
      @pet[:direction] = "still"
    end
  end
  case @pet[:type]
  when "egg"
    drawEgg
  when "blob"
    drawBlob
  end
  @error = "#{Time.now} - #{@pet[:next_move]}\n#{@pet[:x]} - #{@pet[:target]}"
  @tick += 1
  @pet[:last_move] = Time.now
end

def draw
  system "clear" or "cls"
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
  puts @tick
  puts @error
end

loop do
  tick
end
