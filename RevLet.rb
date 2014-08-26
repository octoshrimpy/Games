#cd C:\Ruby193\Scripts

# cond ? T : F

puts "Please type a word you would like to be flipped."
usein = gets.chomp

neword = []
i = 0
 
while neword.length <= usein.length
  neword[i] = usein[usein.length - i]
  i += 1
end

puts neword.join
if neword.join == usein
	puts "You found a palindrome!!"
end