class MagicWeapon
  include Item

  attr_accessor :range, :type, :mana_usage, :spell_to_cast

  def fire!
    if Player.mana > mana_usage
      Settings.ready_shoot(self, Item[spell_to_cast])
    else
      Log.add "Out of mana."
    end
  end
end
