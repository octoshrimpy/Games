class MagicWeapon
  include Item

  attr_accessor :range, :type, :mana_usage, :ammo_type

  def fire!
    if Player.mana >= mana_usage
      Settings.ready_shoot(self, Item[ammo_type])
      Player.mana -= mana_usage
      false
    else
      Log.add "Not enough mana."
      $gamemode = 'play'
      Game.redraw
      false
    end
  end
end
