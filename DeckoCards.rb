@deck = [
  "AH", "AD", "AS", "AC",
  "2H", "2D", "2S", "2C",
  "3H", "3D", "3S", "3C",
  "4H", "4D", "4S", "4C",
  "5H", "5D", "5S", "5C",
  "6H", "6D", "6S", "6C",
  "7H", "7D", "7S", "7C",
  "8H", "8D", "8S", "8C",
  "9H", "9D", "9S", "9C",
  "TH", "TD", "TS", "TC",
  "JH", "JD", "JS", "JC",
  "QH", "QD", "QS", "QC",
  "KH", "KD", "KS", "KC"
]

def draw
  system "clear" or system "cls"
  deck = @deck.clone
  puts "Shuffled!"
  while deck.length > 0
    drew = rand(deck.length)
    print deck[drew]
    puts " has been drawn!"
    deck.delete_at(drew)
    puts "Cards remaining: #{deck.length}"
    deck.each do |check|
      print check
      print ", " if check != deck.last
    end
    puts ""
    a = gets.chomp.downcase
    system "clear" or system "cls"
    exit if a == "x"
  end
end

loop do
  draw
end
