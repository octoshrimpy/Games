#cd C:\Ruby193\Scripts

puts "Type a number, please."
x = (gets.chomp)
if (x.to_i)/2 == (x.to_f)/2 
  result = "even"
else
  result = "odd"
end

if (x.to_i)/3 == (x.to_f)/3
  puts "Your number is #{result} and divisible by 3."
else
  puts "Your number is #{result} and NOT divisible by 3."
end
