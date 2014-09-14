class FcdController < ApplicationController


  def create
    shuffle
  end

  def shuffle
    @deck = [ "AH", "AD", "AS", "AC",
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
              "KH", "KD", "KS", "KC"]
  end

  def draw
    shuffle if @deck.nil? || @deck.empty?
    drew = @deck.delete_at(rand(@deck.length))
  end
  helper_method :draw

  def update
  end
 # Sort: 2-9, AJKQT, CDHS
  def readhand(a)
    a = a.sort
    #5kind, StrFlu, 4kind, FlHs, Flu, Str, 3kind, 2pair, pair, A-2
    # vk,      sf    ivk    fh   fs    str  iiik    iip    ip  ha,hk,hq,hj,hx,hix,hiix...hii
    str = [["2", "3", "4", "5", "6"], ["3", "4", "5", "6", "7"], ["4", "5", "6", "7", "8"],
            ["5", "6", "7", "8", "9"], ["6", "7", "8", "9", "T"], ["7", "8", "9", "J", "T"],
            ["8", "9", "J", "Q", "T"], ["9", "J", "K", "Q", "T"], ["A", "J", "K", "Q", "T"]]
    suits = []
    suitcount = Array.new (4) {0}
    nums = []
    numcnt = Array.new (14) {0}
    5.times {|x| suits << a[x][1]}
    suits.each do |x|
      suitcount[0] += 1 if x == "D"
      suitcount[1] += 1 if x == "S"
      suitcount[2] += 1 if x == "H"
      suitcount[3] += 1 if x == "C"
    end
    5.times {|x| nums << a[x][0]}
    nums.each do |x|
      numcnt[1] += 1 if x == "A"
      numcnt[2] += 1 if x == "2"
      numcnt[3] += 1 if x == "3"
      numcnt[4] += 1 if x == "4"
      numcnt[5] += 1 if x == "5"
      numcnt[6] += 1 if x == "6"
      numcnt[7] += 1 if x == "7"
      numcnt[8] += 1 if x == "8"
      numcnt[9] += 1 if x == "9"
      numcnt[10] += 1 if x == "T"
      numcnt[11] += 1 if x == "J"
      numcnt[12] += 1 if x == "Q"
      numcnt[13] += 1 if x == "K"
    end
    "#{nums.join},#{suits.join}--#{numcnt.join},#{suitcount.join}"
    #Str/multiples
    # if str.include?(a.each_index {|x| a[x][0])
    #AND flush-T/F
    #High Card
    #2 pair If (cnt = 2) & (cnt = 2) and cnt1 != cnt 2
     # count = 0
     # b.each {|x| count += 1 if x == 1}
    #  if a =
  end
  helper_method :readhand

  def destroy
  end
end
