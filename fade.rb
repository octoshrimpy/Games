def fade(from_hex, to_hex, steps=10, fade_back=false)
  steps = steps.to_i
  fade_back = (fade_back || fade_back == 'true')
  steps -= 1
  return [] if steps <= 0
  return from_hex if steps == 1
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
  if fade_back
    back_colors = colors.dup
    back_colors.pop
    back_colors.reverse!
    back_colors.pop
    colors += back_colors
  end
  return colors.compact
end

def hex_to_rgb(hex)
  clear_hash = hex.gsub("#", '')
  if clear_hash.length == 6
    return clear_hash.scan(/.{2}/).map { |rgb| rgb.to_i(16) }
  elsif clear_hash.length == 3
    return clear_hash.split('').map { |rgb| "#{rgb}#{rgb}".to_i(16) }
  else
    return nil
  end
end

def rgb_to_hex(rgb)
  r, g, b = rgb.map { |val| new_val = [val.round, 0, 255].sort[1].to_s(16); new_val.length == 1 ? "#{new_val}#{new_val}" : new_val }
  "##{r}#{g}#{b}".upcase
end

# ARGV.each do |ag|
#   puts ag
# end
if ARGV.count < 2
  # puts ARGV.count
  puts "arguments: from_hex, to_hex, steps=10, fade_back=false"
else
  # puts ARGV[0], ARGV[1], ARGV[2] || 10, ARGV[3] || false
  puts fade(ARGV[0], ARGV[1], ARGV[2] || 10, ARGV[3] || false)
end
# puts fade("#FF0000", "#FFFF00", 10)

# ["#FF0000", "#FF1C00", "#FF3900", "#FF5500", "#FF7100", "#FF8E00", "#FFAA00", "#FFC600", "#FFE300", "#FFFF00"]
