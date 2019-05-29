class Cell
  attr_accessor :neighbor_count, :live
  def initialize
    @live = rand(2) == 0 ? true : false
  end
  def tick
    @live = @live ? (neighbor_count == 2 || neighbor_count == 3) : (neighbor_count == 3)
  end
  def to_s
    @live ? 'o' : ' '
  end
end

class Board
  def initialize
    @rows = Array.new(50) { Array.new(100) { Cell.new } }
  end
  def tick
    @rows.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.neighbor_count =  (-1..1).map do |rel_y|
          (-1..1).map do |rel_x|
            next if rel_x == 0 && rel_y == 0
            @rows[y + rel_y][x + rel_x].live unless @rows[y + rel_y].nil? || @rows[y + rel_y][x + rel_x].nil?
          end
        end.flatten.compact.count(true)
      end
    end
    @rows.each { |row| row.each(&:tick) }
  end
  def show
    @rows.map { |row| row.join(' ') }
  end
end

class Game
  def initialize
    @board = Board.new
  end
  def tick
    @board.tick
  end
  def draw
    system 'clear' or system 'cls'
    puts @board.show
  end
end

game = Game.new
while true do
  game.tick
  game.draw
  sleep 0.2
end
