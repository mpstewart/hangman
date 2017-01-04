attempts = 5

words = File.read("5desk.txt").split("\n").select { |word| word.length > 5 && word.length < 12 }

words.each(&:downcase!)

puts "Welcome to hangman!"

word = words[rand(0...words.length)]

obscured_word = "_" * word.length

incorrect_letters = []

while obscured_word != word && attempts >= 0
  system "clear"
  puts word
  puts "#{obscured_word} | Attempts remaining: #{attempts}"
  puts "Incorrect Guesses:"
  puts incorrect_letters.join(", ")

  print "Guess a letter: "
  guess = gets.chomp[0].downcase

  if word.include? guess
    puts "Good job!"
    sleep 1
  elsif incorrect_letters.include? guess
    puts "Already tried that...it didn't go well..."
    sleep 1
  elsif obscured_word.include? guess
    puts "Already found that one..."
    sleep 1
  else
    puts "too bad :-("
    incorrect_letters << guess unless incorrect_letters.include? guess
    attempts -= 1
    sleep 1
  end

  indices = (0...word.length).find_all { |i| word[i] == guess}

  indices.each { |i| obscured_word[i] = guess}
end