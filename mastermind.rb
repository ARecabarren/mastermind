require 'pry-byebug'
module MasterMind

    def write_possible_codes
        combinations = []
        (1..6).each do |a|
            (1..6).each do |b|
                (1..6).each do |c|
                    (1..6).each do |d|
                        combinations << [a,b,c,d]
                    end
                end
            end
        end

        return combinations
    end


    class Play
        def initialize
            @trys = 0
            @correct_guess = false
            puts "Welcome to Mastermind! \n\t---"
            puts "Insert 1 to be the breaker or 2 to be the coder"
            user = gets.chomp
            if user == '1'
                @code = Code.new
                run_game_as_player
            else
                puts "Write a code to challenge the computer"
                @code = Code.new(gets.chomp.split('').map!{|item| item.to_i})
                run_game_as_computer
            end
            
        end

        def run_game_as_player
            @user_promp = 'You'
            until @trys == 12 || @correct_guess
                @trys += 1
                puts "\nMake a guess"
                user_guess = gets.chomp.split('').map!{|item| item.to_i}

                if user_guess == @code.code
                    return end_game
                    break
                else
                    # binding.pry
                    @matchs, @semi_match = @code.compare_guess(user_guess)
                    clues = write_clues(@matchs,@semi_match)
                    puts "\n\t#{user_guess}"
                    puts "\tClues: #{clues}"
                    puts "\tRemaining attempts: #{12 - @trys}\n"
                end
                

            end
            end_game
        end

        def run_game_as_computer
            @wf = [6,5,7].sample
            @set = write_possible_codes
            @user_promp = 'The computer'
            until @trys == 23
                
                puts "Computer ##{@trys} attempt"
                @trys == 0 ? computer_guess = [1,1,2,2] : computer_guess = @next_guess
                puts "Computer guess: #{computer_guess}"
                # binding.pry
                @trys == @wf ? computer_guess = @code.code : ' '
                if computer_guess == @code.code
                    return end_game
                else
                    @matchs, @semi_match = @code.compare_guess(computer_guess)
                    # binding.pry
                    @set.reject!{ |array| array == computer_guess}
                    make_subset
                    @next_guess = @set.sample
                    # binding.pry
                end
                @trys += 1



            end
        end
        def write_clues(matchs,semi_match)
            clues = ''
            semi_match.times{clues += 'O'}
            matchs.times{clues += 'X'}
            return clues
        end
        
        def end_game
            if @trys < 12
                puts "@#{@user_promp} solved the code in #{@trys} guesses."
            else
                puts "No attemps left, better luck next time."
            end
        end

        def make_subset
            # binding.pry
            
            @set.select! do |code|
                matchs, semi_match = @code.compare_guess(code)
                (matchs == @matchs) || (matchs > @matchs) && (semi_match == @semi_match)
            end
        end
    end

    class Code
        attr_reader :code
        def initialize(code = generate_random_code)
            @code = code
        end

        def compare_guess(guess)
            match = 0
            to_move = 0
            compared = []

            @code.each_with_index do |digit, index|
                guess.each_with_index do |guess_value, guess_index|
                    # binding.pry
                    if guess_value == digit && guess[index] == digit
                        match += 1
                        break
                    elsif digit == guess_value && index != guess_index && !compared.include?(guess_value)
                        to_move += 1
                        compared << guess_value
                        break
                    end
                end
            end

            return match, to_move


        end

        def generate_random_code
            random_code = []
            4.times{random_code.push(rand(1..6).to_s)}
            return random_code.map!{|item| item.to_i}
        end

        


        
    end


end

include MasterMind
Play.new