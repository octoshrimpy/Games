class Settings
  @@scroll = 0
  @@game_height = (Game::VIEWPORT_HEIGHT + Game::LOGS_GUI_HEIGHT + 4)
  @@game_width = (Game::VIEWPORT_WIDTH + Game::STATS_GUI_WIDTH + 1)

  def self.receive(input)
    tick = false
    case input
    when "UP", "w"
      tick = true
      scroll_up
    when "Left", "a"
      tick = true
      scroll_left
    when "DOWN", "x"
      tick = true
      scroll_down
    when "RIGHT", "d"
      tick = true
      scroll_right
    when "ESCAPE"
      $gamemode = "play"
      @@scroll = nil
      Game.draw
    end
    tick
  end

  def self.scroll_up
    case $gamemode
    when "info"
      @@scroll -= 1 if @@scroll > 0
    end
  end

  def self.scroll_left
    case $gamemode
    when "info"
    end
  end

  def self.scroll_right
    case $gamemode
    when "info"
    end
  end

  def self.scroll_down
    case $gamemode
    when "info"
      @@scroll += 1 if @@scroll < Log.all.count - @@game_height + 4
    end
  end

  def self.show
    evaluate_settings
    system 'clear' or system 'cls'
    Game.input(true)
    @@game_height.times do |y|
      @@game_width.times do |x|
        print (y == 0 || y == @@game_height-1 ? "--" : "  ").color(:black, :white)
      end
      print "|".color(:black, :white)
      puts "\r|#{$settings[y]}".color(:black, :white)
    end
    puts @@scroll
    Game.input(false)
  end

  def self.evaluate_settings
    $settings = Array.new(@@game_height) {""}
    case $gamemode
    when "info"
      # Fix less than logs above/below count showing total logs
      @@scroll ||= Log.all.count - @@game_height + 4
      @@scroll = @@scroll > 0 ? @@scroll : 0
      above_count = @@scroll
      top = "^ #{above_count} ^"
      $settings[1] = "#{'  '*(@@game_width/2 - top.length/2)}#{top}"
      (@@game_height - 4).times do |y|
        $settings[y + 2] = " #{Log.all.reverse[@@scroll + y]}".override_background_with(:white).override_foreground_with(:black)
      end
      below_count = Log.all.count - @@scroll - @@game_height + 4
      below_count = below_count > 0 ? below_count : 0
      bottom = "v #{below_count} v"
      $settings[@@game_height - 2] = "#{'  '*(@@game_width/2 - bottom.length/2)}#{bottom}"
    when "settings"
    when "inspect"
    when "logs"
    end
  end
end
