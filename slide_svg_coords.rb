# Paste in a "d" coords list, select how far to slide each direction then `ruby slide_svg_coords.rb`

slide_x = ARGV[0].to_f
slide_y = ARGV[1].to_f
file = ARGV[2]

min_x=nil
max_x=nil
min_y=nil
max_y=nil

text = File.read(file)

text = text.gsub(/\bd\=\"(.*?)\"/) do |found|
  path = Regexp.last_match(1)

  path = path.gsub(/([^\d\s])(\-?\d+(?:\.\d+)),(\-?\d+(?:\.\d+))/) do |found|
    letter = Regexp.last_match(1)
    x = (Regexp.last_match(2).to_f + slide_x).round(5)
    min_x = x if !min_x || x < min_x
    max_x = x if !max_x || x > max_x
    y = (Regexp.last_match(3).to_f + slide_y).round(5)
    min_y = y if !min_y || y < min_y
    max_y = y if !max_y || y > max_y

    "#{letter}#{(x.to_f + slide_x).round(5)},#{(y.to_f + slide_y).round(5)}"
  end

  "d=\"#{path}\""
end

File.open(file, "w") { |f| f.puts text }
puts "
Min x: #{min_x}
Max x: #{max_x}
Min y: #{min_y}
Max y: #{max_y}
"
