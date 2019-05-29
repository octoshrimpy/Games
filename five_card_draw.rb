class Card
  attr_accessor :suit, :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    case rank.to_s
    when "A" then 14
    when "K" then 13
    when "Q" then 12
    when "J" then 11
    when "T" then 10
    else rank.to_i
    end
  end

  def to_s
    "#{@rank}#{@suit}"
  end
end

class Deck
  attr_accessor :deck_count, :cards

  def initialize(deck_count=1, opts={})
    @deck_count = deck_count
    shuffle
  end

  def draw
    @cards.shift
  end

  def remaining
    @cards.count
  end

  def to_s
    "[#{@cards.map(&:to_s).join('|')}]"
  end

  def shuffle(opts={})
    @cards = []
    @deck_count.times do |deck|
      possible_ranks.each { |rank| possible_suits.each { |suit| @cards << Card.new(rank, suit) } }
    end
    @cards.shuffle!
  end

  private

  def possible_suits
    %w(D H S C)
  end

  def possible_ranks
    ("2".."9").to_a + %w(T J Q K A)
  end
end

class Hand
  attr_accessor :cards, :max_cards

  def draw(deck)
    @cards << deck.draw
  end
end

class Poker
  def value_of_hand(cards)
    cards.sort_by! { |c| -c.value }

    # Each level of hand should return the cards ordered by value that participate in the hand
    pairs = cards_by_count(cards, 2)
    trips = cards_by_count(cards, 3)
    quads = cards_by_count(cards, 4)
    quints = cards_by_count(cards, 5)

    two_pair = pairs.count == 4 ? pairs : []
    flush = cards.map(&:suit).uniq.count == 1 ? cards : []
    full_house = (pairs.count > 0 && trips.count > 0) ? [trips + pairs].flatten : []
    straight = valid_straights(cards)
    straight_flush = straight & flush

    types_of_hands = {
      straight_flush: straight_flush,
      four_of_a_kind: quads,
      full_house: full_house,
      flush: flush,
      straight: straight,
      three_of_a_kind: trips,
      two_pair: two_pair,
      pairs: pairs,
      cards: cards
    }
  end

  def cards_by_count(cards, count)
    ranks = cards.map(&:rank)
    cards.select { |c| ranks.count(c.rank) >= count }
  end

  def valid_straights(cards)
    vals = cards.map(&:value)
    ([14] + (2..14).to_a).reverse.join.include?(vals.join)
  end
end

# deck = @cards = []
#
# @cards = deck.clone
#
# def build_each_hand(how_many_players, how_many_cards)
#   hands = {}
#   how_many_cards.times do |card|
#     how_many_players.times do |player|
#       hands["Player #{player + 1}"] ||= []
#       hands["Player #{player + 1}"] << @cards.delete(@cards.sample)
#     end
#   end
#   hands
# end
#
# def split_hand_to_values(hand)
#   values = []
#   suits = []
#   hand.each do |card|
#     value_suit = card.split('')
#     values << value_suit[0]
#     suits << value_suit[1]
#   end
#   [cards_to_numerical_value(values), suits]
# end
#
# def cards_to_numerical_value(values)
#   new_values = []
#   values.each do |value|
#     new_values << case value
#     when "T" then 10
#     when "J" then 11
#     when "Q" then 12
#     when "K" then 13
#     when "A" then 14
#     else value.to_i
#     end
#   end
#   new_values
# end
#
# def check_types_of_hands(values_and_suits)
#   values = values_and_suits.first
#   suits = values_and_suits.last
#
#   cards = values.sort
#   pairs = how_many_of_each_value(values, 2)
#   trips = how_many_of_each_value(values, 3)
#   quads = how_many_of_each_value(values, 4)
#
#   full_house = (pairs.count > 0 && trips.count > 0) ? trips : false
#   two_pair = pairs.count > 1 ? pairs : false
#
#   pairs = pairs.length == 0 ? false : pairs
#   trips = trips.length == 0 ? false : trips
#   quads = quads.length == 0 ? false : quads
#
#   types_of_hands = {
#     cards: cards, # Array of cards
#     pairs: pairs, # Array or False
#     two_pair: two_pair, # Array or False
#     three_of_a_kind: trips, # Array or False -- ?
#     is_straight: check_for_straight(values), # Array or False
#     is_flush: suits.uniq.length == 1 ? [cards.last] : false, # Array or False
#     is_full_house: full_house, # [1] or false
#     four_of_a_kind: quads # Array or False -- ?
#   }
# end
#
# def how_many_of_each_value(values, find_by_amount)
#   values.each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }.to_a.map { |x| x[0] if x[1] == find_by_amount }.compact
# end
#
# def check_for_straight(values)
#   ([14] + (2..14).to_a).join.include?(values.sort.join) ? values.sort.last : false # This is so sketchy and hacky, but it works....
# end
#
# def get_hand_values(players_hands)
#   hand_values = []
#   players_hands.each do |single_player|
#     hand_values << [single_player.first, check_types_of_hands(split_hand_to_values(single_player.last))]
#   end
#   hand_values
# end
#
# def compare_all_hands(hand_values)
#   players_left = hand_values
#   hand_values.first.last.keys.reverse.each do |key|
#     players_left = compare(key, players_left) if players_left.count > 1
#   end
#   players_left.first
# end
#
# def compare(type_of_hand, players)
#   values = []
#   challengers = []
#   passing_players = []
#   winning = 0
#
#   players.each { |player| challengers << player if player.last[type_of_hand] != false }
#   if challengers.count > 0
#     challengers.each do |challenger|
#       winning = challenger.last[type_of_hand].sort.last if challenger.last[type_of_hand].sort.last > winning
#     end
#   end
#   players.each do |player|
#     if winning == 0
#       passing_players << player
#     else
#       passing_players << player if player.last[type_of_hand].sort.last == winning if player.last[type_of_hand] != false
#     end
#   end
#   # if cards, validate each value
#   return passing_players
# end
#
# how_many_players = 4
# how_many_cards = 5
# players_hands = build_each_hand(how_many_players, how_many_cards)
# winner = compare_all_hands(get_hand_values(players_hands))
# players_hands.map { |player| puts player.join(", ") }
# puts "Winner: #{winner.first} \n#{players_hands[winner.first]}"
