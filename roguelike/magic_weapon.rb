class MagicWeapon
  include Item

  attr_accessor :range, :type, :mana_usage, :spell_to_cast

  def fire!
    if Player.mana > mana_usage
      Settings.ready_shoot(self, Item[spell_to_cast])
      Player.mana -= mana_usage
    else
      Log.add "Out of mana."
      $gamemode = 'play'
      Game.redraw
    end
  end
end
