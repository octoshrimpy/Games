require 'rspec'
class NotAColor < StandardError
  def initialize(msg="Not a color.")
    super
  end
end

def fade(input_color, output_color, steps=10)
  from_hex = color_to_hex(input_color)
  to_hex = color_to_hex(output_color)
  raise NotAColor if from_hex.nil? || to_hex.nil?
  steps -= 1
  return [] if steps <= 0
  return [from_hex] if steps == 1
  return [from_hex, to_hex] if steps == 2
  fr, fg, fb = hex_to_rgb(from_hex)
  tr, tg, tb = hex_to_rgb(to_hex)
  dr, dg, db = [(tr - fr) / steps.to_f, (tg - fg) / steps.to_f, (tb - fb) / steps.to_f]
  colors = []
  (steps + 1).times do |t|
    nr = fr + (dr * t)
    ng = fg + (dg * t)
    nb = fb + (db * t)
    colors << rgb_to_hex([nr, ng, nb])
  end
  return colors
end

def hex_to_rgb(hex)
  clear_hash = hex.gsub("#", '')
  case clear_hash.length
  when 6 then clear_hash.scan(/.{2}/).map { |rgb| rgb.to_i(16) }
  when 3 then clear_hash.split('').map { |rgb| "#{rgb}#{rgb}".to_i(16) }
  else nil
  end
end

def rgb_to_hex(rgb)
  # new_val = [val.round, 0, 255].sort[1].to_s(16)
  r, g, b = rgb.map { |val| val.length == 1 ? "#{val}#{val}" : val }
  "##{r}#{g}#{b}".upcase
end

def color_to_hex(color)
  case
  when color.downcase.include?('rgb')
    rgb = color.gsub(/(rgb\()(.*)(\))/i, '\2').split(',').map(&:to_i)
    raise NotAColor("Out of range") if rgb.max > 255 || rgb.min < 0
    rgb_to_hex(rgb)
  when color[0] == '#' || color.length == 3 || color.length == 6
    color.gsub!('#', '')
  else nil
  end
end

RSpec.describe do
  it 'fades from red to yellow' do
    expect(fade('#F00', '#FF0')).to eql(["#FF0000", "#FF1C00", "#FF3900", "#FF5500", "#FF7100", "#FF8E00", "#FFAA00", "#FFC600", "#FFE300", "#FFFF00"])
  end
  it 'fades from red to blue in 20 steps' do
    expect(fade('#F00', '#00F')).to eql([])
  end
end
