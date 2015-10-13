$key_mapping = {
  move_up: "w",
  move_left: "a",
  move_right: "d",
  move_down: "x",
  move_up_left: "q",
  move_up_right: "e",
  move_down_left: "z",
  move_down_right: "c",
  move_nowhere: "s",
  select_position: "*",

  down_stairs: ">",
  up_stairs: "<",

  sleep: "S",
  open_logs: "L",
  open_help: "H",
  char_stats: "T",
  open_keybindings: "K",
  inspect_surroundings: "M",
  open_inventory: "I",
  open_equipment: "R",
  read_more: "r",
  exit: "N",

  pickup_items: "SPACE",
  confirm: "RETURN",
  exit_menu: "ESCAPE",
  back_menu: "BACKSPACE",
  some_other: 'asd'
}.freeze
$default_keys = $key_mapping.deep_clone
