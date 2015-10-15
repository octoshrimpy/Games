class Settings
  class_accessible :item_range
  @@game_height = (Game::VIEWPORT_HEIGHT + Game::LOGS_GUI_HEIGHT + 4)
  @@game_width = (Game::VIEWPORT_WIDTH + Game::STATS_GUI_WIDTH + 1)
  @@previous_menus = []
  @@options = {
    has_ground_item: false
  }
  @@title = ""
  @@skip = 0
  @@confirmed = true
  @@item_range = 0
  @@selected_key = nil
  @@select = nil
  @@selected_item = nil
  @@selected_select = nil
  @@stack = nil
  @@scroll = nil
  @@scroll_horz = nil
  @@selectable = nil
  @@selection_objects = []

  class << self

    def receive(input)
      $all_inputs << input
      return false if @@selected_key && override_keypress(input)
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
        when "UP", $key_mapping[:move_up] then $gamemode[0..5] == 'direct' ? direct_target('up') : (scroll_up; tick = true)
        when "LEFT", $key_mapping[:move_left] then $gamemode[0..5] == 'direct' ? direct_target('left') : (scroll_left; tick = true)
        when "DOWN", $key_mapping[:move_down] then $gamemode[0..5] == 'direct' ? direct_target('down') : (scroll_down; tick = true)
        when "RIGHT", $key_mapping[:move_right] then $gamemode[0..5] == 'direct' ? direct_target('right') : (scroll_right; tick = true)
        when "Shift-Up", $key_mapping[:move_up].capitalize then $gamemode[0..5] == 'direct' ? direct_target('up') : (scroll_up(10); tick = true)
        when "Shift-Left", $key_mapping[:move_left].capitalize then $gamemode[0..5] == 'direct' ? direct_target('left') : (scroll_left(10); tick = true)
        when "Shift-Down", $key_mapping[:move_down].capitalize then $gamemode[0..5] == 'direct' ? direct_target('down') : (scroll_down(10); tick = true)
        when "Shift-Right", $key_mapping[:move_right].capitalize then $gamemode[0..5] == 'direct' ? direct_target('right') : (scroll_right(10); tick = true)
        when $key_mapping[:move_up_right] then $gamemode[0..5] == 'direct' ? direct_target('up-right') : (scroll_up_right; tick = true)
        when $key_mapping[:move_up_left] then $gamemode[0..5] == 'direct' ? direct_target('up-left') : (scroll_up_left; tick = true)
        when $key_mapping[:move_down_right] then $gamemode[0..5] == 'direct' ? direct_target('down-right') : (scroll_down_right; tick = true)
        when $key_mapping[:move_down_left] then $gamemode[0..5] == 'direct' ? direct_target('down-left') : (scroll_down_left; tick = true)
        when $key_mapping[:move_up_right].capitalize then $gamemode[0..5] == 'direct' ? direct_target('up-right') : (scroll_up_right(10); tick = true)
        when $key_mapping[:move_up_left].capitalize then $gamemode[0..5] == 'direct' ? direct_target('up-left') : (scroll_up_left(10); tick = true)
        when $key_mapping[:move_down_right].capitalize then $gamemode[0..5] == 'direct' ? direct_target('down-right') : (scroll_down_right(10); tick = true)
        when $key_mapping[:move_down_left].capitalize then $gamemode[0..5] == 'direct' ? direct_target('down-left') : (scroll_down_left(10); tick = true)
        when $key_mapping[:move_nowhere] then click_select
        when $key_mapping[:pickup_items] then clicked_space
        when $key_mapping[:confirm] then (tick = confirm_selection if @@select)
        when $key_mapping[:back_menu]
          menu_back
        when $key_mapping[:exit_menu]
          $gamemode = "play"
          clear_settings
          Game.redraw
        else
          tick = false
        end
        show if tick
      end

      case input
      when $key_mapping[:open_help]
        $gamemode = $gamemode.toggle('help', 'play')
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:open_logs]
        $gamemode = $gamemode.toggle('logs', 'play')
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:open_keybindings]
        $gamemode = $gamemode.toggle('key_bindings', 'play')
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:open_inventory]
        $gamemode = $gamemode.toggle('inventory', 'play')
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:open_equipment]
        $gamemode = $gamemode.toggle('equipment', 'play')
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:char_stats]
        $gamemode = $gamemode.toggle('char_stats', 'play') unless $gamemode == 'map'
        $gamemode == 'play' ? (Game.redraw; clear_settings) : Settings.show
      when $key_mapping[:read_more]
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
          when $gamemode == 'read_spellbook'
            @@selected_item = @@select < 1 ? nil : @@selection_objects[@@select - 1]
            $gamemode = 'read_about'
            Settings.show
          end
        end
      when $key_mapping[:inspect_surroundings]
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
      when $key_mapping[:select_position]
        $screen_shot = nil
        if $gamemode[0..5] == 'direct'
          @@scroll_horz = Player.x
          @@scroll = Player.y
          $gamemode[0..5] = 'target'
          Game.show
        end
      when $key_mapping[:confirm]
        if $gamemode[0..5] == 'target' && @@skip == 0
          callback = "#{$gamemode[7..$gamemode.length]}!".to_sym
          do_in_direction([@@scroll_horz, @@scroll], method(callback))
        end
      when $key_mapping[:exit] then $gamemode == 'dead' ? Game.end : ''
      when "P" then Game.pause
      when "\"" then show_full_map = true
      when $key_mapping[:sleep]
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
              $auto_pilot_condition = "$time >= #{$time + mode.to_i}"
              Log.add 'You have begun resting.'
              $gamemode = 'sleep'
              Player.sleeping = true
            end
          elsif %w( h m ).include?(mode)
            case mode
            when 'h'
              if amount.to_i > Player.max_health || amount == nil
                puts "Sleep until health is full. Correct? ('y' to confirm. Anything else to deny.)"
                if gets.chomp.downcase.split.join == 'y'
                  $auto_pilot_condition = "Player.health == Player.max_health"
                  Log.add 'You have begun resting.'
                  $gamemode = 'sleep'
                  Player.sleeping = true
                end
              elsif amount.to_i < Player.max_health
                $gamemode = 'play'
              else
                puts "Sleep until health has reached #{amount}. Correct? ('y' to confirm. Anything else to deny.)"
                if gets.chomp.downcase.split.join == 'y'
                  $auto_pilot_condition = "Player.health == #{amount.to_i}"
                  Log.add 'You have begun resting.'
                  $gamemode = 'sleep'
                  Player.sleeping = true
                end
              end
            when 'm'
              if amount.to_i > Player.max_mana || amount == nil
                puts "Sleep until mana is full. Correct? ('y' to confirm. Anything else to deny.)"
                if gets.chomp.downcase.split.join == 'y'
                  $auto_pilot_condition = "Player.mana == Player.max_mana"
                  Log.add 'You have begun resting.'
                  $gamemode = 'sleep'
                  Player.sleeping = true
                end
              elsif amount.to_i < Player.max_mana
                $gamemode = 'play'
              else
                puts "Sleep until mana has reached #{amount}. Correct? ('y' to confirm. Anything else to deny.)"
                if gets.chomp.downcase.split.join == 'y'
                  $auto_pilot_condition = "Player.mana == #{amount.to_i}"
                  Log.add 'You have begun resting.'
                  $gamemode = 'sleep'
                  Player.sleeping = true
                end
              end
            else
            end
            # if gets.chomp.downcase.split.join == 'y'
            #   $auto_pilot_condition = "$time >= #{$time + mode.to_i}"
            #   $gamemode = 'sleep'
            #   Player.sleeping = true
            # end
          elsif mode == 'x'
            $gamemode = 'play'
          else
            puts "Sorry. Invalid input. Please try again."
          end
        end
        Game.redraw
      end
      @@skip -= 1 if @@skip > 0
      if show_full_map
        Game.input(true)
        system 'clear' or system 'cls'
        Dungeon.current.each_with_index { |col, x| puts col.join(" ") }
        Game.input(false)
      end
    end

    def assign_quickbar(input)
      Player.quickbar[input.to_i - 1] = @@selected_item.name
      clear_settings
      $skip = 1
      $gamemode = 'play'
      Game.tick
    end

    def direct_target(direction)
      if $gamemode[0..5] == 'direct'
        callback = "#{$gamemode[7..$gamemode.length]}!".to_sym
        do_in_direction(direction, method(callback))
      end
    end

    def do_in_direction(direction, callback)
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

    def ready(verb, item, distance, src=nil)
      @@item_range = distance
      @@selected_item = item
      $gamemode = "direct_#{verb}"
      $message = "Click the direction you would like to #{verb}. '#{$key_mapping[:select_position]}' to choose coordinate."
    end

    def ready_cast(spell, spell_range)
      if spell_range == 0
        eval(spell.non_projectile_script)
        clear_settings
        $gamemode = 'play'
        Game.redraw
      else
        $screen_shot = nil
        @@selected_item = spell
        @@selectable = false
        @@item_range = spell_range
        @@skip = 2
        $message = "Select the position you would like to cast to."
        $gamemode = 'target_cast'
        @@scroll_horz = Player.x
        @@scroll = Player.y
        Game.show
      end
    end

    def flash!(coord)
      coords = {x: Player.x + coord[0], y: Player.y + coord[1], depth: Player.depth}
      last_valid = nil

      flash_to = Visible.line_until_collision(Player.coords.filter(:x, :y), coords.filter(:x, :y))
      if flash_to
        Player.coords = flash_to
        Game.tick
      else
        Log.add "Flash failed. Nowhere to land."
      end
    end

    def throw!(coord)
      Player.throw_item(@@selected_item, coord)
    end

    def shoot!(coord)
      coords = {x: Player.x + coord[0], y: Player.y + coord[1], depth: Player.depth}
      Log.add "Shot #{@@selected_item.name}."
      Player.inventory.delete(@@selected_item)
      Projectile.new(coords, @@selected_item, Player, 'physical', {speed: @@selected_item.projectile_speed})
      clear_settings
      Game.tick
    end

    def cast!(coord)
      coords = {x: Player.x + coord[0], y: Player.y + coord[1], depth: Player.depth}
      Log.add "Cast #{@@selected_item.name}."
      Player.mana -= @@selected_item.mana_cost
      if @@selected_item.is_projectile
        Projectile.new(coords, @@selected_item, Player, @@selected_item.type, {speed: @@selected_item.projectile_speed})
      else
        eval(@@selected_item.non_projectile_script)
      end
      clear_settings
      Game.tick
    end

    def clear_settings
      @@title = ""
      @@item_range = 0
      @@select, @@selected_item, @@selected_select, @@scroll, @@scroll_horz, @@selectable = nil
      @@selection_objects = @@stack = []
    end

    def scroll_up(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(0,-amount); end
    def scroll_left(amount=1); move_coord(-amount,0); end
    def scroll_right(amount=1); move_coord(amount,0); end
    def scroll_down(amount=1); (@@select && @@selectable) ? (@@select += amount) : move_coord(0,amount); end
    def scroll_up_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,-amount); end
    def scroll_up_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,-amount); end
    def scroll_down_right(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(amount,amount); end
    def scroll_down_left(amount=1); (@@select && @@selectable) ? (@@select -= amount) : move_coord(-amount,amount); end
    def move_coord(x,y); @@scroll += y if @@scroll; @@scroll_horz += x if @@scroll_horz; end

    def menu_back
      @@select = 1
      @@selected_select = nil
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

    def show
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

    def generate_settings
      case
      when $gamemode == 'map', $gamemode[0..5] == 'target'
        max = $width
        @@scroll_horz = @@scroll_horz > max ? max : @@scroll_horz
        @@scroll_horz = @@scroll_horz > 0 ? @@scroll_horz : 0
        max = $height - 1
        @@scroll = @@scroll > max ? max : @@scroll
        @@scroll = @@scroll < 0 ? 0 : @@scroll
        Game.show({x: @@scroll_horz, y: @@scroll, depth: Player.depth, range: @@item_range})
        false
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
        when 'query_sleep' then build_sleep_prompt_menu
        when 'equip_head' then build_inventory_by('head')
        when 'equip_torso' then build_inventory_by('torso')
        when 'equip_back' then build_inventory_by('back')
        when 'equip_off_hand' then build_inventory_by('off_hand')
        when 'equip_main_hand' then build_inventory_by('main_hand')
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

    def build_menu(lines=[])
      $settings = Array.new(@@game_height) {""}
      max = lines.count - @@game_height + 4
      @@scroll ||= 0
      if @@select && @@selectable
        @@select = @@select > lines.count - 1 ? 0 : @@select
        @@select = @@select < 0 ? lines.count - 1 : @@select
        select_offset = @@select - (@@game_height - 5)
        @@scroll = select_offset if select_offset > @@scroll
        @@scroll = @@select - 1 if @@select - 1 < @@scroll
      end
      @@select ||= 1 if @@selectable
      @@scroll = @@scroll > max ? max : @@scroll
      @@scroll = @@scroll < 0 ? 0 : @@scroll

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

    def build_sleep_prompt_menu
      @@title = "How long would you like to rest for?"
      @@selectable = false
      word_wrap( sleep_message )
    end

    def build_help_menu
      @@title = "Help"
      @@selectable = false
      word_wrap( help_menu_text )
    end

    def build_dead_menu
      @@title = "You have Died!"
      @@selectable = false
      word_wrap( dead_menu_text )
    end

    def build_char_stats_menu
      @@title = 'Character Stats'
      @@selectable = false
      char_stats_text
    end

    def build_log_menu
      @@title = "Logs"
      @@selectable = false
      lines = Log.all.reverse
      @@scroll ||= lines.count - @@game_height + 4
      lines
    end

    def build_inventory
      @@selected_item = nil
      player_stacks = Player.inventory_by_stacks
      @@title = "Inventory #{player_stacks.count} / #{Player.inventory_size}    Weight: #{Player.inventory_weight}lbs"
      @@selectable = true
      [' * Sort Inventory'] + player_stacks.map do |name, items|
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

    def build_inventory_by(slot)
      @@title = 'Select item to replace with.'
      @@selectable = true
      equippable = Item.equippable
      @@selection_objects = Player.equippable_inventory(slot)
      lines = ['', 'None']
      @@selection_objects.each { |item| lines << "#{item.name}: #{item_specs(item, Player.equipped[slot.to_sym])}" }
      lines
    end

    def build_key_bindings
      @@title = "Key Binding Menu"
      @@selectable = true
      lines = [' * Restore Defaults']
      $key_mapping.each do |key, value|
        lines << "#{key.to_s.split('_').map {|word|word.capitalize}.join(' ')}: #{value}"
      end
      lines
    end

    def build_read_more_menu
      @@title = 'Read More'
      @@selectable = Player.currently_standing_on.count > 0
      coords = @@scroll && @@scroll_horz ? {x: @@scroll_horz, y: @@scroll, depth: Player.depth} : Player.coords
      word_wrap(Game.describe(Dungeon.at(coords), coords))
    end

    def build_spellbook_menu
      @@title = "Viewing #{@@selected_item.name}"
      @@selectable = true
      lines = ["Sort Spells - Press '#{$key_mapping[:pickup_items]}' to assign to quickbar."]
      @@selection_objects = []
      @@selected_item.castable_spells.each do |spell_name|
        spell = Item[spell_name]
        @@selection_objects << spell
        line = "#{spell_name}: Type: #{spell.type.capitalize}"
        line << " | Mana Cost: #{spell.mana_cost}" if spell.mana_cost && spell.mana_cost > 0
        line << " | Range: #{spell.range}" if spell.range && spell.range > 0
        lines << line
      end
      lines
    end

    def build_read_about_menu
      return no_item_text unless @@selected_item
      @@title = "About #{@@selected_item.name}"
      @@selectable = false
      explain_item_text(@@selected_item)
    end

    def build_equipment_menu
      lines = ['']
      @@selectable = true
      @@title = "Equipment #{15.times.map{' '}.join}Weight: #{Player.equipped_weight}"
      %w( head torso back off_hand main_hand ring1 ring2 ring3 ring4 waist leggings feet ).each do |slot|
        slot_name = humanize_slot(slot)
        space = (20 - slot_name.length).times.map{' '}.join
        lines << "#{slot_name}:#{space}#{Player.equipped[slot.to_sym] ? "#{Player.equipped[slot.to_sym].name}: #{item_specs(Player.equipped[slot.to_sym])}" : 'Empty'}"
      end
      lines
    end

    def build_inventory_options_menu
      lines = ['']
      @@title = "What would you like to do with #{@@selected_item.name}?"
      @@selectable = true
      verb = case
      when @@selected_item.class == Consumable || @@selected_item.class == SpellBook then @@selected_item.usage_verb.capitalize
      when @@selected_item.respond_to?(:equipment_slot) && @@selected_item.equipment_slot
        slot = @@selected_item.equipment_slot
        specs = Player.equipped[slot] ? item_specs(@@selected_item, Player.equipped[slot]) : item_specs(@@selected_item)
        "Equip - #{humanize_slot(@@selected_item.equipment_slot)}: #{specs}"
      else 'Use'
      end
      lines << verb
      lines << 'Throw'
      lines << 'Drop'
      lines << 'Drop Stack'
      lines << "Assign to Quick Bar"
      lines << ''
      lines
    end

    def item_specs(item, compared_to=nil)
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
      if item.is_a?(LightSource)
        specs << "Light: #{item.range} Ticks: #{item.duration}"
      end
      specs
    end

    def humanize_slot(slot)
      case slot.to_s
      when 'head' then "Head"
      when 'torso' then "Torso"
      when 'back' then "Back"
      when 'off_hand' then "Off Hand"
      when 'main_hand' then "Main Hand"
      when 'ring1' then "Ring 1"
      when 'ring2' then "Ring 2"
      when 'ring3' then "Ring 3"
      when 'ring4' then "Ring 4"
      when 'waist' then "Waist"
      when 'leggings' then "Leggings"
      when 'feet' then "Feet"
      end
    end

    def confirm_selection
      selects = %w( item_options read_spellbook equip_head equip_torso equip_back equip_off_hand equip_main_hand equip_ring1 equip_ring2 equip_ring3 equip_ring4 equip_waist equip_leggings equip_feet )
      menus = %w( equipment inventory )
      select_selection if selects.include?($gamemode)
      redirect_selection if menus.include?($gamemode)
    end

    def select_selection
      equip_item if $gamemode[0..4] == 'equip'
      do_item_option if $gamemode == 'item_options'
      cast_selected_spell if $gamemode == 'read_spellbook'
    end

    def cast_selected_spell
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

    def read_book(book)
      clear_settings
      $gamemode = 'read_spellbook'
      @@selected_item = book
    end

    def do_item_option
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
          $message = "Click the direction you would like to throw. '#{$key_mapping[:select_position]}' to choose coordinate."
          $gamemode = 'direct_throw'
          @@selectable = false
          clear = false; play = false
        end
      when 2 # Drop
        Player.drop(@@selected_item)
      when 3 # Drop all
        Player.drop_many(@@stack)
      when 4
        $message = "Enter the number to assign #{@@selected_item.name} to."
        $gamemode = 'query_quickbar'
        tick = false; play = false; clear = false
        Game.redraw
      end
      $gamemode = 'play' if play
      clear_settings if clear
      Game.tick if tick
      Settings.show if show_settings
      true
    end

    def equip_item
      slot = $gamemode[6..$gamemode.length].to_sym
      item = @@select < 2 ? nil : @@selection_objects[@@select - 2]
      Player.equip(item, slot)
      show
    end

    def columnize(padding, *cols)
      cols.flatten.map do |col|
        col.ljust(padding)
      end.join
    end

    def redirect_selection
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

    def grab_inventory
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

    def equip
      case @@select - 1
      when 0 then 'equip_head'
      when 1 then 'equip_torso'
      when 2 then 'equip_back'
      when 3 then 'equip_off_hand'
      when 4 then 'equip_main_hand'
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

    def word_wrap(sections)
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

    def swap_items
      if $gamemode == 'read_spellbook'
        @@selected_item.swap_spells(@@selected_select - 1, @@select - 1)
      else
        Player.swap_inventory(@@selected_select - 1, @@select - 1, @@options[:has_ground_item])
        @@options[:has_ground_item] = false
      end
      @@selected_select = nil
      Settings.show
    end

    def clicked_space
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

    def override_keypress(input)
      if %w( UP DOWN LEFT RIGHT ).include?(input)
        $key_mapping[@@selected_key.first] = @@selected_key.last
      else
        $key_mapping.select { |key, value| value == input }.each { |key, dup_value| $key_mapping[key] = @@selected_key.last }
        $key_mapping[@@selected_key.first] = input
      end
      @@selected_key = nil
      Settings.show
      true
    end

    def click_select
      if $gamemode == 'inventory' || $gamemode == 'read_spellbook'
        @@selected_select ? swap_items : @@selected_select = @@select
      elsif $gamemode == 'read_more' && @@select
        stacks = $stack.group_by { |item| item.name }
        selected_items = stacks.to_a[@@select - 2] && @@select >= 2 ? stacks.to_a[@@select - 2].last : nil
        if selected_items
          if Player.inventory_by_stacks.count < Player.inventory_size
            items_to_pickup = selected_items.first(selected_items.first.stack_size)
            Player.pickup_items(items_to_pickup)
          else
            @@options[:has_ground_item] = true
            @@selected_select = @@select
            $gamemode = 'inventory'
          end
        end
        Settings.show
      elsif $gamemode == 'key_bindings'
        if @@select == 0
          $key_mapping = $default_keys.deep_clone
        else
          @@selected_key = $key_mapping.to_a[@@select - 1]
          $key_mapping[@@selected_key.first] = '_ <- Enter a new key to be bound.'
        end
        Settings.show
      else
        clear_settings
        $gamemode = 'play'
      end
      false
    end

    def sleep_message
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

    def no_item_text
      @@title = "No item selected"
      @@selectable = false
      word_wrap("\nThis menu will normally describe an item, including the name, weight, icon it uses, where it can be equipped, range, bonus stats, how to use it, and any other extra information.")
    end

    def explain_item_text(item)
      padding = 20
      lines = ['']
      lines << "Name: #{item.name.or('N/A')}"
      lines << "Icon: #{item.icon.or('N/A')}"
      lines << "Weight: #{item.weight.or('N/A')}"
      lines << "Slot: #{humanize_slot(item.equipment_slot).or('N/A')}"
      lines << "Duration: #{item.duration}" if item.is_a?(LightSource)
      lines << "Range: #{item.range.or('N/A')}" if item.respond_to?(:range)
      lines << ""
      if item.respond_to?(:castable_spells)
        lines << "Castable Spells:"
        item.castable_spells.each do |spell_name|
          spell = Item[spell_name]
          line = ["#{spell_name}-"]
          line << "Type: #{spell.type.capitalize}"
          line << "Mana Cost: #{spell.mana_cost}" if spell.mana_cost && spell.mana_cost > 0
          line << "Range: #{spell.range}" if spell.range && spell.range > 0
          lines << "   #{columnize(padding, line)}"
        end
      end
      if item.respond_to?(:equipment_slot) && item.equipment_slot != nil
        lines << "Bonus Stats:"
        lines << "   #{columnize(padding, "Health:", "#{item.bonus_health.or('N/A')}")}"
        lines << "   #{columnize(padding, "Mana:", "#{item.bonus_mana.or('N/A')}")}"
        lines << "   #{columnize(padding, "Energy:", "#{item.bonus_energy.or('N/A')}")}"
        lines << "   #{columnize(padding, "Strength:", "#{item.bonus_strength.or('N/A')}")}"
        lines << "   #{columnize(padding, "Magic Power:", "#{item.bonus_magic_power.or('N/A')}")}"
        lines << "   #{columnize(padding, "Defense:", "#{item.bonus_defense.or('N/A')}")}"
        lines << "   #{columnize(padding, "Speed:", "#{item.bonus_speed.or('N/A')}")}"
        lines << "   #{columnize(padding, "Accuracy:", "#{item.bonus_accuracy.or('N/A')}")}"
        lines << "   #{columnize(padding, "Regeneration:", "#{item.bonus_self_regen.or('N/A')}")}"
      end
      lines << ""
      lines << " Description:"
      lines += word_wrap(item.description || "N/A")
      lines
    end

    def help_menu_text
%(
HELP - exit by pressing ESCAPE or the '#{$key_mapping[:open_help]}' key once again.

View and edit keys by hitting the '#{$key_mapping[:open_keybindings]}' key.

-------------------------------------------------------------------------------- #{'Movement'.color(:red)}
Each frame takes place on every interval of the speed of the Player(you). Monsters may move faster or slower than you. Speed is calculated by a single number, 1-100. 1 being the slowest, 100 being the fastest. The game will update only when the player moves. Monsters will move based on their relative speed to the Player. If the player moves at a speed of 10 and a monster moves at a speed of 15, every other turn the monster will appear to move 2 spaces because of the extra speed.

-------------------------------------------------------------------------------- #{'Targeting'.color(:red)}
When using a spell or ability, or throwing/shooting a projectile, you can quick cast by hitting the corresponding directional key. By hitting '#{$key_mapping[:select_position]}', you are able to scroll around using normal movement keys to select a specific place to target. If the target's distance is less than the max range of the projectile, it will stop at the selected position. If the target is beyond the range of the projectile, it will stop at its' max range.
)
    end

    def char_stats_text
      padding = 40
      lines = ['']
      lines << "   #{columnize(padding, 'Health:', "#{Player.max_health}")}"
      lines << "   #{columnize(padding, 'Mana:', "#{Player.max_mana}")}"
      lines << "   #{columnize(padding, 'Energy:', "#{Player.max_energy}")}"
      lines << "   #{columnize(padding, 'Health Regeneration:', "#{Player.self_regen}")}"
      lines << "   #{columnize(padding, 'Strength:', "#{Player.strength}")}"
      lines << "   #{columnize(padding, 'Magic Power:', "#{Player.magic_power}")}"
      lines << "   #{columnize(padding, 'Defense:', "#{Player.defense}")}"
      lines << "   #{columnize(padding, 'Accuracy:', "#{Player.accuracy}")}"
      lines << "   #{columnize(padding, 'Speed:', "#{Player.speed}")}"
    end

    def dead_menu_text
%(
You have DIED! Hit '#{$key_mapping[:exit]}' to exit the game.
)
    end
  end
end
