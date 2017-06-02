#cd C:\Ruby193\Scripts

# cond ? T : F
# require 'pry'
class Armadillo
	def initialize
		@de = 0
		@en = 0
		@rot = false
		@arm = false
		@out = []
	end
	
	def setup
		puts "Would you like to use ROT-13 or Armadillo?"
		style = gets.chomp.downcase
		if ["r"].include?(style[0])
			@rot = true
			@arm = false
			puts "You have chosen the method of ROT-13."
		elsif ["a"].include?(style[0])
			@arm = true
			@rot = false
			puts "You have chosen the method of Armadillo."
		else
			puts "Invalid statement."
		end
		
		puts "Would you like to encrypt or decrypt?"
		type = gets.chomp.downcase
		if ["e"].include?(type[0])
			if @arm == true
				puts "Please input the encryption key. (String)"
				ciphers = gets.chomp.downcase.split('')
				cipheri = cipher(ciphers)
			end
			
			if @rot == true
				cipheri = ["13"]
			end
			
			puts "Please input the data to be encrypted."
			data = gets.chomp.downcase.split('')
			datai = cipher(data)
			encrypt(datai, cipheri)
		elsif ["d"].include?(type[0])
			if @arm == true
				puts "Please input the decryption key. (String)"
				ciphers = gets.chomp.downcase.split('')
				cipheri = cipher(ciphers)
			end
			
			if @rot == true
				cipheri = ["13"]
			end
			
			puts "Please input the data to be decrypted."
			data = gets.chomp.downcase.split('')
			datai = cipher(data)
			decrypt(datai, cipheri)
		else
			puts "Invalid statement."
		end
	end
		# puts "Type # to import previous string."
	def encrypt(data,key)
		i = 0
		while key.length < data.length
			key *= 2
		end
		
		data = data.map(&:to_i)
		key = key.map(&:to_i)
		crypt = []
		# binding.pry
		while i < data.length
			crypt[i] = data[i] + key[i]
			crypt[i] -= 27 if crypt[i] > 27
			i+=1
		end
		
		decipher(crypt)
	end
	
	def decrypt(data,key)
		i = 0
		while key.length < data.length
			key *= 2
		end
		
		data = data.map(&:to_i)
		key = key.map(&:to_i)
		crypt = []
		while i < data.length
			crypt[i] = data[i] - key[i]
			crypt[i] += 27 if crypt[i] < 1
			i+=1
		end
		
		decipher(crypt)
	end
	
	def cipher(cyp) #Converts letters to numbers
		i = 0
		while i < cyp.length
			cyp[i] = cyp[i].tr('abcdefghi','123456789').to_i if ["a","b","c","d","e","f","g","h","i",].include?(cyp[i])
			cyp[i] = cyp[i].tr('jklmnopqr','123456789').to_i+9 if ["j","k","l","m","n","o","p","q","r",].include?(cyp[i])
			cyp[i] = cyp[i].tr('stuvwxyz','123456789').to_i+18 if ["s","t","u","v","w","x","y","z"," "].include?(cyp[i])
			i += 1
		end		
		return cyp
	end
	
	def decipher(dec) #Converts numbers to letters
		i = 0
		while i < dec.length
			dec[i] = dec[i].to_s.tr('123456789','abcdefghi') if (1..9).include?(dec[i])
			dec[i] = (dec[i]-9).to_s.tr('123456789','jklmnopqr') if (10..18).include?(dec[i])
			dec[i] = (dec[i]-18).to_s.tr('1234567','stuvwxyz ') if (19..29).include?(dec[i])
			i += 1
		end		
		@out = dec.join
	end
end
#a b c d e f g h i j k l m n o p q r s t u v w x y z" "
#1 2 3 4 5 6 7 8 9 101112131415161718192021222324252627
ende = Armadillo.new
going = true
g = ""
while going
	ende.setup
	puts "Your complete phrase is:"
	puts"#{ende.instance_variable_get(:@out)}."
	puts "\n\nWould you like to do another? Yes by default."
	if ["n", "f"].include?(gets.chomp.downcase[0])
		going = false
	end
	
end