require 'colorize'
require 'pry'
require './svg_builder.rb'
# http://anydice.com
# TODO:
# Operations on dice (+, -, *, /)
# Complex operations USING dice: 3(1d8+2d6+10)+d4 is valid!
# Some letters are shortcuts:
# L\d+ Keep lowest X results
# H\d+ Keep highest X results
# 4d6L2 means roll 4, but drop the lowest 2 results and only add the high 2
# "d%" is shortcut for d100
# Add explanations of all dice notation possibilities to page

# Enter any operation to perform the results.

# Dice
# "d" can be used to simulate the roll of a virtual dice.
# A number coming before the "d" represents the number of times to roll the dice. "2d" means roll a standard die 2 times and sum the results
# A number coming after the "d" represents the number of sides on the dice. "d2" means roll a 2 sided dice - equivalent to a coin flip
# "L" can be appended to a dice roll and means "drop the lowest result"
# A number coming after the "L" means to drop that many results. "4dL2" means roll 4 dice and only count the highest 2 rolls
# "H" is the opposite of "L" and means drop the HIGHEST result.
# A number coming after the "H" means to drop that many results. "4dH2" means roll 4 dice and only count the lowest 2 rolls
# "-L" means drop all results equal to or less than the number given (default is 1)
# "-L3" means drop all results that are less than or equal to 3
# "-H" means drop all results equal to or greater than the number given (default is the highest value of the die)
# "-H3" means drop all results that are greater than or equal to 3
# "!" can be used to roll the same dice again if the roll matches the number given (default is the highest value of the die) (The sum is used) - this results in a potentially infinite value
# "+!" applies the same rules, but is valid if the number is greater than or equal to the given number.
# "-!" applies the same rules, but is valid if the number is less than or equal to the given number.
# TODO: Allow decimals?
# TODO: ^^ Allow "A" to be used to average rolls within a die?

# Operations
# Addition (+), Subtraction (-), Multiplication (* - parentheses can also be used), Division (/), Exponent (**)
# Dice throws are calculated first.
# Mathematical operations follow in the order of:
# () ** * / + -

# Shortcuts
# "d" is "1d6". If either number is missing, the default value is used.
# "d%" is shorthand for "d100"

class Object
  def presence
    self if present?
  end

  def present?
    !blank?
  end

  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end

class String
  def repeat_gsub(q, replace=nil)
    did_find = false
    new_str = self.dup
    loop do
      did_find = false
      new_str = new_str.gsub(q) do |found|
        did_find = true
        replace || yield(found)
      end
      break unless did_find
    end
    new_str
  end
end

class AsciiTable
  attr_accessor :table_rows

  def self.from(arr)
    new(arr)
  end

  def initialize(arr=[])
    @table_rows = arr
    # [
    #   [h1, h2, h3],
    #   [vy1,vy2,vy3],
    #   [vy1,vy2,vy3],
    #   [vy1,vy2,vy3]
    # ]
  end

  def add_row(*row)
    @table_rows << row.flatten
  end

  def add_divider
    @table_rows << nil
  end

  def draw
    @column_widths = []
    @table_rows.each do |row|
      next if row.nil?
      row.each_with_index do |col, idx|
        col_size = col.to_s.length
        @column_widths[idx] = [@column_widths[idx].to_i, col_size].sort.last
      end
    end

    puts write_divider
    @table_rows.each do |row|
      puts write_line(row)
    end
    puts write_divider
  end

  def write_divider
    "+-#{@column_widths.map { |column_length| '-' * column_length }.join('-+-')}-+"
  end

  def write_line(row)
    return write_divider if row.nil?
    "| #{row.map.with_index { |col, idx| col.to_s.ljust(@column_widths[idx]) }.join(' | ')} |"
  end
end

class Dice
  attr_accessor :roll_str, :value, :iterations, :rolls

  def self.roll(str)
    new(str)
    # dice = str.split(" ").map { |roll_str| new(roll_str) }
    # dice_totals = dice.sum(&:value)
    # {
    #   total: dice_totals,
    #   dice: dice
    # }
  end

  def initialize(roll_str)
    @roll_str = @current = roll_str
    @iterations = []
    @rolls = []
    iterate("Dice") { @current.gsub(/\d*d[\dHL!%\-\+]*/) { |die| evaluate_die(die) } }
    iterate("Expressions") { evaluate_expressions(@current) }
    @value = @current

    # results = {sum: 0, dice: []}
    # full_str.split(" ").each do |dnd_str|
    #   rolls = dnd_roll(dnd_str)
    #   results[:sum] += rolls.sum
    #   results[:dice] << { str: dnd_str, rolls: rolls, total: rolls.sum }
    # end
  end

  def iterate(description=nil)
    before = @current
    iteration = yield
    return if iteration == @current
    @iterations << {before: before, after: @current = iteration, description: description}
    # puts "#{iterations.last}".colorize(:yellow)
  end

  def evaluate_expressions(str, parens=true)
    num_regex = "(-?\\d+)"
    spaces = " *"
    str = str.gsub(/(\d+)(\()/, "\\1*\\2").repeat_gsub(/\([^\(\)]*?\)/) { |found| evaluate_expressions(found[1..-2], false) } if parens #iterate("Parens") {}
    str = str.repeat_gsub(/#{num_regex}#{spaces}\*\*#{spaces}#{num_regex}/) { |found| eval found } #iterate("Exponent") {}
    # str = str.repeat_gsub(/#{num_regex}rt#{num_regex}/) { |found| found.split("rt") } #iterate("Root") {}
    str = str.repeat_gsub(/#{num_regex}#{spaces}\*#{spaces}#{num_regex}/) { |found| eval found } #iterate("Multiplication") {}
    str = str.repeat_gsub(/#{num_regex}#{spaces}\/#{spaces}#{num_regex}/) { |found| eval found rescue 0 } #iterate("Divide") {}
    str = str.gsub(/(#{num_regex}) +(#{num_regex})/) { |found| found.gsub(/\s+/, "+") } #iterate("Add") {}
    str = str.repeat_gsub(/#{num_regex}#{spaces}\+#{spaces}#{num_regex}/) { |found| eval found } #iterate("Add") {}
    str = str.repeat_gsub(/#{num_regex}#{spaces}\-#{spaces}#{num_regex}/) { |found| eval found } #iterate("Subtract") {}
    str
  end

  def evaluate_die(die)
    options = die_options(die)
    rolls = []

    roll_values = options[:roll_count].times.map do |t|
      roll = rand(options[:sides]).round + 1
      rolls << roll
      last_roll = roll
      while [options[:repeat_roll]].compact.flatten.include?(last_roll) && rolls.length < 100
        roll += last_roll = rand(options[:sides]).round + 1
        rolls << "+#{last_roll}"
      end
      roll
    end
    roll_values.sort!

    options[:drop_lowest].to_i.times { roll_values.shift } if options[:drop_lowest]
    roll_values.select! { |roll| roll > options[:drop_lower].to_i } if options[:drop_lower].present?
    options[:drop_highest].to_i.times { roll_values.pop } if options[:drop_highest]
    roll_values.select! { |roll| roll < options[:drop_higher].to_i } if options[:drop_higher].present?

    total = roll_values.sum
    roll_details = {die: die, total: total, rolls: rolls}
    # puts roll_details
    @rolls << roll_details
    "#{total}#{options[:leftover]}"
  end

  def die_options(modifier_str)
    options = {}

    raw_roll_count, raw_sides, modifiers = modifier_str.scan(/(\d*)d([\d\%]*)([\-\+HL!\d]*)/).flatten
    options[:roll_count] = roll_count = (raw_roll_count.presence || 1).to_i
    options[:sides] = sides = (raw_sides.gsub("%", "100").presence || 6).to_i

    drop_lower, l_found, low_match = modifiers.scan(/(\-)?(L)(\d*)/).first
    drop_higher, h_found, high_match = modifiers.scan(/(\-)?(H)(\d*)/).first
    bang_modifier, bang_found, bang_match = modifiers.scan(/(\-|\+)?(\!)(\d*)/).first

    options[:leftover] = modifier_str
      .sub([raw_roll_count, :d, raw_sides].join(""), "")
      .sub([drop_lower, l_found, low_match].join(""), "")
      .sub([drop_higher, h_found, high_match].join(""), "")
      .sub([bang_modifier, bang_found, bang_match].join(""), "")

    options[:drop_lowest] = drop_lower.blank? && l_found.present? && (low_match.presence || 1).to_i
    options[:drop_lower] = drop_lower.present? && l_found.present? && (low_match.presence || 1).to_i
    options[:drop_highest] = drop_higher.blank? && h_found.present? && (high_match.presence || 1).to_i
    options[:drop_higher] = drop_higher.present? && h_found.present? && (high_match.presence || sides).to_i
    rolls_to_repeat = if bang_found
      if bang_modifier.blank?
        [sides]
      elsif bang_modifier == "+"
        bang_match.to_i..sides
      elsif bang_modifier == "-"
        1..bang_match.to_i
      end
    end
    options[:repeat_roll] = rolls_to_repeat.to_a if ((1..sides).to_a - rolls_to_repeat.to_a).length >= 1
    # puts "#{options}".colorize(:cyan)
    options
  end
end

# results = dnd(ARGV.join(" "))
#
# table = AsciiTable.new
# table.add_row("Die", "Rolls", "Totals")
# table.add_divider
# results[:dice].each do |die|
#   table.add_row(die[:str], die[:rolls].join(','), die[:total])
# end
# table.add_divider
# table.add_row("Total", nil, results[:sum])
# table.draw

dice = []
1000.times do
  dice << Dice.roll(ARGV.join(" ").presence || "d").value.to_i
end
draw_svg(dice)
