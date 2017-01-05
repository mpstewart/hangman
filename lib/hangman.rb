require 'highline'
require 'pathname'
require 'yaml'

SAVE_DIR = "saves/"

# handles game logic and game presentation, also provides yaml coercion methods
class HangmanGame
  # create instance variables to be referenced throughout the class
  def initialize(word, attempts_remaining = 5, obscured_word = "_" * word.length, incorrect_letters = [])
    @attempts_remaining = attempts_remaining
    @word = word
    @obscured_word = obscured_word
    @incorrect_letters = incorrect_letters
  end

  def begin_turnj
    highline = HighLine.new
    
    while @attempts_remaining >= 0
      system "clear"
      print_board
      guess = highline.ask("Guess a letter: ")

      if @incorrect_letters.include? guess
        highline.say(already_guessed)
      elsif @word.include? guess
        highline.say(correct)
        reveal_letter(guess)
      else
        highline.say(wrong_and_missed)
        @attempts_remaining -= 1
        @incorrect_letters << guess
      end

      if @obscured_word == @word
        system "clear"
        reveal_letter(guess)
        print_board
        sleep 1
        highline.say(%{<%=color('You win!\nIt was "#{@word}!"', GREEN)%>})
        exit
      end

      sleep 1
    end # => main turn loop
  end

  def to_yaml
    YAML::dump(self)
  end

  private

  def print_board
    puts @word
    puts "#{@obscured_word} | Attempts remaining: #{@attempts_remaining}"
    puts "Incorrect guesses:"
    puts "#{@incorrect_letters.join(", ")}"
  end

  def reveal_letter(guess)
    @word.split("").each_with_index { |char, i| @obscured_word[i] = guess if guess == char}
  end

  def already_guessed
    %{<%= color("You already tried that, 'member?", YELLOW) %>}
  end

  def correct
    %{<%= color("You got one!", GREEN) %>}
  end

  def wrong_and_missed
    %{<%= color("Nope, missed it :-(", RED) %>}
  end
end

# handles option presentation, saving and loading of the game state
class Application
  def initialize
    @game = nil

    system "clear"
    highline = HighLine.new
    highline.say "Welcome to hangman!"
    highline.say "Please select an option:\n"
    highline.choose do |menu|
      menu.prompt = "-> "
      menu.choice("New Game") { @game = new }
      menu.choice("Load Game") { @game = load_game }
      menu.choice("Exit") { exit }
    end

    begin
      @game.begin_turn
    rescue Interrupt
      present_save_screen
    end

  end

  private
  def load_game
    system "clear"
    # ensure existence of save folder
    @save_directory = Dir.exists?(SAVE_DIR) ? SAVE_DIR : Dir.mkdir(SAVE_DIR)
    highline = HighLine.new

    # scrape filenames
    filenames = Dir.glob(@save_directory + "/*").map do |name|
      Pathname(name).basename
    end

    # present selection menu and return a save file
    highline.say "Choose a save to load: "
    highline.choose do |menu|
      menu.prompt = "-> "
      filenames.each do |filename|
        menu.choice(filename) { YAML::load(File.read("#{@save_directory}/#{filename}")) }
      end
    end
  end

  def new
    words = File.read("5desk.txt").split("\n").select { |word| word.length > 5 && word.length < 12 }.each(&:downcase!)
    word = words[rand(0...words.length)]
    HangmanGame.new(word)
  end

  def present_save_screen
    system "clear"
    highline = HighLine.new
    highline.say ("Would you like to save before quitting?")
    highline.choose do |menu|
      menu.choice("Yes") { save }
      menu.choice("No") { exit }
    end
  end

  def save
    @save_directory = Dir.exists?("saves") ? "saves" : Dir.mkdir("saves")
    save_name = Time.now.strftime("%H_%H-%d_%m_%Y.yml")
    output_name = File.join(@save_directory, save_name)
    File.open(output_name, 'w') { |f| f.write @game.to_yaml }
  end
end

Application.new