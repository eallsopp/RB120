# frozen_string_literal: true
# movements of the game

class Move
  VALUES = %w[rock paper scissors lizard spock].freeze # moves for validation
  WINNERS = { 'rock' => %w[scissors lizard],
              'paper' => %w[spock rock],
              'scissors' => %w[paper lizard],
              'lizard' => %w[paper spock],
              'spock' => %w[rock scissors] }.freeze

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
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
# player information
class Player
  attr_accessor :move, :name, :move_history, :num_of_moves, :set_name
  attr_reader :value

  def initialize
    set_name
    @move_history = []
    @num_of_moves = 0
  end

  def track_history
    self.num_of_moves += 1
    self.move_history += ["Move #{num_of_moves}. #{move}"]
  end

  def moves
    self.move_history.to_s
  end

  def win?(other)
    Move::WINNERS[move.value].include?(other.move.value)
  end

  def to_s
    @move
  end
end
# human methods
class Human < Player
  def set_name
    n = ''
    loop do
      puts 'What is your name?'
      n = gets.chomp
      break unless n.empty?

      puts 'Sorry, must enter a value.'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, scissors, lizard or spock:'
      choice = gets.chomp
      break if Move::VALUES.include? choice

      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
  end
end
# computer methods
class Computer < Player
end
# computer name and personality
class R2D2 < Computer
  OPTIONS = %w[rock paper paper lizard scissors spock spock].freeze

  def set_name
    self.name = 'R2D2'
  end

  def choose
    self.move = Move.new(OPTIONS.sample)
  end
end
# computer name and personality
class WallE < Computer
  OPTIONS = %w[spock spock spock spock spock paper paper paper paper
               scissors scissors scissors lizard lizard rock].freeze

  def set_name
    self.name = 'Wall-E'
  end

  def choose
    self.move = Move.new(OPTIONS.sample)
  end
end
# computer name and personality
class C3PO < Computer
  OPTIONS = %w[scissors].freeze

  def set_name
    self.name = 'C3PO'
  end

  def choose
    self.move = Move.new(OPTIONS.sample)
  end
end
# Gameplay
class RPSGame
  attr_accessor :human, :computer, :human_score, :computer_score, :track_history, :moves

  def initialize
    @human = Human.new
    @computer = [WallE, C3PO, R2D2].sample.new
    @human_score = 0
    @computer_score = 0
  end

  def display_welcome_message
    system('clear')
    puts 'Welcome to Rock, Paper, Scissors, Lizard Spock!'
    puts '+----------------------------------------+'
    puts 'The first player to 10 wins is victorious!'
    puts '+----------------------------------------+'
  end

  def display_scoreboard
    puts '-----SCORES-----'
    puts "{#{human.name}: #{human_score} #{computer.name}: #{computer_score}}"
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors, Lizard, Spock...Goodbye!'
  end

  def choose
    human.choose
    computer.choose
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    return puts "#{human.name} won!" if human.win?(computer)
    return puts "#{computer.name} won!" if computer.win?(human)

    puts "It's a tie!"
  end

  def adjust_score
    self.human_score += 1 if human.win?(computer)
    self.computer_score += 1 if computer.win?(human)
  end

  def valid?(answer)
    return true if %w[y yes n no].include?(answer.downcase)

    false
  end

  def record_moves
    human.track_history
    computer.track_history
  end

  def continue
    puts 'Press Enter to continue:'
    gets
    system('clear')
  end

  def display_history
    puts '+---Move History---+'
    puts "#{human.name} chose:"
    puts human.moves
    puts "#{computer.name} chose:"
    puts computer.moves
    continue
  end

  def display_final_scoreboard
    system('clear')
    puts '----FINAL SCORE-----'
    puts "-{#{human.name}: #{human_score} #{computer.name}: #{computer_score}}-"
  end

  def match_over?
    true if human_score == 10 || computer_score == 10
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if %w[y n].include? answer.downcase

      puts 'Sorry, answer must be y or n'
    end

    system('clear')
    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def play
    display_welcome_message
    loop do
      display_scoreboard
      choose
      display_moves
      display_winner
      adjust_score
      record_moves
      break if match_over?
      break unless play_again?

      display_history
    end
    display_final_scoreboard
    display_goodbye_message
  end
end

RPSGame.new.play
