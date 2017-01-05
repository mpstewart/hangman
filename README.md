# Hangman
This represents an implementation of the core funcionatly of Hangman from The Odin Project. It's essentially feature complete, but lacks any form of error handling. A good-faith player (one who isn't actively trying to break the game) should have no trouble at all.

Instructions:
- Clone and run lib/hangman from the project's root directory. Menus from there on should be pretty self-explanatory.
- `Crl-c` during game to save and exit.

The original purpose of this project was to learn about File I/O in Ruby. As the project devloped, I realized the importance of modular architecture, and fell into a few anti-patterns, before arriving at a pattern that addressed the problem well, in my opinion, and could be extended to solve other problems. 
 
I've implemented two types of File I/O in this project. The first, and simplest of the two, was reading in from a text file to pick the word. This was straightforward, I simply had to read the contents of the file into memory before selecting a word. The second type of File I/O used YAML to save and load the game state. This was a bit trickier to implement, but I feel that I have a much better grasp on YAML serialization than I did in the past.

The design pattern evolved mainly in two forms. I originally used a flat architecture to understand the game loop. When I started to add the game save features though, it became apparent I should start separating some functionality. Particularly in light of the looming Chess project. I wanted to devise a pattern that would be extensible to that circumstance as well. I arrived at a pattern that used `Application` to handle initializing the game, as well as the saving and loading operations and prompts. The game logic and representation is implemented by `HangmanGame`. `Application` creates or loads a `HangmanGame` instance, then will kick either off using the same method call on `HangmanGame`. This should be almost directly extensible to the Chess project.

Gems used:
- [HighLine](https://github.com/JEG2/highline)
	- This was used to handle loading/new game prompts, save/exit prompts, and also to provide color to the guess feedback.
	- I like this gem a lot. Way easier than using `gets` and `puts`. Other than printing the board, I don't think I used a single `gets` or `puts` in the main project.
