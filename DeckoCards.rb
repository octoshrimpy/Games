puts "Hello World"
@deck = [ ["AH"], ["AD"], ["AS"], ["AC"],
          ["2H"], ["2D"], ["2S"] , ["2C"],
          ["3H"], ["3D"], ["3S"] , ["3C"],
          ["4H"], ["4D"], ["4S"] , ["4C"],
          ["5H"], ["5D"], ["5S"] , ["5C"],
          ["6H"], ["6D"], ["6S"] , ["6C"],
          ["7H"], ["7D"], ["7S"] , ["7C"],
          ["8H"], ["8D"], ["8S"] , ["8C"],
          ["9H"], ["9D"], ["9S"] , ["9C"],
          ["TH"], ["TD"], ["TS"] , ["TC"],
          ["JH"], ["JD"], ["JS"] , ["JC"],
          ["QH"], ["QD"], ["QS"] , ["QC"],
          ["KH"], ["KD"], ["KS"] , ["KC"]]
@deck.each do |t|
  t[1] = true
end

def draw
  i = 0
  while i < @deck.length
    drew = rand(@deck.length)
    if @deck[drew][1]
      print @deck[drew][0]
      puts " has been drawn!"
      @deck[drew][1] = false
      i += 1
      puts "Cards remaining:"
      @deck.each do |check|
        if check[1] == true
          print check[0]
        end
      end
        puts ""
        gets
    end
  end
end

draw
