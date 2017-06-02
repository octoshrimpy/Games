while true do
  input = gets.chomp
  case
  when input.include?("+") then a, b = input.split("+"); operator = "+"
  when input.include?("-") then a, b = input.split("-"); operator = "-"
  end
  a.strip!
  puts a.length
  hex_vals = case a.length
  when 6
    a.scan(/.{2}/).each do |hex|
      aa = hex.to_i(16)
      b = b.to_i
      c = case operator
      when "+" then aa + b
      when "-" then aa - b
      end
      c = c > 255 ? 255 : c
      print c.to_s(16).upcase
    end
  when 3
    a.scan(/.{1}/).each do |hex|
      aa = "#{hex}#{hex}".to_i(16)
      b = b.to_i
      c = case operator
      when "+" then aa + b
      when "-" then aa - b
      end
      c = c > 255 ? 255 : c
      print c.to_s(16).upcase
    end
  when 2
    a = a.strip.to_i(16)
    b = b.to_i
    c = case operator
    when "+" then a + b
    when "-" then a - b
    end
    c = c > 255 ? 255 : c
    print c.to_s(16).upcase
  end

  puts
end
