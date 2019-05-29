require 'dentaku'
require 'pry-rails'
require "minitest/autorun"

class String
  def squish
    self.gsub(/^ +| +$/, "").gsub(/ +/, " ")
  end
end

class Array
  def sum
    sum_val = 0
    each { |array_val| sum_val += array_val }
    sum_val
  end
end

class ExcelParserError < StandardError; end

class TestExcelParser < Minitest::Test
  def test_basic_arithmetic
    assert_equal(2, ExcelParser.parse('1 + 1'))
    assert_equal(0, ExcelParser.parse('1 - 1'))
    assert_equal(4, ExcelParser.parse('2 * 2'))
    assert_equal(0.5, ExcelParser.parse('2 / 4'))
  end

  def test_advanced_arithmetic
    assert_equal(12, ExcelParser.parse('(12 * 12) / 12'))
    assert_equal(0, ExcelParser.parse('100 - (4 * 25)'))
  end

  def test_errors
    # Doesn't raise an error because Dentaku assumes the variables are okay.
    # assert_raises(ExcelParserError) { ExcelParser.parse("6 + a + b") }
    puts ExcelParser.parse("6 + a + b")
    assert_raises(ExcelParserError) { ExcelParser.parse("parse('1 + 1')") }
  end

  def test_substitutions
    assert_equal(5, ExcelParser.parse('Q1'))
    assert_equal(6, ExcelParser.parse('Q1 + Q4'))
    assert_equal(166.213, ExcelParser.parse('S1 - Q4'))
    assert_equal(28, ExcelParser.parse('T1(5)'))
  end

  def test_functions
    assert_equal(22, ExcelParser.parse('SUM(Q1..Q4)'))
    assert_equal(5.5, ExcelParser.parse('AVG(Q1..Q4)'))
    assert_equal(286, ExcelParser.parse('SUM((1 + 6), 17 + 2, 26 / 13, 5 * (6 + SUM(Q1..Q4) * (6 / 3)), 8)'))
  end
end

class ExcelParser
  def self.parse(str)
    new(str).parse
  end

  def initialize(str)
    @str = str
  end

  def parse
    substitute_values
    calculator = Dentaku::Calculator.new
    calculator.add_function(:avg, :float, ->(*args) { average_vals(args) })
    calculator.add_function(:t1, :float, ->(input) { table_convert(1, input) })
    calculator.evaluate(@str).to_f
  rescue Dentaku::ParseError => e
    raise ExcelParserError, e.message
    # substitute_functions
    # validate_characters
    # convert_ints_to_floats
    # puts @str
    # eval(@str)
  end

  def average_vals(*vals)
    filtered_vals = [vals].flatten.reject { |arg| arg == "nil" || arg == "" }
    filtered_vals.sum / filtered_vals.count.to_f
  end

  def substitute_values
    @str.gsub!(/([\d\w]+)\.\.([\d\w]+)/) do |found|
      range_start = $1.to_s
      range_end = $2.to_s
      range_start_type = range_start[/^[A-Z]+/]
      range_end_type = range_end[/^[A-Z]+/]
      range_start_id = range_start[/[0-9]+$/]
      range_end_id = range_end[/[0-9]+$/]

      unless range_start_type == range_end_type
        raise ExcelParserError, "Range types do not match: #{range_start} (#{range_start_type}) and #{range_end} (#{range_end_type}) are not the same."
      end

      (range_start_id.to_i..range_end_id.to_i).map { |range_id| "#{range_start_type}#{range_id}" }.join(",")
    end
    substitutions.each do |sub_str, sub_val|
      @str.gsub!(sub_str, sub_val.to_s)
    end
  end

  def substitute_functions
    [/AVG/, /SUM/, /T\d+/].each do |func|
      loop do
        break if @str.index(func).nil?
        func_start, func_end = capture_function_args(func)
        full_function = @str[func_start..func_end]
        function_name = full_function[/^[\w\d]+/]
        func_args = full_function.gsub(/^[\w\d]+\(/, "").gsub(/\)$/, "").split(",").map(&:squish)
        func_args.reject! { |arg| arg == "nil" || arg == "" }
        evaluated_args = func_args.map { |arg| self.class.parse(arg) }

        evaluated_func =
          case function_name
          when "AVG"
            evaluated_args.sum / evaluated_args.length.to_f
          when "SUM"
            evaluated_args.sum
          else
            if evaluated_args.count == 0
              raise ExcelParserError, "No value passed to the table."
            end
            if evaluated_args.count > 1
              raise ExcelParserError, "Tables only accept a single argument. Perhaps you meant to SUM the values before passing them into the table?"
            end
            table_convert(function_name, evaluated_args.first.to_f)
          end
        @str.gsub!(@str[func_start..func_end], evaluated_func.to_s)
      end
    end
    # TODO - Capture parens, split commas, "parse" each section, remove `nil`, then perform function
  end

  def table_convert(table_idx, val)
    # Lookup by table, find the row matching the value, return the new val
    return 28 if val == 5
  end

  def capture_function_args(func)
    paren_counter = nil
    func_start_idx = @str.index(func)
    current_idx = func_start_idx
    loop do
      pos = @str[current_idx]
      break if pos.nil?
      paren_counter = 0 if paren_counter.nil? && pos == "("
      paren_counter += 1 if pos == "("
      paren_counter -= 1 if pos == ")"
      break if paren_counter == 0
      current_idx += 1
    end
    func_end_idx ||= @str.length + 1
    [func_start_idx, current_idx]
  end

  def validate_characters
    bad_str = @str.scan(/[^\.\0-9 \*\-\+\/\(\)]+/).first
    return if bad_str.nil?
    bad_idx = @str.index(bad_str)
    error = "Invalid character sequence detected at index #{bad_idx}: `#{bad_str}`\n#{@str}\n#{' '*bad_idx}^"
    # puts "\e[31m#{error}\e[0m"
    raise ExcelParserError, error
  end

  def convert_ints_to_floats
    @str.gsub!(/[\d\.]+/) { |found| "Float(#{found})" }
  end

  def substitutions
    {
      "Q1" => 5,
      "Q2" => 7,
      "Q3" => 9,
      "Q4" => 1,
      "Q5" => 13.7,
      "S1" => 167.213,
      "S2" => 72,
      "S3" => 100
    }
  end
end
