# script below to filter words between 5 and 12 characters
def filter_words(filename)
  words = File.open(filename)
  allowed_words = []

  for word in words
    if word.length >= 6 && word.length <=13
      allowed_words.push(word)
      File.write('allowed_words.txt', word, mode: 'a')
    end
  end
end

# filter_words('google-10000-english-no-swears.txt')

class Hangman
  def initialize
    @num_guesses = 7
    @guessed_letters = []
    @player_progress = []
  end

  def start
    self.pick_word
  end

  def pick_word
    words = File.read('allowed_words.txt').split
    @chosen_word = words.sample
    @chosen_word_array = @chosen_word.split('')

    @chosen_word_array.length.times do 
      @player_progress.push('_')
    end

    # p "COMPUTER HAS CHOSEN THE WORD: '#{@chosen_word}'!"
  end

  def get_input
    puts "PLAYER PROGRESS: \n#{@player_progress.join(' ')}"
    puts ''
    if @num_guesses > 1
      puts "You have #{@num_guesses} guesses remaining"
    else
      puts "You have #{@num_guesses} guess remaining"
    end
    puts ''
    puts "PLEASE INPUT A GUESS.\nType 'save' to save your progress.\n"
  
    input = gets.chomp.downcase
  
    while input.length != 1 || @guessed_letters.include?(input) do
      if input == 'save'
        save_game
        break
      elsif input.length != 1
        puts "GUESS MUST BE A SINGLE LETTER!"
        input = gets.chomp.downcase
      elsif @guessed_letters.include?(input)
        puts "LETTER HAS ALREADY BEEN GUESSED!"
        input = gets.chomp.downcase
      end
    end

    return input
  end

  def save_game 
    hash_to_save = {"@num_guesses" => @num_guesses,
                    "@guessed_letters" => @guessed_letters,
                    "@player_progress" => @player_progress,
                    "@chosen_word" => @chosen_word,
                    "@chosen_word_array" => @chosen_word_array 
                    }

    @player_progress = 'saved'

    i = 1
    @filename = 'saved_games/savegame_%s.txt' % [i]
    while File.exists?(@filename)
      i += 1
      @filename = 'saved_games/savegame_%s.txt' % [i]
    end

    File.open(@filename, 'w') do |file|
      file.puts hash_to_save 
    end
  end

  def load_game(path)
    hash_str = File.read(path)
    game_hash = eval(hash_str)
    File.delete(path)
    @num_guesses, @guessed_letters, @player_progress, @chosen_word, @chosen_word_array = game_hash['@num_guesses'], game_hash['@guessed_letters'], game_hash['@player_progress'], game_hash['@chosen_word'], game_hash['@chosen_word_array']
    puts @chosen_word_array
    puts "Game from #{path} has been loaded."
    puts ''
    self.play_game
  end

  def play_game

    while @num_guesses > 0 do

      input = self.get_input

      @guessed_letters.push(input)
      
      @chosen_word_array.each_with_index do |letter, index|
        if input == letter
          @player_progress[index] = letter
        end
      end
    
      if !@chosen_word_array.include?(input)
        @num_guesses -= 1
      end
      
      if @player_progress == 'saved'
        puts "\nGame has been saved at #{@filename}."
        puts ''
        puts "Would you like to play again?"
        break
      elsif !@player_progress.include?('_')
        puts "\nCONGRATULATIONS! A WINNER IS YOU! The word was #{@chosen_word}."
        puts ''
        puts "Would you like to play again?"
        break
      elsif @num_guesses == 0
        puts "\nYOU ARE OUT OF GUESSES! The word was #{@chosen_word}."
        puts ''
        puts "Would you like to play again?"
        break
      end

      puts "\nPast guesses: '#{@guessed_letters}'."
      puts ''

    end

  end
  
end


puts "Would you like to play Hangman?"
while true
  puts "Type 'load' to load a saved game."
  input = gets.chomp[0]
  if input[0].downcase == 'y'
    game = Hangman.new
    game.start
    game.play_game
  elsif input[0].downcase == 'l'
    puts "\nWhich game would you like to load? Input a valid number."
    number_to_load = gets.chomp
    savegame_to_load = 'savegame_%s.txt' % [number_to_load]
    filepath = 'saved_games/%s' % [savegame_to_load]

    if File.exists?(filepath)
      puts "\nLoading #{savegame_to_load} from #{filepath}..."
      puts '' 
      game = Hangman.new
      game.load_game(filepath)
    else
      puts "\nSAVED GAME DOES NOT EXIST!"
    end
  else
    break
  end
end



