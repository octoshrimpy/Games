class Item
  attr_accessor :name, :type

  def initialize
    # name:string
    # type:melee/range/spell/thrown
    # Damage:int
    # Weight:int
    # Stats:hash (+3STR, -1SPD)
    # Thrown damage does weight * speed?
  end
end
