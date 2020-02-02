require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end
end

class Rock < Move
  def >(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def <(other_move)
    other_move.paper? || other_move.spock?
  end
end

class Paper < Move
  def >(other_move)
    other_move.rock? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.lizard?
  end
end

class Scissors < Move
  def >(other_move)
    other_move.paper? || other_move.lizard?
  end

  def <(other_move)
    other_move.rock? || other_move.spock?
  end
end

class Lizard < Move
  def >(other_move)
    other_move.paper? || other_move.spock?
  end

  def <(other_move)
    other_move.rock? || other_move.scissors?
  end
end

class Spock < Move
  def >(other_move)
    other_move.rock? || other_move.scissors?
  end

  def <(other_move)
    other_move.lizard? || other_move.paper?
  end
end

class Score
  attr_accessor :points

  def initialize
    @points = 0
  end

  def add_point
    @points += 1
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    @score = Score.new
    @move_history = []
  end

  def create_moveclass(value)
    case value
    when 'rock'
      Rock.new(value)
    when 'paper'
      Paper.new(value)
    when 'scissors'
      Scissors.new(value)
    when 'lizard'
      Lizard.new(value)
    when 'spock'
      Spock.new(value)
    end
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose between #{Move::VALUES}"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice"
    end
    self.move = create_moveclass(choice)
    @move_history << choice
  end

  def win
    score.add_point
  end
end

module Personality
  def computer_moves(name)
    case name
    when 'R2D2'
      r2d2_moves
    when 'Hal'
      hal_moves
    when 'Chappie'
      random_moves
    when 'Sonny'
      random_moves
    when 'Number 5'
      number_5_moves
    end
  end

  def r2d2_moves
    'rock'
  end

  def hal_moves
    hal_choices = ['lizard', 'spock']
    hal_choices.fill('scissors', 2, 5)
    hal_choices.fill('rock', 7, 3)
    hal_choices.sample
  end

  def number_5_moves
    johnny_choices = []
    johnny_choices.fill('lizard', 0, 5)
    johnny_choices.fill('spock', 5, 5)
    johnny_choices.sample
  end

  def random_moves
    Move::VALUES.sample
  end
end

class Computer < Player
  include Personality

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    choice = computer_moves(name)
    self.move = create_moveclass(choice)
    @move_history << choice
  end

  def win
    score.add_point
  end
end

# Game Orchestration Engine
class RPSGame
  WINNING_SCORE = 10
  attr_accessor :human, :computer, :score, :ties

  def initialize
    @human = Human.new
    @computer = Computer.new
    @ties = 0
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def display_moves
    puts
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
    puts
  end

  def display_winner
    if @human.move > @computer.move
      puts "#{@human.name} won!"
      @human.win
    elsif @human.move < @computer.move
      puts "#{@computer.name} won!"
      @computer.win
    else
      puts "It's a tie!"
      @ties += 1
    end
    display_score
  end

  def display_score
    puts "The score is:"
    puts "=> #{human.name}: #{human.score.points}"
    puts "=> #{computer.name}: #{computer.score.points}"
    puts "=> Ties: #{@ties}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def game_over?
    (human.score.points == WINNING_SCORE) ||
      (computer.score.points == WINNING_SCORE)
  end

  def reset_game
    human.score.points = 0
    computer.score.points = 0
    @ties = 0
    human.move_history.clear
    computer.move_history.clear
  end

  def display_history
    puts
    puts "Here are the previous moves made by #{human.name}:"
    puts human.move_history.to_s
    puts "-" * 40
    puts "Here are the previous moves made by #{computer.name}:"
    puts computer.move_history.to_s
    puts
  end

  def next_round
    puts "Hit enter to start the next round."
    gets.chomp
    clear
  end

  def clear
    system('clear') || system('cls')
  end

  def play
    display_welcome_message
    @human.set_name
    @computer.set_name
    loop do
      start_match
      play_again? ? reset_game : break
      clear
    end
    display_goodbye_message
  end

  def start_match
    loop do
      display_history unless @human.move_history.empty?
      @human.choose
      @computer.choose
      display_moves
      display_winner
      break if game_over?
      next_round
    end
  end
end

RPSGame.new.play
