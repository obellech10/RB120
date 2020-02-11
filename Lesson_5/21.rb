require 'pry'
system 'clear'

class Participant
  attr_accessor :name, :hand, :hand_total

  def initialize
    @hand = nil
    @hand_total = 0
  end

  def display_hand
    hand.each do |card|
      puts "#{card.value} of #{card.suit}"
    end
    puts "\nTotal Value: #{hand_total}"
  end

  def calc_hand_total
    hand.each do |card|
      self.hand_total += card.value
    end
  end

  def hit(deck)
    card = deck.cards.shift
    @hand << card
    self.hand_total += card.value
  end

  def busted?
    hand_total > 21
  end
end

class Dealer < Participant
  def showing
    puts "\nThe dealer is showing:"
    card = hand.last
    puts "#{card.value} of #{card.suit}"
  end

  def decision(deck)
    if hand_total < 17
      hit(deck)
    else
      "stay"
    end
  end

  def display_hand
    puts "\nThe dealer has the following cards:"
    super
  end
end

class Player < Participant
  def display_hand
    puts "\nYou have the following cards:"
    super
  end

  def decision
    puts "\nDo you want to hit(H) or stay(S)? "
    decision = nil
    loop do
      decision = gets.chomp.downcase
      break if ["hit", "stay", "h", "s"].include?(decision)
      puts "Sorry, that's an invalid choice. Try again..."
    end
    decision
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    reset_and_shuffle
  end

  def deal(num_of_cards)
    cards.shift(num_of_cards)
  end

  def reset_and_shuffle
    # DECK.each do |card, values|
    # @deck << Card.new(card, values)
    (Card::CARDS).each do |card, values|
      @cards << Card.new(card, values)
    end
    # @deck.shuffle!
    @cards.shuffle!
  end

end

class Card
  CARDS = {
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

  attr_accessor :card, :value, :suit

  def initialize(card, values)
    @card = card
    @value = values[0]
    @suit = values[1]
  end

  def total_hand_value
  end
end

class Game
  attr_accessor :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    display_welcome_message
    start_hand
    display_goodbye_message
  end

  private

  def start_hand
    loop do
      deal_cards
      player_turn
      dealer_turn if !@player.busted?
      clear_screen
      display_results
      break unless play_again?
      reset_hands
      clear_screen
    end
  end

  def player_turn
    @player.calc_hand_total
    loop do
      @player.display_hand
      @dealer.showing
      break if @player.decision.start_with?("s")
      @player.hit(deck)
      break if @player.busted?
      clear_screen
    end
  end

  def dealer_turn
    clear_screen
    @dealer.calc_hand_total
    loop do
      @player.display_hand
      @dealer.display_hand
      break if @dealer.decision(deck) == "stay"
      break if @dealer.busted?
      clear_screen
    end
  end

  def display_welcome_message
    puts "Welcome to Twenty-One\n\n"
    puts "The goal is to try to get as close to 21 as possible," \
    " without going over."
    puts "If you go over 21, it's a 'bust' and you lose."
  end

  def deal_cards
    @player.hand = @deck.deal(2)
    @dealer.hand = @deck.deal(2)
  end

  def display_results
    if @player.busted?
      @player.display_hand
      puts "\nYou busted. Dealer wins!"
    elsif @dealer.busted?
      @dealer.display_hand
      puts "\nDealer busted. You win!"
    else
      display_final_hands
      determine_winner
    end
  end

  def determine_winner
    if @player.hand_total > @dealer.hand_total
      puts "\nYou win!"
    elsif @player.hand_total < @dealer.hand_total
      puts "\nDealer wins!"
    else
      puts "\nIt's a push."
    end
  end

  def display_final_hands
    @player.display_hand
    @dealer.display_hand
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (Y)es or (N)o"
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      puts "\nSorry, must be yes or no"
    end

    answer.start_with?("y")
  end

  def reset_hands
    @player.hand_total = 0
    @dealer.hand_total = 0
  end

  def clear_screen
    system 'clear' || 'clr'
  end

  def display_goodbye_message
    puts "\nThanks for playing Twenty-One!"
  end
end

Game.new.play