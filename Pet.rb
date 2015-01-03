@boardx = 60
@boardy = 20
@pet = {
  x: 30,
  y: 19,
  born: Time.now,
  type: "egg"
}
@empty = ". "
@line = "x "
@board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
@tick = 0
@tick_time = 0.8

def boardClear
  @board = Array.new(@boardy) {Array.new(@boardx) {@empty}}
end

def drawAt(y, x, mark)
  @board[y][x] = mark
end

def egg
  px = @pet[:x]
  py = @pet[:y]
  num = @tick % 2
  if num == 0
    # Shape
    [8].each { |y| [0, 1].each { |x| drawAt(py-y, px-x, @line) }}
    [7].each { |y| [2, -1].each { |x| drawAt(py-y, px-x, @line) }}
    (2..5).each { |y| [-3, 4].each { |x| drawAt(py-y, px-x, @line) }}
    [1, 6].each { |y| [-2, 3].each { |x| drawAt(py-y, px-x, @line) }}
    [0].each { |y| (-1..2).each { |x| drawAt(py-y, px-x, @line) }}
    # Stripe
    [1, 5, 6].each { |y| [-1].each { |x| drawAt(py-y, px-x, @line) }}
    (1..5).each { |y| [0].each { |x| drawAt(py-y, px-x, @line) }}
    (2..4).each { |y| [1].each { |x| drawAt(py-y, px-x, @line) }}
  else
    # Shape
    [6].each { |y| [0, 1].each { |x| drawAt(py-y, px-x, @line) }}
    [5].each { |y| [-1, 2].each { |x| drawAt(py-y, px-x, @line) }}
    [4].each { |y| [-2, 3].each { |x| drawAt(py-y, px-x, @line) }}
    (1..3).each { |y| [-3, 4].each { |x| drawAt(py-y, px-x, @line) }}
    [0].each { |y| (-2..3).each { |x| drawAt(py-y, px-x, @line) }}
    # Stripe
    [3, 4].each { |y| [-1].each { |x| drawAt(py-y, px-x, @line) }}
    (1..4).each { |y| [0].each { |x| drawAt(py-y, px-x, @line) }}
    (1..3).each { |y| [1].each { |x| drawAt(py-y, px-x, @line) }}
  end
end

def tick
  boardClear
  case @pet[:type]
  when "egg"
    egg
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
end

loop do
  tick
end
