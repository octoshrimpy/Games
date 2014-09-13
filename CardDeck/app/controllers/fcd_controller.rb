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
     ha
     hk
     hq
     
     sf = ["", "", "", "", ""]
     ivk = ["", "", "", "", ""]
     fh = ["", "", "", "", ""]
     fs = ["", "", "", "", ""]
     str = ["", "", "", "", ""]
     iiik = ["", "", "", "", ""]
     iip = ["", "", "", "", ""]
     ip = ["", "", "", "", ""]


     if a =
  end
  helper_method :readhand

  def destroy
  end
end
