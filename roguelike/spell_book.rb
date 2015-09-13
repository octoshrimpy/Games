# SpellBook.new({
#   name: 'string',
#   icon: 'string-single character',
#   color: :symbol,
#   weight: integer,
#   element: 'string',
#   castable_spells: ['strings'],
#   bonus_strength: integer(optional),
#   bonus_defense: integer(optional),
#   bonus_accuracy: integer(optional),
#   bonus_speed: integer(optional),
#   bonus_health: integer(optional),
#   bonus_mana: integer(optional),
#   bonus_energy: integer(optional),
#   bonus_self_regen: integer(optional)
# })

class SpellBook
  include Item

  attr_accessor :element, :castable_spells

  def cast_spell(spell_name)
    spell = Item[spell_name]
    if self.castable_spells.include?(spell_name)
      spell.cast!
    end
  end

  def sort_spells!
    old_spells = castable_spells.dup
    sorted_spells = castable_spells.sort
    self.castable_spells = old_spells == sorted_spells ? sorted_spells.reverse : sorted_spells
    Settings.show
  end

  def swap_spells(slot_a, slot_b)
    return false unless slot_a && slot_b
    spells = castable_spells
    return false unless spells[slot_a] && spells[slot_b]
    spells[slot_a], spells[slot_b] = spells[slot_b], spells[slot_a]
    true
  end

  def self.generate
    new({
      name: 'Book of Fire',
      icon: '[',
      color: :blue,
      weight: 3,
      element: 'fire',
      castable_spells: ['Fire Ball', 'Fire Blast']
    })
    new({
      name: 'Book of Poison',
      icon: '[',
      color: :blue,
      weight: 3,
      element: 'poison',
      castable_spells: ['Poison Blast']
    })
  end
end
