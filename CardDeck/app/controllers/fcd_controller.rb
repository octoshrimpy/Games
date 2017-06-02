class FcdController < ApplicationController
before_action 
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

  def deck_left
     return @deck.length
  end
  helper_method :deckleft

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
    if numcnt.include?(4) == true
      ivk = true
      windex << numcnt.index{|x| x == 4}.to_s
    end
    if numcnt.include?(3) == true
      iiik = true
      windex << numcnt.index{|x| x == 3}.to_s
    end
    if numcnt.include?(2) == true
      paircount = 0
      14.times do |x|
        if numcnt[x] >= 2
          windex << x.to_s
          paircount += 1
        end
      end
      if paircount >= 2
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
    # Sort: 2-9, AJKQT, CDHS
    # 23456789AJKQT
    # 0123456789012
    # AKQJT98765432
    numcnt.shift
    temp = numcnt.reverse.rotate(-1).unshift(0).index{|x| x != 0}
    hc = case temp
    when 1 then 1
    when 2 then 13
    when 3 then 12
    when 4 then 11
    when 5 then 10
    when 6 then 9
    when 7 then 8
    when 8 then 7
    when 9 then 6
    when 10 then 5
    when 11 then 4
    when 12 then 3
    when 13 then 2
    end
    #1#@!098765432
    #AKQJT98765432
    #1234567890!@#
    #
    #h = numcnt.map(&:to_s)
    #hc = "0"<<h[8]<<h[10]<<h[11]<<h[9]<<h[12]<<h[7]<<h[6]<<h[5]<<h[4]<<h[3]<<h[2]<<h[1]<<h[0]
     output = ""
     output << "Royal " if ryl == nums
     output << "Straight " if str.include?(nums) == true
     output << "Full House of " if fh == true
     output << "Four of a Kind: " if ivk == true
     output << "Three of a Kind: " if iiik == true
     output << "Two Pair of " if iip == true
     output << "Pair of " if ip == true
     if fh == true || iip == true
       output << cardindextostr(windex[0])
       output << "'s and "
       output << cardindextostr(windex[1])
     else
       output << cardindextostr(windex.join)
     end
     output << "Flush " if suitcount.include?(5) == true
     output << "'s, with a " if output.length > 2 &&
                                fh != true &&
                                str.include?(nums) == false &&
                                ryl != nums
     output << "High Card: " if ryl != nums
     output << cardindextostr(hc.to_s)
     #sf,4k,fh,
     "#{nums},#{suits}--#{numcnt},#{suitcount}"
     "#{nums}, #{output}"
    #  "#{numcnt},--#{numcnt.reverse.index{|x| x != 0}}"
    # "#{hc},#{temp}"
    # "#{hc.to_i}"
  end
  helper_method :readhand

  def cardindextostr(highcard)
    if highcard == "1"
      translate = "Ace"
    elsif highcard == "11"
      translate = "Jack"
    elsif highcard == "12"
      translate = "Queen"
    elsif highcard == "13"
      translate = "King"
    else
      translate = highcard
    end
    return translate
  end

  def flipping

  end

  def destroy
  end
end
