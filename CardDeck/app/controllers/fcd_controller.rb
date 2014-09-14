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
    str = [["2", "3", "4", "5", "6"], ["3", "4", "5", "6", "7"], ["4", "5", "6", "7", "8"],
            ["5", "6", "7", "8", "9"], ["6", "7", "8", "9", "T"], ["7", "8", "9", "J", "T"],
            ["8", "9", "J", "Q", "T"], ["9", "J", "K", "Q", "T"]]
    ryl = ["A", "J", "K", "Q", "T"]
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
    #StrFlu, 4kind, FlHs, Flu, Str, 3kind, 2pair, pair, A-2
    #   sf    ivk    fh   fs    str  iiik    iip    ip  ha,hk,hq,hj,hx,hix,hiix...hii
    #nums = 236AA, suits = SHSDH, numcnt = 01120020, suitcount = 1220
    royal = false
    straight = false
    flush = false
    ick = false
    iiik = false
    iip = false
    ip = false
    hc = "0"
    windex= []

    royal = true if ryl.include?(nums) == true
    straight = true if str.include?(nums) == true
    flush = true if suitcount.include?(5) == true
    if numcnt.include?(4) == true
      ivk = true
      windex << numcnt.index{|x| x == 4}
    end
    if numcnt.include?(3) == true
      iiik = true
      windex << numcnt.index{|x| x == 3}
    end
    if numcnt.include?(2) == true
      paircount = 0
      15.times do |x|
        if numcnt[x] == 2
          paircount += 1
          windex << x.to_s
        end
      end
      if paircount == 2
        iip = true
      else
        ip = true
      end
      if iip == true && iiik == true
        iip = false
        iiik = false
        fh = true
      end
    end
    
     output = ""
     output << "Royal " if ryl == true
     output << "Straight " if straight == true
     output << "Full House of " if fh == true
     output << "4 of a Kind: " if ivk == true
     output << "3 of a Kind: " if iiik == true
     output << "Two Pair of " if iip == true
     output << "Pair of " if ip == true
     if fh == true || iip == true
       output << cardindextostr(windex[0])
       output << " and "
       output << cardindextostr(windex[1])
     else
       output << cardindextostr(windex.join)
     end
     output << "Flush" if flush == true
     output << "'s, with a " if output.length > 2
     output << "High Card: " if royal == false
     output << cardindextostr(hc)
     "#{nums},#{suits}--#{numcnt},#{suitcount}"
     "#{output}"
  end
  helper_method :readhand

  def cardindextostr(highcard)
    if highcard == "1"
      hc = "Ace"
    elsif highcard == "11"
      hc = "Jack"
    elsif highcard == "12"
      hc = "Queen"
    elsif highcard == "13"
      hc = "King"
    else
      hc = highcard
    end
    return hc
  end

  def destroy
  end
end
