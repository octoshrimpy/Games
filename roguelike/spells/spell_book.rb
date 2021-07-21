class SpellBook
  include Item

  attr_accessor :element, :castable_spells, :usage_verb

  def initialize(options)
    @usage_verb = 'read'
    super(options)
  end

  def cast_spell(spell_name)
    spell = Item.reference(spell_name)
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
      castable_spells: ['Fire Ball', 'Fire Blast'],
      description: "A Spell Book with inscribed Fire Spells. Spells can be listed by viewing the book and then selecting a spell. Spells can be equipped to the Quickbar by pressing Space while hovering on a Spell in the view menu."
    })
    new({
      name: 'Book of Poison',
      icon: '[',
      color: :blue,
      weight: 3,
      element: 'poison',
      castable_spells: ['Poison Blast'],
      description: "A Spell Book with inscribed Poison Spells. Spells can be listed by viewing the book and then selecting a spell. Spells can be equipped to the Quickbar by pressing Space while hovering on a Spell in the view menu."
    })
    new({
      name: 'Amulet of Power',
      icon: 'o',
      usage_verb: 'use',
      color: :red,
      weight: 1,
      element: 'physical',
      castable_spells: ['Berserk', 'Summon Stone'],
      description: "An mysterious glowing amulet. Grants power to the user. Spells can be listed by viewing the amulet and then selecting a spell. Spells can be equipped to the Quickbar by pressing Space while hovering on a Spell in the view menu."
    })
  end
end
