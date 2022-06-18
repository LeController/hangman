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

  def pick_word
    words = File.read('allowed_words.txt').split
    @chosen_word = words.sample
    @chosen_word_array = @chosen_word.split('')

    @chosen_word_array.length.times do 
      @player_progress.push('_')
    end

    # p "COMPUTER HAS CHOSEN THE WORD: '#{@chosen_word}'!"
  end

  def play_game
    while @num_guesses > 0 do

      puts "PLAYER PROGRESS: \n#{@player_progress.join(' ')}"
      puts ''
      if @num_guesses > 1
        puts "You have #{@num_guesses} guesses remaining"
      else
        puts "You have #{@num_guesses} guess remaining"
      end
      puts ''
      puts "PLEASE INPUT A GUESS.\n"
    
      input = gets.chomp.downcase
    
      while input.length != 1 || @guessed_letters.include?(input) do
        if input.length != 1
          puts "GUESS MUST BE A SINGLE LETTER!"
          input = gets.chomp.downcase
        elsif @guessed_letters.include?(input)
          puts "LETTER HAS ALREADY BEEN GUESSED!"
          input = gets.chomp.downcase
        end
      end
    
      @guessed_letters.push(input)
    
      puts "\nPast guesses: '#{@guessed_letters}'."
      puts ''
      
      @chosen_word_array.each_with_index do |letter, index|
        if input == letter
          @player_progress[index] = letter
        end
      end
    
      if @chosen_word_array.include?(input)
        
      else
        @num_guesses -= 1
      end
    
      if !@player_progress.include?('_')
        puts "CONGRATULATIONS! A WINNER IS YOU! The word was #{@chosen_word}."
        break
      elsif @num_guesses == 0
        puts "YOU ARE OUT OF GUESSES! The word was #{@chosen_word}."
        break
      end
    end

  end
  
end

game = Hangman.new

game.pick_word

game.play_game



