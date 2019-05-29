require 'colorize'
require 'pry'
# require './svg_builder.rb'
# http://anydice.com
# TODO:

# Enter any operation to perform the results.

# Dice
# Case does not matter.
# D: used to simulate the roll of virtual dice.
# nD: Roll the dice "n" times. (Default: 1)
# Dn: Roll a dice with "n" sides. (Default: 6)
# D%: Roll a dice with 100 sides.
# !: Roll an additional time if the highest value is rolled (6 for a 6 sided die)
# !n: Roll an additional time if "n" is rolled (Default: 1)
# +!n: Roll an additional time if the roll is equal or greater than "n"
# -!n: Roll an additional time if the roll is equal or less than "n"
# L: Drop the lowest result. (Used when rolling one die multiple times)
# Ln: Drop the lowest result "n" times.
# H: Drop the highest result. (Used when rolling one die multiple times)
# Hn: Drop the highest result "n" times.
# K: Drop the highest result. (Used when rolling one die multiple times)
# Kn: Drop the highest result "n" times.
# -L: Drop all results equal to the lowest dice value (1)
# -Ln: Drop all results equal to or less than "n"
# -H: Drop all results equal to the highest dice value (6 for a 6 sided die)
# -Hn: Drop all results equal to or greater than "n"

# TODO: Allow decimals?
# TODO: ^^ Allow "A" to be used to average rolls within a die?

# TODO: Add Rn() -- roll the same thing n times (Do not just multiply!!!)?

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

  DIE_PARSE_REGEX = /(\d*)d(\d*%?)((?:[\-\+]?[!HKL]\d*)*)/i

  def self.roll(str, opts={})
    new(str, opts)
    # dice = str.split(" ").map { |roll_str| new(roll_str) }
    # dice_totals = dice.sum(&:value)
    # {
    #   total: dice_totals,
    #   dice: dice
    # }
  end

  def initialize(roll_str, opts={})
    @force = opts[:force].to_s.to_sym
    @roll_str = @current = roll_str
    @iterations = []
    @rolls = []
    iterate("Dice") { @current.gsub(DIE_PARSE_REGEX) { |die| evaluate_die(die) } }
    evaluate_expressions(@current)
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
    @current = iteration
    return if before.nil? || iteration.nil?
    @iterations << {before: @force_before || before, after: iteration, description: description}
    @force_before = nil
    # puts "#{iterations.last}".colorize(:yellow)
  end

  def evaluate_expressions(str, parens: true)
    num_regex = "(-?\\d+)"
    spaces = " *"
    iterate("Parens") do
      next unless parens
      hold = @current.dup
      str = str.gsub(/(\d+)(\()/, "\\1*\\2").repeat_gsub(/\([^\(\)]*?\)/) do |found|
        parsed_parens = evaluate_expressions(found[1..-2], parens: false)
        hold.sub!(found, "(#{parsed_parens})")
        parsed_parens
      end
      @force_before = hold
      str
    end
    iterate("#{'Inner ' unless parens}Exponents") do
      str = str.repeat_gsub(/#{num_regex}#{spaces}\*\*#{spaces}#{num_regex}/) { |found| eval found }
    end
    # iterate("#{'Inner ' unless parens}Root") do
    #   str = str.repeat_gsub(/#{num_regex}rt#{num_regex}/) { |found| found.split("rt") }
    # end
    iterate("#{'Inner ' unless parens}Multiplication") do
      str = str.repeat_gsub(/#{num_regex}#{spaces}\*#{spaces}#{num_regex}/) { |found| eval found }
    end
    iterate("#{'Inner ' unless parens}Division") do
      str = str.repeat_gsub(/#{num_regex}#{spaces}\/#{spaces}#{num_regex}/) { |found| eval found rescue 0 }
    end
    iterate("#{'Inner ' unless parens}Addition") do
      str = str.gsub(/(#{num_regex}) +(#{num_regex})/) do |found|
        found.gsub(/\s+/, "+")
      end.repeat_gsub(/#{num_regex}#{spaces}\+#{spaces}#{num_regex}/) do |found|
        eval found
      end
    end
    iterate("#{'Inner ' unless parens}Subtraction") do
      str = str.repeat_gsub(/#{num_regex}#{spaces}\-#{spaces}#{num_regex}/) { |found| eval found }
    end
    str
  end

  def roll(val)
    if @force == :high
      val
    elsif @force == :low
      1
    else
      rand(val).round + 1 # +1 to account for rand including 0
    end
  end

  def remove_from_rolls(roll_values, rolls, num_to_remove)
    delete_idx = roll_values.index(num_to_remove)
    rolls << "-#{num_to_remove}" if delete_idx >= 0
    roll_values.delete_at(delete_idx)
  end

  def evaluate_die(die)
    options = die_options(die)
    sides = options[:sides]
    rolls = []

    roll_values = options[:roll_count].times.map do |t|
      roll_val = roll(sides)
      rolls << roll_val
      last_roll = roll_val
      rolls_to_repeat = [options[:repeat_roll]].compact.flatten
      while rolls_to_repeat.include?(last_roll) && rolls_to_repeat.length < sides
        roll_val += last_roll = roll(sides)
        rolls << "+#{last_roll}"
      end
      roll_val
    end

    options[:drop_lowest].to_s.to_i.times { remove_from_rolls(roll_values, rolls, roll_values.min) }
    options[:drop_highest].to_s.to_i.times { remove_from_rolls(roll_values, rolls, roll_values.max) }
    remove_from_rolls(roll_values, rolls, roll_values.min) while options[:drop_lower].present? && roll_values.any? { |roll_val| roll_val < options[:drop_lower].to_i }
    remove_from_rolls(roll_values, rolls, roll_values.max) while options[:drop_higher].present? && roll_values.any? { |roll_val| roll_val > options[:drop_higher].to_i }

    total = roll_values.sum
    roll_details = {die: die, total: total, rolls: rolls}
    # puts roll_details
    @rolls << roll_details
    "#{total}#{options[:leftover]}"
  end

  def die_options(modifier_str)
    options = {}

    raw_roll_count, raw_sides, modifiers = modifier_str.scan(DIE_PARSE_REGEX).flatten
    options[:roll_count] = roll_count = (raw_roll_count.presence || 1).to_i
    options[:sides] = sides = (raw_sides.gsub("%", "100").presence || 6).to_i

    drop_lower, l_found, low_match = modifiers.scan(/(\-)?(L)(\d*)/i).first
    drop_higher, h_found, high_match = modifiers.scan(/(\-)?(H|K)(\d*)/i).first
    bang_modifier, bang_found, bang_match = modifiers.scan(/(\-|\+)?(\!)(\d*)/i).first

    options[:leftover] = modifier_str
      .sub([raw_roll_count, :d, raw_sides].join(""), "")
      .sub([drop_lower, l_found, low_match].join(""), "")
      .sub([drop_higher, h_found, high_match].join(""), "")
      .sub([bang_modifier, bang_found, bang_match].join(""), "")

    options[:drop_lowest] = (low_match.presence || 1).to_i if l_found.present? && drop_lower.blank?
    options[:drop_highest] = (high_match.presence || 1).to_i if h_found.present? && drop_higher.blank?
    options[:drop_lower] = (low_match.presence || 1).to_i if l_found.present? && drop_lower.present?
    options[:drop_higher] = (high_match.presence || sides).to_i if h_found.present? && drop_higher.present?
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

# dice = []
# 1000.times do
#   dice << Dice.roll(ARGV.join(" ").presence || "d").value.to_i
# end
# draw_svg(dice)

results = Dice.roll(ARGV.join(" "))
prev_result = results.roll_str.dup
puts prev_result.to_s.colorize(:cyan)
results.iterations.each do |iteration|
  # puts "#{iteration}".colorize(:yellow)
  puts prev_result.gsub!(iteration[:before], iteration[:after]).to_s.colorize(:cyan)
end
table = AsciiTable.new
table.add_row("Die", "Rolls", "Totals")
table.add_divider
results.rolls.each do |roll|
  table.add_row(roll[:die], roll[:rolls].join(','), roll[:total])
end
table.add_divider
table.add_row("Total", results.roll_str, results.value)
table.draw
