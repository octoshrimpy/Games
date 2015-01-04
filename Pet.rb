@boardx = 60
@boardy = 20
@pet = {
  x: 30,
  y: 19,
  born: Time.now,
  direction: "left",
  type: "blob"
}
@empty = "  "
@line = "• "
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
@tick = 0
@tick_time = 1

def boardClear
  @board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
end

def drawAt(y, x, mark)
  @board[y][x] = mark
end

def drawEgg
  px = @pet[:x]
  py = @pet[:y]
  num = @tick % 2
  if num == 0
    # Shape
    [8].each { |y| [0, 1].each { |x| drawAt(py-y, x-px, @line) }}
    [7].each { |y| [2, -1].each { |x| drawAt(py-y, x-px, @line) }}
    (2..5).each { |y| [-3, 4].each { |x| drawAt(py-y, x-px, @line) }}
    [1, 6].each { |y| [-2, 3].each { |x| drawAt(py-y, x-px, @line) }}
    [0].each { |y| (-1..2).each { |x| drawAt(py-y, x-px, @line) }}
    # Stripe
    [1, 5, 6].each { |y| [-1].each { |x| drawAt(py-y, x-px, @line) }}
    (1..5).each { |y| [0].each { |x| drawAt(py-y, x-px, @line) }}
    (2..4).each { |y| [1].each { |x| drawAt(py-y, x-px, @line) }}
  else
    # Shape
    [6].each { |y| [0, 1].each { |x| drawAt(py-y, x-px, @line) }}
    [5].each { |y| [-1, 2].each { |x| drawAt(py-y, x-px, @line) }}
    [4].each { |y| [-2, 3].each { |x| drawAt(py-y, x-px, @line) }}
    (1..3).each { |y| [-3, 4].each { |x| drawAt(py-y, x-px, @line) }}
    [0].each { |y| (-2..3).each { |x| drawAt(py-y, x-px, @line) }}
    # Stripe
    [3, 4].each { |y| [-1].each { |x| drawAt(py-y, x-px, @line) }}
    (1..4).each { |y| [0].each { |x| drawAt(py-y, x-px, @line) }}
    (1..3).each { |y| [1].each { |x| drawAt(py-y, x-px, @line) }}
  end
end

def drawBlob
  px = @pet[:x]
  py = @pet[:y]
  num = @tick % 2
  case @pet[:direction]
  when "still"
    if num == 0
      # Shape
      [5].each { |y| (-1..1).each { |x| drawAt(py-y, x-px, @line) }}
      [4].each { |y| [-2, 2].each { |x| drawAt(py-y, x-px, @line) }}
      [3].each { |y| [-3, 3].each { |x| drawAt(py-y, x-px, @line) }}
      [1, 2].each { |y| [-4, 4].each { |x| drawAt(py-y, x-px, @line) }}
      [0].each { |y| (-4..4).each { |x| drawAt(py-y, x-px, @line) }}
      # Eyes
      [2, 3].each { |y| [-1, 1].each { |x| drawAt(py-y, x-px, @line) }}
    else
      # Shape
      [6].each { |y| (-1..1).each { |x| drawAt(py-y, x-px, @line) }}
      [5].each { |y| [-2, 2].each { |x| drawAt(py-y, x-px, @line) }}
      [4].each { |y| [-3, 3].each { |x| drawAt(py-y, x-px, @line) }}
      [1, 2, 3].each { |y| [-4, 4].each { |x| drawAt(py-y, x-px, @line) }}
      [0].each { |y| (-3..3).each { |x| drawAt(py-y, x-px, @line) }}
      # Eyes
      [4, 3].each { |y| [-1, 1].each { |x| drawAt(py-y, x-px, @line) }}
    end
  when "left"
    if num == 0
      # Shape
      [5].each { |y| (-2..1).each { |x| drawAt(py-y, x-px, @line) }}
      [4].each { |y| [-3, 2].each { |x| drawAt(py-y, x-px, @line) }}
      [3].each { |y| [-4, 3].each { |x| drawAt(py-y, x-px, @line) }}
      [1, 2].each { |y| [-4, 4].each { |x| drawAt(py-y, x-px, @line) }}
      [0].each { |y| (-3..4).each { |x| drawAt(py-y, x-px, @line) }}
      # Eyes
      [2, 3].each { |y| [-2].each { |x| drawAt(py-y, x-px, @line) }}
    else
      # Shape
      [5].each { |y| (-2..1).each { |x| drawAt(py-y, x-px, @line) }}
      [4].each { |y| [-3, 2].each { |x| drawAt(py-y, x-px, @line) }}
      [3].each { |y| [-4, 3].each { |x| drawAt(py-y, x-px, @line) }}
      [2].each { |y| [-4, 4].each { |x| drawAt(py-y, x-px, @line) }}
      [1].each { |y| [-4, 5].each { |x| drawAt(py-y, x-px, @line) }}
      [0].each { |y| (-3..5).each { |x| drawAt(py-y, x-px, @line) }}
      # Eyes
      [2, 3].each { |y| [-2].each { |x| drawAt(py-y, x-px, @line) }}
    end
  when "right"
  end
end

def tick
  boardClear
  case @pet[:type]
  when "egg"
    drawEgg
  when "blob"
    drawBlob
  end
  draw
  @tick += 1
  sleep @tick_time
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
end

loop do
  tick
end
