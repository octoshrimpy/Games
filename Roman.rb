@h = 1
# 1 = I
# 5 = V
# 10 = X
# 50 = L
# 100 = C

def convert(c)
  out = []
  if c == 100
    out << "C"
    c -= 100
  end
  if c >= 90
    out << "XC"
    c -= 90
  end
  if c >= 50
    out << "L"
    c -= 50
  end
  if c >= 40
    out << "XL"
    c -= 40
  end
  while c >= 10
    out << "X"
    c -= 10
  end
  if c == 9
    out << "IX"
    c -= 9
  end
  if c >= 5
    out << "V"
    c -= 5
  end
  if c == 4
    out << "IV"
    c -= 4
  end
  while c > 0
    out << "I"
    c -= 1
  end
  puts "Your number in Roman Numeral is:"
  puts out.join
end

def game
  puts "Please input a number 1-100."
  puts "It will be converted to a Roman Numeral."

  user_num = gets.chomp.to_i
  if user_num <= 100 || user_num >= 0
    convert(user_num)
  else
    puts "You have entered an invalid number."
    exit
  end
  puts "Would you like another? Default Yes. No for no."
  @h = 0 if gets.chomp.downcase.include?("n")
end

while @h = 1
  game
end
