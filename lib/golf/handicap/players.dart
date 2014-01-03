part of golf_handicap; 
 
// lib/golf/handicap/players.dart 
 
class Player extends PlayerGen { 
 
  Player(Concept concept) : super(concept); 
 
  Player.withId(Concept concept, String email) : 
    super.withId(concept, email); 
  
  List<ErrorMessage> validate() {
    List<ErrorMessage> errors = new List<ErrorMessage>();
    
    //Required fields
    if (email == null || email == '') {
      errors.add(new ErrorMessage('email','The email address is required'));
    }
    else {
      RegExp regex = new RegExp(REGEX_EMAIL);
      if (!regex.hasMatch(email)) {
        errors.add(new ErrorMessage('email','The email format is invalid'));
      }
    }

    if (password == null || password == '') {
      errors.add(new ErrorMessage('password','The password is required'));
    }
    else if (password.length < 6 || password.length > 20) {
      errors.add(new ErrorMessage('password','The password must contain between 6 and 20 characters'));
    }

    if (firstName == null || firstName == '') {
      errors.add(new ErrorMessage('firstName','The first name is required'));
    }
    
    if (lastName == null || lastName == '') {
      errors.add(new ErrorMessage('lastName','The last name is required'));
    }
    
    if (birthDate == null) {
      errors.add(new ErrorMessage('birthDate','A birth date must be provided'));
    }
    else if (birthDate.compareTo(new DateTime(1900,1,1)) < 0) {
      errors.add(new ErrorMessage('birthDate','The birth date must be greater than 1900-01-01'));
    }
    
    if (sex == null || sex == '') {
      errors.add(new ErrorMessage('sex','The sex is required'));
    } 
    else if (sex != 'M' && sex != 'F') {
      errors.add(new ErrorMessage('sex',"The sex must either be 'M' or 'F'"));
    }
    
    if (phoneNumber != null && phoneNumber.length > 0) {
      RegExp regex = new RegExp(REGEX_PHONE);
      if (!regex.hasMatch(phoneNumber)) {
        errors.add(new ErrorMessage('phoneNumber','The phone number format is invalid'));
      }
    }
    
    return errors;
  }
  
  /*
   * Calculate the handicapDifferential, the playerHandicapAfter and the 
   * courseHandicap for each game that hasn't one
   * The playedHandicapAfter depends on the previous games and the handicapDifferential, 
   * while the courseHandicap depends on the playerHandicapAfter of the previous game
   * At least 5 games are needed to calculate an handicap.
   * Reference: http://en.wikipedia.org/wiki/Handicap_(golf)
   */
  double calculatePlayerHandicap() {
    if (gamesPlayed == null || gamesPlayed.length < 5) {
      return null;
    }
    //Order the games so the oldest comes first
    gamesPlayed.sort((Game a, Game b) => a.datePlayed.compareTo(b.datePlayed));
    int gameNum = 1;
    for (Game game in gamesPlayed) {
      if (game.handicapDifferential == null) {
        game.calculateHandicapDifferential();
      }
      if (gameNum >= 5 && game.playerHandicapAfter == null) {
        game.playerHandicapAfter = _calculateHandicapAfterGame(game);
      }
      if (gameNum >= 6 && game.courseHandicap == null) {
        game.calculateCourseHandicap();
      }
      gameNum++;
    }

    //Returns the most recent game playerHandicapAfter, which is the player current handicap
    return gamesPlayed.at(gamesPlayed.length-1).playerHandicapAfter;
  }
  
  /*
   * Calculates the playerHandicapAfter of the most recent [game]
   * after a certain date.
   * The handicap index is calculated using the average of the best 10 differentials 
   * of the player's past 20 total rounds (or X if less games played), multiplied by 0.96.
   * Any digits in the handicap index after the tenths are truncated.
   */
  double _calculateHandicapAfterGame(Game game) {
    var currentGames = gamesPlayed.where((x) => 
        x.datePlayed.compareTo(game.datePlayed) <= 0).toList();
    if (currentGames == null || currentGames.length < 5) {
      return null;
    }
    
    //If more than 20, just keep the 20 following the game
    if (currentGames.length > 20) {
      currentGames.sort((Game a, Game b) => b.datePlayed.compareTo(a.datePlayed)); //newest first
      currentGames = currentGames.take(20).toList();
    }
    
    //Take the average of the lowest X differentials, depending 
    //on the number of games played at that date
    currentGames.sort((Game a, Game b) => 
        a.handicapDifferential.compareTo(b.handicapDifferential));
    int gamesForHdcp;
    if (currentGames.length == 5 || currentGames.length == 6) {
      gamesForHdcp = 1;
    }
    else if (currentGames.length == 7 || currentGames.length == 8) {
      gamesForHdcp = 2;
    }
    else if (currentGames.length == 9 || currentGames.length == 10) {
      gamesForHdcp = 3;
    }
    else if (currentGames.length == 11 || currentGames.length == 12) {
      gamesForHdcp = 4;
    }
    else if (currentGames.length == 13 || currentGames.length == 14) {
      gamesForHdcp = 5;
    }
    else if (currentGames.length == 15 || currentGames.length == 16) {
      gamesForHdcp = 6;
    }
    else if (currentGames.length == 17) {
      gamesForHdcp = 7;
    }
    else if (currentGames.length == 18) {
      gamesForHdcp = 8;
    }
    else if (currentGames.length == 19) {
      gamesForHdcp = 9;
    }
    else if (currentGames.length >= 20) {
      gamesForHdcp = 10;
    }
    double totalForAvg = 0.0;
    for (int i = 0; i < gamesForHdcp; i++) {
      totalForAvg += currentGames[i].handicapDifferential;
    }
    double rawHdcp = (totalForAvg / gamesForHdcp) * 0.96;
    return(rawHdcp*10).round()/10;
  }
 
  /*
   * Clears the handicaps of all games played after a certain [game], to
   * support the scenario where a game is inserted between games already there,
   * which will need to be recalculated since they can depend on this new game.
   */
  void clearHandicapsAfterGame(Game game) {
    var moreRecentGames = gamesPlayed.where((x) => 
        x.datePlayed.compareTo(game.datePlayed) > 0).toList();
    for (Game g in moreRecentGames) {
      g.playerHandicapAfter = null;
      g.courseHandicap = null;
      g.netScore = null;
    }
  }

  String getCurrentHandicap() {
    if (gamesPlayed != null && gamesPlayed.count > 4) {
      //oldest first
      gamesPlayed.sort((Game a, Game b) => a.datePlayed.compareTo(b.datePlayed));
      return gamesPlayed.at(gamesPlayed.length-1).playerHandicapAfter.toString();
    }
    else {
      return 'Not enough games';
    }  
  }
  
  Course getFavoriteCourse() {
    if (gamesPlayed != null && gamesPlayed.count > 0) {
      Map<Course,int> courseCount = new Map<Course,int>();
      for (Game game in gamesPlayed) {
        if (courseCount.containsKey(game.teePlayed.parentCourse)) {
          courseCount[game.teePlayed.parentCourse]++;
        }
        else {
          courseCount[game.teePlayed.parentCourse] = 1;
        }
      }
      List<Course> coursesPlayed = courseCount.keys.toList();
      int maxVal = 0;
      Course mostPlayed;
      for (Course course in coursesPlayed) {
        if (courseCount[course] > maxVal) {
          maxVal = courseCount[course];
          mostPlayed = course;
        }
      }
      return mostPlayed; 
    }
    return null;
  }
} 
 
class Players extends PlayersGen { 
 
  Players(Concept concept) : super(concept); 
 
  //Two temporary values, not in JSON
  String currentSort;
  String currentSortOrder;
  
  bool preAdd(Player player) {
    if (ErrorMessage.doValidations) {
      List<ErrorMessage> errors = player.validate();
      if (errors.length > 0) {
        throw new Exception("A player was not properly validated before being added to a collection");
      }
    }
    return true;
  }
  
} 
 
