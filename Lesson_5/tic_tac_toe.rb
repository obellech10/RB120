require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(square, marker)
    @squares[square].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def winning_marker
    WINNING_LINES.each do |line|
      next if empty_line?(line)

      line_values = values(line)
      return line_values.first if line_values.uniq.count == 1
    end
    nil
  end

  private

  attr_reader :squares

  def empty_line?(line)
    squares = square_values(line)
    squares.collect(&:marker).all? { |marker| marker == ' ' }
  end

  def values(line)
    squares = square_values(line)
    squares.collect(&:marker)
  end

  def square_values(line)
    @squares.values_at(*line)
  end
end

class Square
  INITIAL_MARKER = ' '.freeze
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'.freeze
  COMPUTER_MARKER = 'O'.freeze
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = human
  end

  def play
    display_welcome_message

    loop do
      display_board
      start_game
      display_result
      break unless play_again?
      reset_game
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    clear
    puts 'Welcome to Tic Tac Toe!'
    puts ''
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ''
    board.draw
    puts ''
  end

  def start_game
    loop do
      current_player_moves
      break if game_over?
      clear_screen_and_display_board
    end
  end

  def current_player_moves
    case @current_player.marker
    when 'X'
      human_moves
      @current_player = computer
    when 'O'
      computer_moves
      @current_player = human
    end
  end

  def human_moves
    puts "Chose a square (#{empty_squares.join(", ")})"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    board[empty_squares.sample] = computer.marker
  end

  def game_over?
    board.someone_won? || board.full?
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_result
    clear
    display_board
    if board.winning_marker == HUMAN_MARKER
      puts "You won!"
    elsif board.winning_marker == COMPUTER_MARKER
      puts "Computer won!"
    else
      puts "It's a tie."
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

  def reset_game
    board.reset
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
    return if @current_player == human
    puts "The computer will now play first. Hit enter when ready..."
    _ = gets.chomp
  end

  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe. Goodbye!"
  end

  def clear
    system('clear') || system('clr')
  end

  def empty_squares
    board.unmarked_keys
  end
end

TTTGame.new.play
