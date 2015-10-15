class StaticItem
  include Item

  attr_accessor :usage_script

  def examine
    $gamemode = 'play'
    eval(usage_script)
  end

  def self.generate
    new({
      name: 'Slime Ball',
      icon: 'i',
      color: :light_green,
      weight: 0.4,
      stack_size: 30,
      usage_script: 'Log.add "You squish the slime in your fingers."; false',
      description: 'A slime ball dropped by a Slime. Can be fed to Slimes to increase their strength and health.'
    })
    new({
      name: 'Cursed Bone',
      icon: 'I',
      color: :green,
      weight: 5,
      stack_size: 5,
      usage_script: 'Log.add "The bones have an evil aura around them."; false',
      tick_script: Evals.spawn_skellie,
      description: "Bones that have a mysterious feel to them, like they could come alive at any moment."
    })
  end
end
