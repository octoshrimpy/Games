class Settings
  @@game_height = (Game::VIEWPORT_HEIGHT + Game::LOGS_GUI_HEIGHT + 4)
  @@game_width = (Game::VIEWPORT_WIDTH + Game::STATS_GUI_WIDTH + 1)
  @@previous_menus = []
  @@options = {
    has_ground_item: false
  }
  @@title = ""
  @@confirmed = true
  @@item_range = 0
  @@select = nil
  @@selected_item = nil
  @@selected_select = nil
  @@stack = nil
  @@scroll = nil
  @@scroll_horz = nil
  @@selectable = nil
  @@selection_objects = []

  def self.receive(input)
    if $gamemode == 'play'
      @@previous_menus = []
    else
      @@previous_menus.pop if @@previous_menus.count > 0 && @@previous_menus.last[:mode] == $gamemode
      @@previous_menus << {mode: $gamemode, item: @@selected_item, select: @@select}
      @@previous_menus = [{mode: 'map', item: nil, select: nil}] if $gamemode == 'map'
    end
    unless $gamemode == 'play'
      tick = false
      case input
      when ("1".."9") then $gamemode == 'query_quickbar' ? (assign_quickbar(input); tick = true) : (@@select = input.to_i; tick = true if @@selectable && @@select)
      when "UP", $key_move_up then $gamemode[0..5] == 'direct' ? direct_target('up') : (scroll_up; tick = true)
      when "LEFT", $key_move_left then $gamemode[0..5] == 'direct' ? direct_target('left') : (scroll_left; tick = true)
      when "DOWN", $key_move_down then $gamemode[0..5] == 'direct' ? direct_target('down') : (scroll_down; tick = true)
      when "RIGHT", $key_move_right then $gamemode[0..5] == 'direct' ? direct_target('right') : (scroll_right; tick = true)
      when "Shift-Up", $key_move_up.capitalize then $gamemode[0..5] == 'direct' ? direct_target('up') : (scroll_up(10); tick = true)
      when "Shift-Left", $key_move_left.capitalize then $gamemode[0..5] == 'direct' ? direct_target('left') : (scroll_left(10); tick = true)
      when "Shift-Down", $key_move_down.capitalize then $gamemode[0..5] == 'direct' ? direct_target('down') : (scroll_down(10); tick = true)
      when "Shift-Right", $key_move_right.capitalize then $gamemode[0..5] == 'direct' ? direct_target('right') : (scroll_right(10); tick = true)
      when $key_move_up_right then $gamemode[0..5] == 'direct' ? direct_target('up-right') : (scroll_up_right; tick = true)
      when $key_move_up_left then $gamemode[0..5] == 'direct' ? direct_target('up-left') : (scroll_up_left; tick = true)
      when $key_move_down_right then $gamemode[0..5] == 'direct' ? direct_target('down-right') : (scroll_down_right; tick = true)
      when $key_move_down_left then $gamemode[0..5] == 'direct' ? direct_target('down-left') : (scroll_down_left; tick = true)
      when $key_move_up_right.capitalize then $gamemode[0..5] == 'direct' ? direct_target('up-right') : (scroll_up_right(10); tick = true)
      when $key_move_up_left.capitalize then $gamemode[0..5] == 'direct' ? direct_target('up-left') : (scroll_up_left(10); tick = true)
      when $key_move_down_right.capitalize then $gamemode[0..5] == 'direct' ? direct_target('down-right') : (scroll_down_right(10); tick = true)
      when $key_move_down_left.capitalize then $gamemode[0..5] == 'direct' ? direct_target('down-left') : (scroll_down_left(10); tick = true)
      when $key_move_nowhere then click_select
      when $key_pickup_items then clicked_space
      when $key_confirm then (tick = confirm_selection if @@select)
      when $key_back_menu
        menu_back
      when $key_exit_menu
        $gamemode = "play"
        clear_settings
        Game.redraw
      else
        tick = false
      end
      show if tick
    end

    case input
    when $key_open_help
      $gamemode = $gamemode.toggle('help', 'play')
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_open_logs
      $gamemode = $gamemode.toggle('logs', 'play')
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_open_keybindings
      $gamemode = $gamemode.toggle('key_bindings', 'play')
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_open_inventory
      $gamemode = $gamemode.toggle('inventory', 'play')
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_open_equipment
      $gamemode = $gamemode.toggle('equipment', 'play')
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_char_stats
      $gamemode = $gamemode.toggle('char_stats', 'play') unless $gamemode == 'map'
      $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
    when $key_read_more
      if @@scroll_horz
        $gamemode = $gamemode.toggle('read_more', 'map')
        $gamemode == 'map' ? (@@scroll = @@select; @@select = nil) : (@@select = @@scroll)
        Settings.show
      else
        case
        when $gamemode == 'read_more'
          $gamemode = 'play'
          Game.redraw
          clear_settings
        when $gamemode == 'play'
          $gamemode = 'read_more'
          Settings.show
        when $gamemode == 'inventory'
          grab_inventory
          $gamemode = 'read_about'
          Settings.show
        when $gamemode == 'equipment'
          str = equip
          slot = str[6..str.length]
          @@selected_item = Player.equipped[slot.to_sym]
          $gamemode = 'read_about'
          Settings.show
        when $gamemode[0..4] == 'equip'
          @@selected_item = @@select < 2 ? nil : @@selection_objects[@@select - 2]
          $gamemode = 'read_about'
          Settings.show
        end
      end
    when $key_inspect_surroundings
      $gamemode = $gamemode.toggle('map', 'play')
      $screen_shot = nil
      if $gamemode == 'play'
        Game.redraw
        clear_settings
      else
        @@scroll = Player.y
        @@scroll_horz = Player.x
        Game.show
      end
    when $key_select_position
      $screen_shot = nil
      if $gamemode[0..5] == 'direct'
        @@scroll_horz = Player.x
        @@scroll = Player.y
        $gamemode[0..5] = 'target'
        Game.show
      end
    when $key_confirm
      if $gamemode[0..5] == 'target'
        callback = "#{$gamemode[7..$gamemode.length]}!".to_sym
        do_in_direction([@@scroll_horz, @@scroll], method(callback))
      end
    when $key_exit then $gamemode == 'dead' ? Game.end : ''
    when "P" then Game.pause
    when "\"" then show_full_map = true
    when $key_sleep
      $gamemode = "query_sleep"
      Settings.show
      Game.input(true)
      while $gamemode == "query_sleep"
        puts "Enter how long you want to rest for."
        query = gets.chomp.downcase
        mode, amount = query.split(' ')
        if mode.to_i.to_s == mode
          puts "Sleep for #{mode} ticks. Correct? ('y' to confirm. Anything else to deny.)"
          if gets.chomp.downcase.split.join == 'y'
            $sleep_condition = "$time >= #{$time + mode.to_i}"
            Log.add 'You have begun resting.'
            $gamemode = 'sleep'
          end
        elsif %w( h m ).include?(mode)
          case mode
          when 'h'
            if amount.to_i > Player.max_health || amount == nil
              puts "Sleep until health is full. Correct? ('y' to confirm. Anything else to deny.)"
              if gets.chomp.downcase.split.join == 'y'
                $sleep_condition = "Player.health == Player.max_health"
                Log.add 'You have begun resting.'
                $gamemode = 'sleep'
              end
            elsif amount.to_i < Player.max_health
              $gamemode = 'play'
            else
              puts "Sleep until health has reached #{amount}. Correct? ('y' to confirm. Anything else to deny.)"
              if gets.chomp.downcase.split.join == 'y'
                $sleep_condition = "Player.health == #{amount.to_i}"
                Log.add 'You have begun resting.'
                $gamemode = 'sleep'
              end
            end
          when 'm'
            if amount.to_i > Player.max_mana || amount == nil
              puts "Sleep until mana is full. Correct? ('y' to confirm. Anything else to deny.)"
              if gets.chomp.downcase.split.join == 'y'
                $sleep_condition = "Player.mana == Player.max_mana"
                Log.add 'You have begun resting.'
                $gamemode = 'sleep'
              end
            elsif amount.to_i < Player.max_mana
              $gamemode = 'play'
            else
              puts "Sleep until mana has reached #{amount}. Correct? ('y' to confirm. Anything else to deny.)"
              if gets.chomp.downcase.split.join == 'y'
                $sleep_condition = "Player.mana == #{amount.to_i}"
                Log.add 'You have begun resting.'
                $gamemode = 'sleep'
              end
            end
          else
          end
          # if gets.chomp.downcase.split.join == 'y'
          #   $sleep_condition = "$time >= #{$time + mode.to_i}"
          #   $gamemode = 'sleep'
          # end
        elsif mode == 'x'
          $gamemode = 'play'
        else
          puts "Sorry. Invalid input. Please try again."
        end
      end
      Game.redraw
    end
    if show_full_map
      Game.input(true)
      system 'clear' or system 'cls'
      Dungeon.current.each_with_index { |col, x| puts col.join(" ") }
      Game.input(false)
    end
  end

  def self.assign_quickbar(input)
    Player.quickbar[input.to_i - 1] = @@selected_item.name
    clear_settings
    $skip = 1
    $gamemode = 'play'
    Game.tick
  end

  def self.direct_target(direction)
    if $gamemode[0..5] == 'direct'
      callback = "#{$gamemode[7..$gamemode.length]}!".to_sym
      do_in_direction(direction, method(callback))
    end
  end

  def self.do_in_direction(direction, callback)
    distance = @@item_range
    calc_direction = case direction
    when 'up' then [0, -distance]
    when 'down' then [0, distance]
    when 'left' then [-distance, 0]
    when 'right' then [distance, 0]
    when 'up-left' then [-distance, -distance]
    when 'up-right' then [distance, -distance]
    when 'down-left' then [-distance, distance]
    when 'down-right' then [distance, distance]
    else [Math.less_of(direction[0] - Player.x, distance), Math.less_of(direction[1] - Player.y, distance)]
    end
    if calc_direction.is_a?(Array) && calc_direction.length == 2
      $skip = 1
      callback.call(calc_direction)
      clear_settings
      $gamemode = 'play'
      Game.redraw
    end
    false
  end

  def self.ready(verb, item, distance, src=nil)
    @@item_range = distance
    @@selected_item = item
    $gamemode = "direct_#{verb}"
    $message = "Click the direction you would like to #{verb}. '#{$key_select_position}' to choose coordinate."
  end

  def self.ready_cast(spell)
    @@selected_item = spell
    $gamemode = 'direct_cast'
    $message = "Click the direction you would like to cast. '#{$key_select_position}' to choose coordinate."
  end

  def self.flash!(coord)
    coords = {x: Player.x + coord[0], y: Player.y + coord[1]}
    if Dungeon.at(coords) == "  "
      Player.coords = coords
      Game.tick
    else
      Log.add "Flash failed. There is a wall there."
    end
  end

  def self.throw!(coord)
    Player.throw_item(@@selected_item, coord)
  end

  def self.shoot!(coord)
    coords = {x: Player.x + coord[0], y: Player.y + coord[1]}
    Log.add "Shot #{@@selected_item.name}."
    Player.inventory.delete(@@selected_item)
    Projectile.new(coords, @@selected_item, Player, {speed: @@selected_item.projectile_speed})
    clear_settings
    Game.tick
  end

  def self.cast!(coord)
    coords = {x: Player.x + coord[0], y: Player.y + coord[1]}
    Log.add "Cast #{@@selected_item.name}."
    Player.mana -= @@selected_item.mana_cost
    Projectile.new(coords, @@selected_item, Player, {speed: @@selected_item.projectile_speed})
    clear_settings
    Game.tick
  end

  def self.clear_settings
    @@title = ""
    @@select, @@selected_item, @@selected_select, @@scroll, @@scroll_horz, @@selectable = nil
    @@selection_objects = @@stack = []
  end

  def self.scroll_up(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(0,-amount); end
  def self.scroll_left(amount=1); move_coord(-amount,0); end
  def self.scroll_right(amount=1); move_coord(amount,0); end
  def self.scroll_down(amount=1); (@@select && @@selectable) ? (@@select += amount) : move_coord(0,amount); end
  def self.scroll_up_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,-amount); end
  def self.scroll_up_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,-amount); end
  def self.scroll_down_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,amount); end
  def self.scroll_down_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,amount); end
  def self.move_coord(x,y); @@scroll += y if @@scroll; @@scroll_horz += x if @@scroll_horz; end

  def self.menu_back
    @@select = 1
    if @@previous_menus.length > 1
      last_menu = @@previous_menus.pop(2).first
      $gamemode = last_menu[:mode]
      @@selected_item = last_menu[:item]
      @@select = last_menu[:select]
    else
      clear_settings
      $gamemode = 'play'
    end
    Settings.show
  end

  def self.show
    if $gamemode != 'play' && generate_settings
      system 'clear' or system 'cls'
      Game.input(true)
      @@game_height.times do |y|
        @@game_width.times do |x|
          print (y == 0 || y == @@game_height-1 ? "--" : "  ").color(:black, :white)
        end
        puts (y == 0 || y == @@game_height-1 ? "+\r+#{$settings[y]}" : "|\r|#{$settings[y]}").color(:black, :white)
      end
      puts $gamemode
      puts @@select
      Game.input(false)
    else
      Game.redraw unless $gamemode == 'map' || $gamemode[0..5] == 'target'
    end
  end

  def self.generate_settings
    case
    when $gamemode == 'map', $gamemode[0..5] == 'target'
      max = $width
      @@scroll_horz = @@scroll_horz > max ? max : @@scroll_horz
      @@scroll_horz = @@scroll_horz > 0 ? @@scroll_horz : 0
      max = $height - 1
      @@scroll = @@scroll > max ? max : @@scroll
      @@scroll = @@scroll > 0 ? @@scroll : 0
      Game.show({x: @@scroll_horz, y: @@scroll})
      false
    when $gamemode == 'query_sleep'
      build_menu( build_sleep_prompt_menu )
    else
      lines = case $gamemode
      when 'help' then build_help_menu
      when 'dead' then build_dead_menu
      when 'logs' then build_log_menu
      when 'inventory' then build_inventory
      when 'item_options' then build_inventory_options_menu
      when 'key_bindings' then build_key_bindings
      when 'equipment' then build_equipment_menu
      when 'read_more' then build_read_more_menu
      when 'read_spellbook' then build_spellbook_menu
      when 'char_stats' then build_char_stats_menu
      when 'read_about' then build_read_about_menu
      when 'equip_head' then build_inventory_by('head')
      when 'equip_torso' then build_inventory_by('torso')
      when 'equip_back' then build_inventory_by('back')
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

  def self.build_menu(lines=[])
    $settings = Array.new(@@game_height) {""}
    max = lines.count - @@game_height + 4
    @@scroll ||= 1
    if @@select && @@selectable
      screen = @@scroll + @@game_height - 5
      @@select = @@select > screen ? @@scroll : @@select
      @@select = @@select < @@scroll ? screen : @@select
    end
    @@select ||= 1 if @@selectable
    @@scroll ||= 0
    @@scroll = @@scroll > max ? max : @@scroll
    @@scroll = @@scroll > 0 ? @@scroll : 0

    above_count = @@scroll
    top = "^ #{above_count} ^"
    $settings[1] = "#{'  '*(@@game_width/2 - top.length/2)}#{top}\r| -- #{@@title}"
    (@@game_height - 4).times do |y|
      $settings[y + 2] = if @@selectable
        quick_num = (y > 0 && y < 10) ? "#{y}-" : "  "
        "  #{@@select == (@@scroll + y) ? '>' : (@@selected_select == (@@scroll + y) && !@@options[:has_ground_item] ? '>'.color(:blue, :white) : ' ')}   #{lines[@@scroll + y]}\r|#{quick_num}"
      else
        " #{lines[@@scroll + y]}"
      end.override_background_with(:white).override_foreground_with(:black)
    end
    below_count = lines.count - @@scroll - @@game_height + 4
    bottom = "v #{below_count > 0 ? below_count : 0} v"
    $settings[@@game_height - 2] = "#{'  '*(@@game_width/2 - bottom.length/2)}#{bottom}"
  end

  def self.build_sleep_prompt_menu
    @@title = "How long would you like to rest for?"
    @@selectable = false
    word_wrap( sleep_message )
  end

  def self.build_help_menu
    @@title = "Help"
    @@selectable = false
    word_wrap( help_menu_text )
  end

  def self.build_dead_menu
    @@title = "You have Died!"
    @@selectable = false
    word_wrap( dead_menu_text )
  end

  def self.build_char_stats_menu
    @@title = 'Character Stats'
    @@selectable = false
    char_stats_text
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
    player_stacks = Player.inventory_by_stacks
    @@title = "Inventory #{player_stacks.count} / #{Player.inventory_size}    Weight: #{Player.inventory_weight}lbs"
    @@selectable = true
    ['Sort Inventory'] + player_stacks.map do |name, items|
      count = items.count < 10 ? " #{items.count}" : items.count
      title = "#{count}x   #{items.first.icon} #{name}"

      weight_numeric = items.inject(0) { |sum, item| sum + item.weight}.round(3)
      identifier = weight_numeric == 1 ? 'lb' : 'lbs'
      weight = "#{weight_numeric} #{identifier}"

      line_width = @@game_width*2 - 20
      spacer = (line_width - title.length).times.map {' '}.join

      "#{title} #{spacer} #{weight[0..9]}"
    end
  end

  def self.build_inventory_by(slot)
    @@title = 'Select item to replace with.'
    @@selectable = true
    equippable = Item.equippable
    @@selection_objects = Player.equippable_inventory(slot)
    lines = ['', 'None']
    @@selection_objects.each { |item| lines << "#{item.name}: #{item_specs(item, Player.equipped[slot.to_sym])}" }
    lines
  end

  def self.build_key_bindings
    @@title = "Key Binding Menu"
    @@selectable = true
    []
  end

  def self.build_read_more_menu
    @@title = 'Read More'
    @@selectable = Player.currently_standing_on.count > 0
    coords = @@scroll && @@scroll_horz ? {x: @@scroll_horz, y: @@scroll} : Player.coords
    word_wrap(Game.describe(Dungeon.at(coords), coords))
  end

  def self.build_spellbook_menu
    @@title = "Reading #{@@selected_item.name}"
    @@selectable = true
    lines = ["Sort Spells - Press '#{$key_pickup_items}' to assign to quickbar."]
    @@selected_item.castable_spells.each do |spell|
      lines << spell
    end
    lines
  end

  def self.build_read_about_menu
    return no_item_text unless @@selected_item
    @@title = "About #{@@selected_item.name}"
    @@selectable = false
    explain_item_text(@@selected_item)
  end

  def self.build_equipment_menu
    lines = ['']
    @@selectable = true
    @@title = "Equipment #{15.times.map{' '}.join}Weight: #{Player.equipped_weight}"
    %w( head torso back left_hand right_hand ring1 ring2 ring3 ring4 waist leggings feet ).each do |slot|
      slot_name = humanize_slot(slot)
      space = (20 - slot_name.length).times.map{' '}.join
      lines << "#{slot_name}:#{space}#{Player.equipped[slot.to_sym] ? "#{Player.equipped[slot.to_sym].name}: #{item_specs(Player.equipped[slot.to_sym])}" : 'Empty'}"
    end
    lines
  end

  def self.build_inventory_options_menu
    lines = ['']
    @@title = "What would you like to do with #{@@selected_item.name}?"
    @@selectable = true
    verb = case
    when @@selected_item.class == Consumable then 'Consume'
    when @@selected_item.class == SpellBook then 'Read'
    when @@selected_item.respond_to?(:equipment_slot) && @@selected_item.equipment_slot then 'Equip'
    else 'Use'
    end
    lines << verb
    lines << 'Throw'
    lines << 'Drop'
    lines << 'Drop Stack'
    if @@selected_item.equipment_slot
      slot = @@selected_item.equipment_slot
      specs = Player.equipped[slot] ? item_specs(@@selected_item, Player.equipped[slot]) : item_specs(@@selected_item)
      lines << "Equip - #{humanize_slot(@@selected_item.equipment_slot)}: #{specs}"
    else
      lines << "Assign to Quick Bar"
    end
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
      bonus_self_regen: 'REGEN',
      weight: 'WEIGHT'
    }
    specs = ""
    stats.each do |stat, abbreviation|
      change = compared_to ? (item.method(stat).call.to_i - compared_to.method(stat).call.to_i) : item.method(stat).call.to_i
      specs << "#{abbreviation}#{change > 0 ? '+' + change.to_s : change} " if change != 0
    end
    specs
  end

  def self.humanize_slot(slot)
    case slot.to_s
    when 'head' then "Head"
    when 'torso' then "Torso"
    when 'back' then "Back"
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
    selects = %w( item_options read_spellbook equip_head equip_torso equip_back equip_left_hand equip_right_hand equip_ring1 equip_ring2 equip_ring3 equip_ring4 equip_waist equip_leggings equip_feet )
    menus = %w( equipment inventory )
    select_selection if selects.include?($gamemode)
    redirect_selection if menus.include?($gamemode)
  end

  def self.select_selection
    equip_item if $gamemode[0..4] == 'equip'
    do_item_option if $gamemode == 'item_options'
    cast_selected_spell if $gamemode == 'read_spellbook'
  end

  def self.cast_selected_spell
    if @@confirmed
    if @@select == 0
      @@selected_item.sort_spells!
    else
      spell_name = @@selected_item.castable_spells[@@select - 1]
      @@selected_item.cast_spell(spell_name)
    end
    else
      @@confirmed = true
    end
  end

  def self.read_book(book)
    clear_settings
    $gamemode = 'read_spellbook'
    @@selected_item = book
  end

  def self.do_item_option
    tick = true
    clear = true
    play = true
    show_settings = false

    case @@select - 1
    when 0 # Use/consume/read/equip
      unless @@selected_item.use!
        @@confirmed = false
        tick = false; play = false; clear = false
      end
    when 1 # Throw
      if Player.energy <= 0
        $message = "I don't have the energy to do that."
        Log.add "I don't have the energy to do that."
      else
        $message = "Click the direction you would like to throw. '#{$key_select_position}' to choose coordinate."
        $gamemode = 'direct_throw'
        @@selectable = false
        clear = false; play = false
      end
    when 2 # Drop
      Player.drop(@@selected_item)
    when 3 # Drop all
      Player.drop_many(@@stack)
    when 4
      if @@selected_item.equipment_slot
        Player.equip(@@selected_item)
      else
        $message = "Enter the number to assign #{@@selected_item.name} to."
        $gamemode = 'query_quickbar'
        tick = false; play = false; clear = false
        Game.redraw
      end
    end
    $gamemode = 'play' if play
    clear_settings if clear
    Game.tick if tick
    Settings.show if show_settings
    true
  end

  def self.equip_item
    slot = $gamemode[6..$gamemode.length].to_sym
    item = @@select < 2 ? nil : @@selection_objects[@@select - 2]
    Player.equip(item, slot)
    show
  end

  def self.columnize(padding, cols)
    cols.map do |col|
      "#{col}#{Array.new(padding - col.length).join(' ')}"
    end.join
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
      item = @@selected_item
      stack = @@stack
      clear_settings
      @@selected_item = item
      @@stack = stack
      $gamemode = new_gamemode
    end
  end

  def self.grab_inventory
    if @@select == 0
      Player.sort_inventory!
      Settings.show
    end
    stacks = Player.inventory_by_stacks.to_a[@@select - 1]
    if stacks && @@select - 1 >= 0
      @@stack = stacks[1]
      @@selected_item = @@stack.first
    end
  end

  def self.equip
    case @@select - 1
    when 0 then 'equip_head'
    when 1 then 'equip_torso'
    when 2 then 'equip_back'
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
    sections.split("\n").each do |text|
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

  def self.swap_items
    if $gamemode == 'read_spellbook'
      @@selected_item.swap_spells(@@selected_select - 1, @@select - 1)
    else
      Player.swap_inventory(@@selected_select - 1, @@select - 1, @@options[:has_ground_item])
      @@options[:has_ground_item] = false
    end
    @@selected_select = nil
    Settings.show
  end

  def self.clicked_space
    if $gamemode == 'read_spellbook'
      item_name = @@selected_item.castable_spells[@@select - 1]
      item = Item[item_name] if item_name
      if @@select >= 1 && item
        @@selected_item = item
        $message = "Enter the number to assign #{@@selected_item.name} to."
        $gamemode = 'query_quickbar'
        Game.redraw
      end
    end
  end

  def self.click_select
    if $gamemode == 'inventory' || $gamemode == 'read_spellbook'
      @@selected_select ? swap_items : @@selected_select = @@select
    elsif $gamemode == 'read_more' && @@select
      if Player.inventory_by_stacks.count < Player.inventory_size
        stacks = $stack.group_by { |item| item.name }
        selected_items = stacks.to_a[@@select - 2].last
        items_to_pickup = selected_items.first(selected_items.first.stack_size)
        Player.pickup_items(items_to_pickup)
      else
        @@options[:has_ground_item] = true
        @@selected_select = @@select
        $gamemode = 'inventory'
      end
      Settings.show
    else
      clear_settings
      $gamemode = 'play'
    end
    false
  end

  def self.sleep_message
%(
Type a number, and then hit enter to sleep for that many moves.

Or- enter a letter to sleep until that specific attribute has reached max.
Additionally, you can follow that key with a number to sleep until that number reaches the specified amount.
Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep.
You will automatically awaken early if there is danger nearby.

h - Health
m - Mana

Type 'x' then hit enter to cancel.
)
  end

  def self.no_item_text
    @@title = "No item selected"
    @@selectable = false
    word_wrap("\nThis menu will normally describe an item, including the name, weight, icon it uses, where it can be equipped, range, bonus stats, how to use it, and any other extra information.")
  end

  def self.explain_item_text(item)
    padding = 20
    lines = ['']
    lines << "Name: #{item.name.or('N/A')}"
    lines << "Icon: #{item.icon.or('N/A')}"
    lines << "Weight: #{item.weight.or('N/A')}"
    lines << "Slot: #{humanize_slot(item.equipment_slot).or('N/A')}"
    lines << ""
    lines += ["Range: #{item.range.or('N/A')}", ""] if item.respond_to?(:range)
    lines << "Bonus Stats:"
    lines << "   #{columnize(padding, ["Health:", "#{item.bonus_health.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Mana:", "#{item.bonus_mana.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Energy:", "#{item.bonus_energy.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Strength:", "#{item.bonus_strength.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Magic Power:", "#{item.bonus_magic_power.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Defense:", "#{item.bonus_defense.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Speed:", "#{item.bonus_speed.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Accuracy:", "#{item.bonus_accuracy.or('N/A')}"])}"
    lines << "   #{columnize(padding, ["Regeneration:", "#{item.bonus_self_regen.or('N/A')}"])}"
    lines << ""
    lines << " Description:"
    lines += word_wrap(item.description || "N/A")
    lines
  end

  def self.help_menu_text
%(
HELP - exit by pressing ESCAPE or the '#{$key_open_help}' key once again.

View and edit keys by hitting the '#{$key_open_keybindings}' key.

-------------------------------------------------------------------------------- #{'Movement'.color(:red)}
Each frame takes place on every interval of the speed of the Player(you). Monster may move faster or slower than you. Speed is calculated by a single number, 1-100. 1 being the slowest, 100 being the fastest. If the player moves at a speed of 10 and a monster moves at a speed of 15, the monsters position will only update every time the player moves. Every other turn the monster will appear to move 2 spaces because of the extra speed.

-------------------------------------------------------------------------------- #{'Targeting'.color(:red)}
When using a spell or ability, or throwing/shooting a projectile, you can quick cast by hitting the corresponding directional key. By hitting '#{$key_select_position}', you are able to scroll around using normal movement keys to select a specific place to target. If the range is less than the max range of the projectile, it will stop on the selected position. If the target is beyond the range of the projectile, it will stop at its' max range.
)
  end

  def self.char_stats_text
    padding = 40
    lines = ['']
    lines << "   #{columnize(padding, ['Health:', "#{Player.max_health}"])}"
    lines << "   #{columnize(padding, ['Mana:', "#{Player.max_mana}"])}"
    lines << "   #{columnize(padding, ['Energy:', "#{Player.max_energy}"])}"
    lines << "   #{columnize(padding, ['Health Regeneration:', "#{Player.self_regen}"])}"
    lines << "   #{columnize(padding, ['Strength:', "#{Player.strength}"])}"
    lines << "   #{columnize(padding, ['Magic Power:', "#{Player.magic_power}"])}"
    lines << "   #{columnize(padding, ['Defense:', "#{Player.defense}"])}"
    lines << "   #{columnize(padding, ['Accuracy:', "#{Player.accuracy}"])}"
    lines << "   #{columnize(padding, ['Speed:', "#{Player.speed}"])}"
  end

  def self.dead_menu_text
%(
You have DIED! Hit '#{$key_exit}' to exit the game.
)
  end
end
