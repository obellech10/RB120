require 'pry'
system 'clear'

class Participant
  attr_accessor :cards, :card_total

  def initialize
    @cards = nil
    @card_total = 0
  end

  def hand_value
    cards.each do |card|
      @card_total += Card::CARD_VALUES[card.to_sym].first
    end
    # binding.pry
  end

  def hit(deck)
    card = deck.cards.shift
    cards << card
    # binding.pry
    @card_total += Card::CARD_VALUES[card.to_sym].first
    # will need to increment @total after hit
  end

  def busted?
    self.card_total > 21
    # binding.pry
  end

  def reset_cards
    cards.clear
    self.card_total = 0
  end
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Player < Participant
  # def initialize
  #   # what would the "data" or "states" of a Player object entail?
  #   # maybe cards? a name?
  # end

  # def hit
  # end

  def stay
  end

  # def busted?
  # end

  # def total
  #   # definitely looks like we need to know about "cards" to produce some total
  # end
end

class Dealer < Participant
  # def initialize
  #   # seems like very similar to Player... do we even need this?
  # end

  def deal
    # does the dealer or the deck deal?
  end

  # def hit
  # end

  def stay
  end

  # def busted?
  # end

  # def total
  # end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = (Card::CARD_VALUES).keys.map(&:to_s).shuffle!
    # binding.pry
    # @cards = Card.new
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
  end

  def deal
    # does the dealer or the deck deal?
  end

  def reshuffle
    # needed when starting a new game or after deck has been dealt to minimum value
  end
end

class Card
  # CARD_VALUES = {
  #   H2: 2, H3: 3, H4: 4, H5: 5, H6: 6, H7: 7, H8: 8, H9: 9, H10: 10, HJ: 10,
  #   HQ: 10, HK: 10, HA: 11, C2: 2, C3: 3, C4: 4, C5: 5, C6: 6, C7: 7, C8: 8,
  #   C9: 9, C10: 10, CJ: 10, CQ: 10, CK: 10, CA: 11, D2: 2, D3: 3, D4: 4, D5: 5,
  #   D6: 6, D7: 7, D8: 8, D9: 9, D10: 10, DJ: 10, DQ: 10, DK: 10, DA: 11, S2: 2,
  #   S3: 3, S4: 4, S5: 5, S6: 6, S7: 7, S8: 8, S9: 9, S10: 10, SJ: 10, SQ: 10,
  #   SK: 10, SA: 11
  # }

  CARD_VALUES = {
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

  def initialize
    # what are the "states" of a card?
    # card_values
    # binding.pry
    # @value, @suit
  end

  # def card_description(card)
  #   num, suit = CARD_VALUES[card.to_sym]
  #   puts "#{num} of #{suit}"
  #   # binding.pry
  # end

  # def card_values
  #   CARD_VALUES.each do |key, details|
  #     @name = key
  #     @value = details[0]
  #     @suit = details[1]
  #     # value[]
  #   end
  #   binding.pry
  #   # puts "#{num} of #{suit}"
  #   # binding.pry
  # end
end

class Game
  # include Card

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    # display_welcome_message

      loop do
        deal_cards
        show_initial_cards
        player_turn
        dealer_turn if !@player.busted?
        show_result
        break unless play_again?
        reset_hand
      end

    # display_goodbye_message
  end

  private

  def deal_cards
    @player.cards = @deck.cards.shift(2)
    @dealer.cards = @deck.cards.shift(2)
    @player.hand_value
    @dealer.hand_value
  end

  def show_initial_cards
    player_cards
    dealer_showing
  end

  def player_cards
    puts "You have the following cards:"
    @player.cards.each do |card|
      num, suit = Card::CARD_VALUES[card.to_sym]
      puts "#{num} of #{suit}"
    end
    puts "Total value: #{@player.card_total}"
    puts
  end

  def dealer_showing
    puts "The dealer is showing:"
    face_up_card = @dealer.cards.first.to_sym
    num, suit = Card::CARD_VALUES[face_up_card]
    puts "#{num} of #{suit}"
    puts ''
  end

  def dealer_cards
    puts "The dealer has the following cards:"
    @dealer.cards.each do |card|
      num, suit = Card::CARD_VALUES[card.to_sym]
      puts "#{num} of #{suit}"
    end
    puts "Total value: #{@dealer.card_total}"
    puts
  end

  def player_turn
    loop do
      decision = player_decision
      @player.hit(@deck) if decision.start_with?("h")
      break if decision.start_with?("s")
      player_cards
      break if @player.busted?
    end
  end

  def player_decision
    puts "Do you want to hit(H) or stay(S)? "
    decision = nil
    loop do
      decision = gets.chomp.downcase
      break if ["hit", "stay", "h", "s"].include?(decision)
      puts "Sorry, that's an invalid choice. Try again..."
    end
    decision
  end

  def dealer_turn
    loop do
      dealer_cards
      if @dealer.card_total < 17
        @dealer.hit(@deck)
      else
        break
      end
    end
  end

  def show_result
    if @player.busted?
      puts "You busted. Dealer wins!"
    elsif @dealer.busted?
      puts "Dealer busted. You win!"
    else
      determine_winner
    end
  end

  def determine_winner
    if @player.card_total > @dealer.card_total
      puts "You win!"
    elsif @player.card_total < @dealer.card_total
      puts "Dealer wins!"
    else
      puts "It's a push."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y,n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset_hand
    @player.reset_cards
    @dealer.reset_cards
  end
end

Game.new.play
