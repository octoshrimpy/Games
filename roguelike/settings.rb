class Settings
  @@game_height = (Game::VIEWPORT_HEIGHT + Game::LOGS_GUI_HEIGHT + 4)
  @@game_width = (Game::VIEWPORT_WIDTH + Game::STATS_GUI_WIDTH + 1)

  def self.receive(input)
    unless $gamemode == 'play'
      tick = false
      case input
      when "UP", $key_move_up
        tick = true
        scroll_up
      when "LEFT", $key_move_left
        tick = true
        scroll_left
      when "DOWN", $key_move_down
        tick = true
        scroll_down
      when "RIGHT", $key_move_right
        tick = true
        scroll_right
      when "ESCAPE"
        $gamemode = "play"
        @@scroll = nil
        Game.draw
      end
      tick
    end

    case input
    when $key_open_help
      $gamemode = $gamemode.toggle("help", 'play')
      $gamemode == 'play' ? (Game.draw; @@scroll = nil) : Settings.show
    when $key_open_logs
      $gamemode = $gamemode.toggle("logs", 'play')
      $gamemode == 'play' ? (Game.draw; @@scroll = nil) : Settings.show
    when $key_open_keybindings
      $gamemode = $gamemode.toggle("key_bindings", 'play')
      $gamemode == 'play' ? (Game.draw; @@scroll = nil) : Settings.show
    end

  end

  def self.scroll_up
    case $gamemode
    when "logs"
      @@scroll -= 1
    end
    show
  end

  def self.scroll_left
    case $gamemode
    when "logs"
    end
    show
  end

  def self.scroll_right
    case $gamemode
    when "logs"
    end
    show
  end

  def self.scroll_down
    case $gamemode
    when "logs"
      @@scroll += 1
    end
    show
  end

  def self.show
    generate_settings
    system 'clear' or system 'cls'
    Game.input(true)
    @@game_height.times do |y|
      @@game_width.times do |x|
        print (y == 0 || y == @@game_height-1 ? "--" : "  ").color(:black, :white)
      end
      print "|".color(:black, :white)
      puts "\r|#{$settings[y]}".color(:black, :white)
    end
    Game.input(false)
  end

  def self.generate_settings
    lines = case $gamemode
    when "help"
      build_help_menu
    when ""
    when "logs"
      build_log_menu
    end
    build_menu(lines)
  end

  def self.build_menu(lines)
    $settings = Array.new(@@game_height) {""}
    max = lines.count - @@game_height + 4
    @@scroll = @@scroll > max ? max : @@scroll
    @@scroll = @@scroll > 0 ? @@scroll : 0

    above_count = @@scroll
    top = "^ #{above_count} ^"
    $settings[1] = "#{'  '*(@@game_width/2 - top.length/2)}#{top}"
    (@@game_height - 4).times do |y|
      $settings[y + 2] = " #{lines[@@scroll + y]}".override_background_with(:white).override_foreground_with(:black)
    end
    below_count = lines.count - @@scroll - @@game_height + 4
    bottom = "v #{below_count > 0 ? below_count : 0} v"
    $settings[@@game_height - 2] = "#{'  '*(@@game_width/2 - bottom.length/2)}#{bottom}"
  end

  def self.build_help_menu
    @@scroll ||= 0
    word_wrap(help_menu_text.split("\n"))
  end

  def self.word_wrap(sections)
    lines = []
    sections.each do |text|
      line = ""
      text.split(' ').each do |word|
        if line.length + word.length < @@game_width*2 - 2
          line += " #{word}"
        else
          lines << line
          line = ""
        end
      end
      lines << line
    end
    lines
  end

  def self.build_log_menu
    lines = Log.all.reverse
    @@scroll ||= lines.count - @@game_height + 4
    lines
  end

  def self.help_menu_text
%(
HELP - exit by pressing ESCAPE or the '#{$key_open_help}' key once again.

View and edit keys by hitting the '#{$key_open_keybindings}' key.

-------------------------------------------------------------------------------- #{'Movement'.color(:red)}
Each frame takes place on every interval of the speed of the Player(you). Monster may move faster or slower than you. Speed is calculated by a single number, 1-100. 1 being the slowest, 100 being the fastest. If the player moves at a speed of 10 and a monster moves at a speed of 15, the monsters position will only update every time the player moves. Every other turn the monster will appear to move 2 spaces because of the extra speed.
)
  end
end
