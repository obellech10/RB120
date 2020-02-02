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
  attr_accessor :move, :name, :score

  def initialize
    @score = Score.new
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
  end

  def win
    score.add_point
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = create_moveclass(Move::VALUES.sample)
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
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
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

  def reset_score
    human.score.points = 0
    computer.score.points = 0
    @ties = 0
  end

  def play
    display_welcome_message
    human.set_name
    computer.set_name
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        break if game_over?
      end
      play_again? ? reset_score : break
    end
    display_goodbye_message
  end
end

RPSGame.new.play
