TILES = {
  :SPACER    => " ",
  :WALL      => "#",
  :STAIR_UP  => "<",
  :STAIR_DWN => ">"
}

TILESET = TILES.map {|key, val| val.ljust(2, TILES[:SPACER])}