require 'pry'
system 'clear'

class Participant
  attr_accessor :name, :hand, :hand_total

  def initialize
    @hand = []
    @hand_total = 0
  end

  def hit
  end

  def busted?
  end
end

class Dealer < Participant
  def hit
  end

  def deal
  end
end

class Player < Participant
  def hit
  end
end

class Deck
  DECK = {
    H2: [2, "Hearts"], H3: [3, "Hearts"], H4: [4, "Hearts"], H5: [5, "Hearts"],
    H6: [6, "Hearts"], H7: [7, "Hearts"], H8: [8, "Hearts"], H9: [9, "Hearts"],
    H10: [10, "Hearts"], HJ: [10, "Hearts"], HQ: [10, "Hearts"],
    HK: [10, "Hearts"], HA: [11, "Hearts"], C2: [2, "Clubs"], C3: [3, "Clubs"],
    C4: [4, "Clubs"], C5: [5, "Clubs"], C6: [6, "Clubs"], C7: [7, "Clubs"],
    C8: [8, "Clubs"], C9: [9, "Clubs"], C10: [10, "Clubs"], CJ: [10, "Clubs"],
    CQ: [10, "Clubs"], CK: [10, "Clubs"], CA: [11, "Clubs"],
    D2: [2, "Diamonds"], D3: [3, "Diamonds"], D4: [4, "Diamonds"],
    D5: [5, "Diamonds"], D6: [6, "Diamonds"], D7: [7, "Diamonds"],
    D8: [8, "Diamonds"], D9: [8, "Diamonds"], D10: [10, "Diamonds"],
    DJ: [10, "Diamonds"], DQ: [10, "Diamonds"], DK: [10, "Diamonds"],
    DA: [11, "Diamonds"], S2: [2, "Spades"], S3: [3, "Spades"],
    S4: [4, "Spades"], S5: [5, "Spades"], S6: [6, "Spades"], S7: [7, "Spades"],
    S8: [8, "Spades"], S9: [9, "Spades"], S10: [10, "Spades"],
    SJ: [10, "Spades"], SQ: [10, "Spades"], SK: [10, "Spades"],
    SA: [11, "Spades"]
  }
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def deal
  end

  def reset
  end

  def shuffle

  end
end

class Card
  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def total_hand_value
  end
end

class Game
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    display_welcome_message
    shuffle_deck

    loop do
      start_hand
    end

    display_goodbye_message
  end

  def start_hand
    loop do
      deal_cards
      player_turn
      dealer_turn
      determine_winner
      display_results
      break unless play_again?
    end
  end

  def player_turn
    loop do
      display_player_hand
      display_hand_total # can be included in display_player_hand
      display_dealers_top_card
      player_decision # hit or stay
      break if busted? || stay?
      clear_screen
    end
  end

  def dealer_turn
    loop do
      dealer_decision # hit or stay
      break if busted? || stay?
      # clear_screen if it makes sense
    end
  end
end

Game.new.play
