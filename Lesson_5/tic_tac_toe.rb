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

  def [](square)
    @squares[square]
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

  def square_to_play(computer, human)
    square = nil
    square = vulnerable_square(computer) if !square
    square = vulnerable_square(human) if !square
    square
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

  def vulnerable_square(player)
    square_to_fill = nil
    WINNING_LINES.each do |line|
      if values(line).count(player.marker) == 2
        line.each do |square|
          if @squares[square].marker == Square::INITIAL_MARKER
            square_to_fill = square
          end
        end
      end
    end
    square_to_fill
  end

  def square_values(line)
    @squares.values_at(*line)
  end
end

class Square
  INITIAL_MARKER = ' '
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
  attr_reader :marker, :type
  attr_accessor :name, :wins, :marker

  def initialize(type)
    @wins = 0
    @name = nil
    @type = type
  end

  def update_score
    @wins += 1
  end

  def assign(marker)
    @marker = marker
  end
end

class Computer < Player
  def create_name
    self.name = ["Watson", "Optimus Prime", "Kitt", "C3PO"].sample
  end

  def moves(board, human)
    square = board.square_to_play(self, human)

    if square
      board[square] = self.marker
    elsif board[5].marker == Square::INITIAL_MARKER
      board[5] = self.marker
    else
      board[board.unmarked_keys.sample] = self.marker
    end
  end

end

class Human < Player
  def enter_name
    puts "What is your name?"
    name = nil
    loop do
      name = gets.chomp.capitalize
      break if name != ' '
      puts "Sorry that's not a valid name."
    end
    self.name = name
  end

  def choose_marker
    puts "Choose which marker you'd like to use: (X or O)"
    marker = nil
    loop do
      marker = gets.chomp.upcase
      break if marker == "X" || marker == "O"
      puts "Sorry that's not a valid marker"
    end
    marker
  end

  def moves(board)
    puts "Choose a square: #{joinor(board.unmarked_keys)}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = self.marker
  end

  private

  def joinor(arr, delimiter = ', ', join_word = 'or')
    case arr.count
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{join_word} ")
    else
      arr[-1] = "#{join_word} #{arr.last}"
      arr.join(delimiter)
    end
  end
end

class TTTGame
  WINNING_SCORE = 5
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new("human")
    @computer = Computer.new("computer")
    @current_player = human
    @ties = 0
  end

  def play
    setup_match

    loop do
      start_match
      break unless play_again?
      reset_board
      reset_score
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def setup_match
    display_welcome_message
    determine_player_names
    marker = human.choose_marker
    assign_player(marker)
  end

  def display_welcome_message
    clear
    puts 'Welcome to Tic Tac Toe!'
    puts "The first player to win #{WINNING_SCORE} games wins the match!"
    puts ''
  end

  def determine_player_names
    human.enter_name
    computer.create_name
    puts ''
    puts "Hello, today you will be playing against #{computer.name}."
    puts ''
  end

  def assign_player(marker)
    case marker
    when "X"
      human.assign(marker)
      computer.assign("O")
    when "O"
      human.assign(marker)
      computer.assign("X")
    end
  end

  def start_match
    loop do
      display_board
      start_game
      display_game_result
      display_score
      break if match_over?
      display_next_game_message
      reset_board
    end
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{computer.marker}."
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
    case @current_player
    when human
      human.moves(board)
      @current_player = computer
    when computer
      computer.moves(board, human)
      @current_player = human
    end
  end

  def game_over?
    board.someone_won? || board.full?
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_game_result
    clear
    display_board
    if board.winning_marker == human.marker
      puts "You won!"
      human.update_score
    elsif board.winning_marker == computer.marker
      puts "#{computer.name} won!"
      computer.update_score
    else
      puts "It's a tie."
      @ties += 1
    end
  end

  def display_score
    puts "The score is:"
    puts "#{human.name}: #{human.wins}"
    puts "#{computer.name}: #{computer.wins}"
    puts "Ties: #{@ties}"
    puts ''
  end

  def match_over?
    computer.wins == WINNING_SCORE || human.wins == WINNING_SCORE
  end

  def display_next_game_message
    puts "#{@current_player.name} will now play first. Hit enter when ready..."
    _ = gets.chomp
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

  def reset_board
    board.reset
    clear
  end

  def reset_score
    human.wins = 0
    computer.wins = 0
    @ties = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
    display_next_game_message
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
