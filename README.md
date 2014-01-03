##golf_handicap

**Categories**: education

**Description**: Session project - a golf handicap manager

**By**: Maxim Fournier-Giguere & Pierre-Olivier Nadeau

**For**: SIO-6014, prof. Dzenan Ridjanovic

Context
---------------------
  * This golf handicap manager has 4 main entities:
    * Course
    * Tee
    * Player
    * Game

  * A course has many tees, on which a game is played by a player. A tee is a starting position
  on each hole of a course. Each tee is rated by the north american golf associations (USGA and RCGA) to give
  it a rating and a slope, which are measures of difficulty used to calculate the handicap.

  * The handicap, calculated according to those rules http://en.wikipedia.org/wiki/Handicap_(golf)
  is a measure of a player scoring potential.

  	* You need to post at least 5 games to get a valid handicap
  	* The handicap is calculated on the best 10 of your last 20 games
  	* If you have posted less than 20 games, the handicap is calculated based on your best X games, where
  	X is determined by the exact number of games you have played

Features
---------------------
  * Use the already defined test data:
  	* 5 players already defined, all with the password "abc123"
  		* mfgiguere@gmail.com - more than 20 games
  		* nadeau.pierrot@gmail.com - between 10 and 20 games
  		* dzenanr@gmail.com - less than 5 games
  		* twoods@nike.com - 7 games
  		* michellewie@gmail.com - 11 games
  * Register a new account: your email is your ID
  * Each profile can be edited once logged in. In the profile section, you can also
  display a graph of your handicap progression.
  * Some courses are already defined, based on real-life data. You can add, edit and delete
  courses and their tees. Use the "Courses" menu
  * The list of games shows the most recent game first. You can insert new a new game at
  any moment in the past and all the subsenquent games handicap are recalculated. Games can't be
  edited.
  * Tees and courses which are bound to at least a game can't be deleted.
  * Data-bound validations: When data is saved, validations are peformed. If a property is invalid, a
  red button is displayed besides its input field. Just put your curson on the button
  to show and error message explaining why the propperty is invalid. Validations are for the most
  part performed inside the model. Dartling validation was not used for the most part, we went
  with our own custom validation pattern.
  * All data is saved to and loaded from local storage, except on the first run, when it's auto-generated
  * There are a few unit tests, which test the integrity of the generated data and the calculations
  performed


