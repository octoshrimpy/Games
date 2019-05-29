class Dictionary
  class << self

    def lookup(word)
      word_presence[word.downcase] || false
    end

    def words_at_length(n)
      word_presence.keys.select { |word| word.length == n.to_i }
    end

    def word_presence
      @@_dictionary ||= begin
        words = {}
        File.open("/usr/share/dict/words") do |file|
          file.each do |line|
            words[line.strip.downcase] = true
          end
        end
        words
      end
    end
  end
end

numpad = {
  "1": "",
  "2": "abc",
  "3": "def",
  "4": "ghi",
  "5": "jkl",
  "6": "mno",
  "7": "pqrs",
  "8": "tuv",
  "9": "wxyz",
  "0": ""
}

frequency_trigraphs = "the and tha ent ion tio for nde has nce edt tis oft sth men".downcase.split(" ")
frequency_bigraphs = "TH HE IN ER AN RE ES ON ST NT EN AT ED ND TO OR EA TI AR TE NG AL IT AS IS HA ET SE OU OF LE SA VE RO RA RI HI NE ME DE CO TA EC SI LL SO NA LI LA EL MA DI IC RT NS RS IO OM CH OT CA CE HO BE TT FO TS SS NO EE EM AC IL DA NI UR WA SH EI AM TR DT US LO PE UN NC WI UT AD EW OW GE EP AI LY OL FT OS EO EF PR WE DO MO ID IE MI PA FI PO CT WH IR AY GA SC KE EV SP IM OP DS LD UL OO SU IA GH PL EB IG VI IV WO YO RD TW BA AG RY AB LS SW AP FE TU CI FA HT FR AV EG GO BO BU TY MP OC OD EH YS EY RM OV GT YA CK GI RN GR RC BL LT YT OA YE OB DB FF SF RR DU KI UC IF AF DR CL EX SM PI SB CR TL OI RU UP BY TC NN AK SL NF UE DW AU PP UG RL RG BR CU UA DH RK YI LU UM BI NY NW QU OG SN MB VA DF DD MS GS AW NH PU HR SD TB PT NM DC GU TM MU NU MM NL EU WN NB RP DM SR UD UI RF OK YW TF IP RW RB OH KS DP FU YC TP MT DL NK CC UB RH NP JU FL DN KA PH HU JO LF YB RV OE IB IK YP GL LP YM LB HS DG GN EK NR PS TD LC SK YF YH VO AH DY LM SY NV YD FS SG YR YL WS MY OY KN IZ XP LW TN KO AA JA ZE FC GW TG XT FH LR JE YN GG GF EQ HY KT HC BS HW HN CS HM NJ HH WT GC LH EJ FM DV LV WR GP FP GB GM HL LK CY MC YG XI HB FW GY HP MW PM ZA LG IW XA FB SV GD IX AJ KL HF HD AE SQ DJ FY AZ LN AO FD KW MF MH SJ UF TV XC YU BB WW OJ AX MR WL XE KH OX UO ZI FG IH TK II IU TJ MN WY KY KF FN UY PW DK RJ UK KR KU WM KM MD ML EZ KB WC WD HG BT ZO KC PF YV PC PY WB YK CP YJ KP PB CD JI UW UH WF YY WP BC AQ CB IQ CM MG DQ BJ TZ KD PD FJ CF NZ CW FV VY FK OZ ZZ IJ LJ NQ UV XO PG HK KG VS HV BM HJ CN GV CG WU GJ XH GK TQ CQ RQ BH XS UZ WK XU UX BD BW WG MV MJ PN XM OQ BV XW KK BP ZU RZ XF MK ZH BN ZY HQ WJ IY DZ VR ZS XY CV XB XR UJ YQ VD PK VU JR ZL SZ YZ LQ KJ BF NX QA QI KV ZW WV UU VT VP XD GQ XL VC CZ LZ ZT WZ SX ZB VL PV FQ PJ ZM VW CJ ZC BG JS XG RX HZ XX VM XN QW JP VN ZD ZR FZ XV ZP VH VB ZF GZ TX VF DX QB BK ZG VG JC ZK ZN UQ JM VV JD MQ JH QS JT JB FX PQ MZ YX QT WQ JJ JW LX GX JN ZV MX JK KQ XK JF QM QH JL JG VK VJ KZ QC XJ PZ QL QO JV QF QD BZ HX ZJ PX QP QE QR ZQ JY BQ XQ CX KX WX QY QV QN VX BX JZ VZ QG QQ ZX XZ QK VQ QJ QX JX JQ QZ".downcase.split(" ")
frequency_initial_letters = "T O A W B C D S F M R H I Y E G L N P U J K".downcase.split(" ")
frequency_final_letters = "E S T D N R Y F L O G H A K M P U W".downcase.split(" ")

selected_combo = numpad
input = ARGV[0]
combos = []

# Generate combos
input.to_s.split("").each do |input_num|
  possible_chars = selected_combo[input_num.to_s.to_sym].to_s.split("").map { |c| c.empty? ? nil : c }.compact

  if combos.empty?
    combos = possible_chars
  else
    combos = possible_chars.map do |possible_char|
      combos.map { |combo|
        "#{combo}#{possible_char}"}
    end.flatten
  end
end

# Output based on frequency analysis
combos = combos.sort do |b, a|
  # If one word is in the dictionary, return that first
  a_dict = Dictionary.lookup(a)
  b_dict = Dictionary.lookup(b)

  next 1 if a_dict && !b_dict
  next -1 if b_dict && !a_dict

  # Match based on trigraphs
  a_trigraph_idx = frequency_trigraphs.index(frequency_trigraphs.find { |tg| a.include?(tg) })
  b_trigraph_idx = frequency_trigraphs.index(frequency_trigraphs.find { |tg| b.include?(tg) })

  next a_trigraph_idx <=> b_trigraph_idx if !(a_trigraph_idx.nil? || b_trigraph_idx.nil?)
  next 1 if !a_trigraph_idx.nil?
  next -1 if !b_trigraph_idx.nil?

  # Match based on bigraphs
  a_bigraph_idx = frequency_bigraphs.index(frequency_bigraphs.find { |tg| a.include?(tg) })
  b_bigraph_idx = frequency_bigraphs.index(frequency_bigraphs.find { |tg| b.include?(tg) })

  next a_bigraph_idx <=> b_bigraph_idx if !(a_bigraph_idx.nil? || b_bigraph_idx.nil?)
  next 1 if !a_bigraph_idx.nil?
  next -1 if !b_bigraph_idx.nil?

  # Match based on initial letter frequency
  a_initial_idx = frequency_initial_letters.index(a[0])
  b_initial_idx = frequency_initial_letters.index(b[0])

  next a_initial_idx <=> b_initial_idx if !(a_initial_idx.nil? || b_initial_idx.nil?)
  next 1 if !a_initial_idx.nil?
  next -1 if !b_initial_idx.nil?

  # Match based on last letter frequency
  a_final_idx = frequency_final_letters.index(a[-1])
  b_final_idx = frequency_final_letters.index(b[-1])

  next a_final_idx <=> b_final_idx if !(a_final_idx.nil? || b_final_idx.nil?)
  next 1 if !a_final_idx.nil?
  next -1 if !b_final_idx.nil?

  # Order alphabetically if nothing else matches
  a <=> b
end

puts combos.join(" ")
