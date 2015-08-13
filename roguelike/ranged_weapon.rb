class RangedWeapon
  include Item

  attr_accessor :range, :thrown, :ammo_type

  def fire!
    if thrown
      Settings.ready_throw(self)
    else
      if Player.has(ammo_type)
        Settings.ready_shoot(self, item_in_inventory_by_name(ammo_type))
      else
        Log.add "Out of ammo. Need more #{ammo_type}"
      end
    end
  end
end
