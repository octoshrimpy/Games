deck = @cards = []
( (2..9).to_a + %w(T J Q K A) ).each { |value| %w(D H S C).each { |suit| deck << value.to_s + suit } }
@cards = deck.clone

def build_each_hand(how_many_players, how_many_cards)
  hands = {}
  how_many_cards.times do |card|
    how_many_players.times do |player|
      hands["Player #{player + 1}"] ||= []
      hands["Player #{player + 1}"] << @cards.delete(@cards.sample)
    end
  end
  hands
end

def split_hand_to_values(hand)
  values = []
  suits = []
  hand.each do |card|
    value_suit = card.split('')
    values << value_suit[0]
    suits << value_suit[1]
  end
  [cards_to_numerical_value(values), suits]
end

def cards_to_numerical_value(values)
  new_values = []
  values.each do |value|
    new_values << case value
    when "T" then 10
    when "J" then 11
    when "Q" then 12
    when "K" then 13
    when "A" then 14
    else value.to_i
    end
  end
  new_values
end

def check_types_of_hands(values_and_suits)
  values = values_and_suits.first
  suits = values_and_suits.last

  cards = values.sort
  pairs = how_many_of_each_value(values, 2)
  trips = how_many_of_each_value(values, 3)
  quads = how_many_of_each_value(values, 4)

  full_house = (pairs.count > 0 && trips.count > 0) ? trips : false
  two_pair = pairs.count > 1 ? pairs : false

  pairs = pairs.length == 0 ? false : pairs
  trips = trips.length == 0 ? false : trips
  quads = quads.length == 0 ? false : quads

  types_of_hands = {
    cards: cards, # Array of cards
    pairs: pairs, # Array or False
    two_pair: two_pair, # Array or False
    three_of_a_kind: trips, # Array or False -- ?
    is_straight: check_for_straight(values), # Array or False
    is_flush: suits.uniq.length == 1 ? [cards.last] : false, # Array or False
    is_full_house: full_house, # [1] or false
    four_of_a_kind: quads # Array or False -- ?
  }
end

def how_many_of_each_value(values, find_by_amount)
  values.each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }.to_a.map { |x| x[0] if x[1] == find_by_amount }.compact
end

def check_for_straight(values)
  ([14] + (2..14).to_a).join.include?(values.sort.join) ? values.sort.last : false # This is so sketchy and hacky, but it works....
end

def get_hand_values(players_hands)
  hand_values = []
  players_hands.each do |single_player|
    hand_values << [single_player.first, check_types_of_hands(split_hand_to_values(single_player.last))]
  end
  hand_values
end

def compare_all_hands(hand_values)
  players_left = hand_values
  hand_values.first.last.keys.reverse.each do |key|
    players_left = compare(key, players_left) if players_left.count > 1
  end
  players_left.first
end

def compare(type_of_hand, players)
  values = []
  challengers = []
  passing_players = []
  winning = 0

  players.each { |player| challengers << player if player.last[type_of_hand] != false }
  if challengers.count > 0
    challengers.each do |challenger|
      winning = challenger.last[type_of_hand].sort.last if challenger.last[type_of_hand].sort.last > winning
    end
  end
  players.each do |player|
    if winning == 0
      passing_players << player
    else
      passing_players << player if player.last[type_of_hand].sort.last == winning if player.last[type_of_hand] != false
    end
  end
  # if cards, validate each value
  return passing_players
end

how_many_players = 4
how_many_cards = 5
players_hands = build_each_hand(how_many_players, how_many_cards)
winner = compare_all_hands(get_hand_values(players_hands))
players_hands.map { |player| puts player.join(", ") }
puts "Winner: #{winner.first} \n#{players_hands[winner.first]}"
