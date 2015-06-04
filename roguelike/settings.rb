class Settings
  @@game_height = (Game::VIEWPORT_HEIGHT + Game::LOGS_GUI_HEIGHT + 4)
  @@game_width = (Game::VIEWPORT_WIDTH + Game::STATS_GUI_WIDTH + 1)
  @@title = ""
  @@select = nil
  @@selected_item = nil
  @@scroll = nil
  @@scroll_horz = nil
  @@selectable = nil
  @@selection_objects = []

  def self.receive(input)
    unless $gamemode == 'play'
      tick = true
      case input
      when "UP", $key_move_up then scroll_up
      when "LEFT", $key_move_left then scroll_left
      when "DOWN", $key_move_down then scroll_down
      when "RIGHT", $key_move_right then scroll_right
      when "Shift-Up", $key_move_up.capitalize then scroll_up(10)
      when "Shift-Left", $key_move_left.capitalize then scroll_left(10)
      when "Shift-Down", $key_move_down.capitalize then scroll_down(10)
      when "Shift-Right", $key_move_right.capitalize then scroll_right(10)
      when $key_move_up_right then scroll_up_right
      when $key_move_up_left then scroll_up_left
      when $key_move_down_right then scroll_down_right
      when $key_move_down_left then scroll_down_left
      when $key_move_up_right.capitalize then scroll_up_right(10)
      when $key_move_up_left.capitalize then scroll_up_left(10)
      when $key_move_down_right.capitalize then scroll_down_right(10)
      when $key_move_down_left.capitalize then scroll_down_left(10)
      when $key_move_nowhere then @@select = @@select.toggle(nil, @@scroll) if @@selectable
      when $key_confirm then confirm_selection if @@select
      when "P" then Game.pause
      when "ESCAPE"
        tick = false
        $gamemode = "play"
        clear_settings
        Game.draw
      else
        tick = false
      end
      show if tick
    end

    case input
    when $key_open_help
      $gamemode = $gamemode.toggle("help", 'play')
      $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
    when $key_open_logs
      $gamemode = $gamemode.toggle("logs", 'play')
      $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
    when $key_open_keybindings
      $gamemode = $gamemode.toggle("key_bindings", 'play')
      $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
    when $key_open_inventory
      $gamemode = $gamemode.toggle("inventory", 'play')
      $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
    when $key_open_equipment
      $gamemode = $gamemode.toggle("equipment", 'play')
      $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
    when $key_read_more
      if @@scroll_horz
        $gamemode = $gamemode.toggle("read_more", 'map')
        $gamemode == 'map' ? (@@scroll = @@select; @@select = nil) : (@@select = @@scroll)
        Settings.show
      else
        $gamemode = $gamemode.toggle("read_more", 'play')
        $gamemode == 'play' ? (Game.draw; clear_settings) : Settings.show
      end
    when $key_inspect_surroundings
      $gamemode = $gamemode.toggle("map", 'play')
      $screen_shot = nil
      if $gamemode == 'play'
        $level = Game.update_level
        Game.draw
        clear_settings
      else
        @@scroll = Player.y
        @@scroll_horz = Player.x
        Game.show
      end
    end
  end

  def self.clear_settings; @@scroll, @@scroll_horz, @@select, @@selectable, @@selection_objects = [] end
  def self.scroll_up(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(0,-amount); end
  def self.scroll_left(amount=1); move_coord(-amount,0); end
  def self.scroll_right(amount=1); move_coord(amount,0); end
  def self.scroll_down(amount=1); (@@select && @@selectable) ? (@@select += amount) : move_coord(0,amount); end
  def self.scroll_up_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,-amount); end
  def self.scroll_up_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,-amount); end
  def self.scroll_down_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,amount); end
  def self.scroll_down_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,amount); end
  def self.move_coord(x,y); @@scroll += y if @@scroll; @@scroll_horz += x if @@scroll_horz; end

  def self.show
    if generate_settings
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
  end

  def self.generate_settings
    if $gamemode == "map"
      max = $width
      @@scroll_horz = @@scroll_horz > max ? max : @@scroll_horz
      @@scroll_horz = @@scroll_horz > 0 ? @@scroll_horz : 0
      max = $height - 1
      @@scroll = @@scroll > max ? max : @@scroll
      @@scroll = @@scroll > 0 ? @@scroll : 0
      Game.show({x: @@scroll_horz, y: @@scroll})
      false
    else
      lines = case $gamemode
      when 'help' then build_help_menu
      when 'logs' then build_log_menu
      when 'inventory' then build_inventory
      when 'item_options' then build_inventory_options_menu
      when 'key_bindings' then build_key_bindings
      when 'equipment' then build_equipment_menu
      when 'read_more' then build_read_more_menu
      when 'equip_head' then build_inventory_by('head')
      when 'equip_torso' then build_inventory_by('torso')
      when 'equip_left_hand' then build_inventory_by('left_hand')
      when 'equip_right_hand' then build_inventory_by('right_hand')
      when 'equip_ring1' then build_inventory_by('ring1')
      when 'equip_ring2' then build_inventory_by('ring2')
      when 'equip_ring3' then build_inventory_by('ring3')
      when 'equip_ring4' then build_inventory_by('ring4')
      when 'equip_waist' then build_inventory_by('waist')
      when 'equip_leggings' then build_inventory_by('leggings')
      when 'equip_feet' then build_inventory_by('feet')
      else []
      end
      build_menu(lines)
    end
  end

  def self.build_menu(lines=0)
    $settings = Array.new(@@game_height) {""}
    max = lines.count - @@game_height + 4
    if @@select && @@selectable
      screen = @@scroll + @@game_height - 5
      @@select = @@select > screen ? @@scroll : @@select
      @@select = @@select < @@scroll ? screen : @@select
    end
    @@scroll ||= 0
    @@scroll = @@scroll > max ? max : @@scroll
    @@scroll = @@scroll > 0 ? @@scroll : 0

    above_count = @@scroll
    top = "^ #{above_count} ^"
    $settings[1] = "#{'  '*(@@game_width/2 - top.length/2)}#{top}\r| -- #{@@title}"
    (@@game_height - 4).times do |y|
      $settings[y + 2] = if @@selectable
        "   #{@@select == (@@scroll + y) ? '>' : ' '}   #{lines[@@scroll + y]}"
      else
        " #{lines[@@scroll + y]}"
      end.override_background_with(:white).override_foreground_with(:black)
    end
    below_count = lines.count - @@scroll - @@game_height + 4
    bottom = "v #{below_count > 0 ? below_count : 0} v"
    $settings[@@game_height - 2] = "#{'  '*(@@game_width/2 - bottom.length/2)}#{bottom}"
  end

  def self.build_help_menu
    @@title = "Help"
    @@selectable = true
    word_wrap(help_menu_text.split("\n"))
  end

  def self.build_log_menu
    @@title = "Logs"
    @@selectable = false
    lines = Log.all.reverse
    @@scroll ||= lines.count - @@game_height + 4
    lines
  end

  def self.build_inventory
    @@selected_item = nil
    @@title = "Inventory"
    @@selectable = true
    Player.inventory.map { |i| i.name }
  end

  def self.build_inventory_by(slot)
    @@title = 'Select item to replace with.'
    @@selectable = true
    equippable = Items.equippable
    @@selection_objects = Player.inventory.select do |i|
      if i.respond_to?(:equipment_slot)
        i.equipment_slot == slot.to_sym
      end
    end
    lines = ['None']
    @@selection_objects.each { |item| lines << item_specs(item, Player.equipped[slot.to_sym]) }
    lines
  end

  def self.build_key_bindings
    @@title = "Key Binding Menu"
    @@selectable = true
    []
  end

  def self.build_read_more_menu
    @@title = 'Read More'
    @@selectable = false
    word_wrap($previous_message.split("\n"))
  end

  def self.build_equipment_menu
    lines = []
    @@selectable = true
    @@title = 'Equipment'
    lines << ''
    %w( head torso left_hand right_hand ring1 ring2 ring3 ring4 waist leggings feet ).each do |slot|
      slot_name = humanize_slot(slot)
      space = (20 - slot_name.length).times.map{' '}.join
      lines << "#{slot_name}:#{space}#{Player.equipped[slot.to_sym] ? item_specs(Player.equipped[slot.to_sym]) : 'Empty'}"
    end
    lines
  end

  def self.build_inventory_options_menu
    lines = []
    @@title = "What would you like to do with #{@@selected_item.name}?"
    @@selectable = true
    lines << ''
    lines << 'Use/Consume'
    lines << 'Throw'
    lines << 'Drop'
    lines << ''
    lines
  end

  def self.item_specs(item, compared_to=nil)
    stats = {
      bonus_health: 'HP',
      bonus_mana: 'MANA',
      bonus_energy: 'NRG',
      bonus_strength: 'STR',
      bonus_magic_power: 'MP',
      bonus_defense: 'DEF',
      bonus_speed: 'SPD',
      bonus_accuracy: 'ACC',
      bonus_self_regen: 'REGEN'
    }
    specs = ""
    stats.each do |stat, abbreviation|
      change = compared_to ? (item.method(stat).call.to_i - compared_to.method(stat).call.to_i) : item.method(stat).call.to_i
      specs << "#{abbreviation}#{change > 0 ? '+' + change.to_s : change} " if change != 0
    end
    "#{item.name}: #{specs}"
  end

  def self.humanize_slot(slot)
    case slot
    when 'head' then "Head"
    when 'torso' then "Torso"
    when 'left_hand' then "Left Hand"
    when 'right_hand' then "Right Hand"
    when 'ring1' then "Ring 1"
    when 'ring2' then "Ring 2"
    when 'ring3' then "Ring 3"
    when 'ring4' then "Ring 4"
    when 'waist' then "Waist"
    when 'leggings' then "Leggings"
    when 'feet' then "Feet"
    end
  end

  def self.confirm_selection
    selects = %w( item_options equip_head equip_torso equip_left_hand equip_right_hand equip_ring1 equip_ring2 equip_ring3 equip_ring4 equip_waist equip_leggings equip_feet )
    menus = %w( equipment inventory )
    select_selection if selects.include?($gamemode)
    redirect_selection if menus.include?($gamemode)
  end

  def self.select_selection
    equip_item if $gamemode[0..4] == 'equip'
    do_item_option if $gamemode == 'item_options'
  end

  def self.do_item_option
    case @@select
    when 1
      @@selected_item.consume
    end
    clear_settings
    $gamemode = 'play'
  end

  def self.equip_item
    slot = $gamemode[6..$gamemode.length].to_sym
    item = @@select == 0 ? nil : @@selection_objects[@@select - 1]
    if Player.equipped[slot]
      Player.inventory << Player.equipped[slot]
      Player.equipped[slot] = nil
    end
    if item
      Player.inventory.delete(item)
      Player.equipped[slot] = item
    end
  end

  def self.redirect_selection
    new_gamemode = case $gamemode
    when 'equipment'
      mode = equip
      mode ? mode : $gamemode
    when 'inventory'
      grab_inventory ? 'item_options' : $gamemode
    else $gamemode
    end
    unless $gamemode == new_gamemode
      clear_settings
      $gamemode = new_gamemode
    end
  end

  def self.grab_inventory
    @@selected_item = Player.inventory[@@select]
  end

  def self.equip
    case @@select
    when 1 then 'equip_head'
    when 2 then 'equip_torso'
    when 3 then 'equip_left_hand'
    when 4 then 'equip_right_hand'
    when 5 then 'equip_ring1'
    when 6 then 'equip_ring2'
    when 7 then 'equip_ring3'
    when 8 then 'equip_ring4'
    when 9 then 'equip_waist'
    when 10 then 'equip_leggings'
    when 11 then 'equip_feet'
    else false
    end
  end

  def self.word_wrap(sections)
    lines = []
    sections.each do |text|
      line = ""
      text.split(' ').each do |word|
        game_length = @@selectable ? @@game_width*2 - 7 : @@game_width*2 - 2
        if line.length + word.length < game_length
          line += " #{word}"
        else
          lines << line
          line = " #{word}"
        end
      end
      lines << line
    end
    lines
  end

  def self.explain_item_text(item)
%(
Name: #{item.name.or}
Weight: #{item.weight.or}
Slot: #{humanize_slot(item.equipment_slot).or}

Range: #{item.range.or}

Bonus Stats:
 Health: #{item.bonus_health.or}
 Mana: #{item.bonus_mana.or}
 Energy: #{item.bonus_energy.or}
 Strength: #{item.bonus_strength.or}
 Magic Power: #{item.bonus_magic_power.or}
 Defense: #{item.bonus_defense.or}
 Speed: #{item.bonus_speed.or}
 Accuracy: #{item.bonus_accuracy.or}
 Regeneration: #{item.bonus_self_regen.or}
)
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
