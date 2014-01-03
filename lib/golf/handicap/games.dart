part of golf_handicap; 
 
// lib/golf/handicap/games.dart 
 
class Game extends GameGen { 
 
  Game(Concept concept) : super(concept); 
  
  List<ErrorMessage> validate() {
    List<ErrorMessage> errors = new List<ErrorMessage>();
  
    if (datePlayed == null) {
      errors.add(new ErrorMessage('datePlayed','The date is required'));
    } 
    else if (datePlayed.compareTo(new DateTime.now()) > 0) {
      errors.add(new ErrorMessage('datePlayed',"You can't enter games in the future"));
    }
    
    if (realScore == null) {
      errors.add(new ErrorMessage('realScore','The real score is required'));
    } 
    else {
      if (realScore < 56) {
        errors.add(new ErrorMessage('realScore','The real score must be greather than 55'));
      }
      if (realScore > 200) {
        errors.add(new ErrorMessage('realScore','The maximum real score allowed is 200'));
      }
    }
    
    if (equitableScore == null) {
      errors.add(new ErrorMessage('equitableScore','The adjusted (equitable) score is required'));
    } 
    else {
      if (equitableScore < 56) {
        errors.add(new ErrorMessage('equitableScore','The equitable score must be greater than 55'));
      }
      if (equitableScore > 180) {
        errors.add(new ErrorMessage('equitableScore','The maximum adjusted (equitable) score possible is 180'));
      }
    }
    
    if (equitableScore != null && realScore != null && equitableScore > realScore) {
      errors.add(new ErrorMessage('equitableScore','The equitable score must be equal to or less than the real score'));
    }
    
    if (gamePlayer == null) {
      errors.add(new ErrorMessage('gamePlayer','A player must be provided for the game'));
    }
    
    if (teePlayed == null) {
      errors.add(new ErrorMessage('teePlayed','A tee must be provided for the game'));
    }

    return errors;
  }
  
  /*
   * Calculates the [handicapDifferential] and rounds it to the nearest tenth.
   * Reference: http://en.wikipedia.org/wiki/Handicap_(golf)
   */
  double calculateHandicapDifferential() {
    Tee tee = this.teePlayed;
    if (equitableScore != null && tee != null && tee.rating != null && tee.slope != null) {
      handicapDifferential = ((equitableScore - tee.rating) *113)/tee.slope;
      handicapDifferential = (handicapDifferential*10).round()/10;
    } 
    else {
      throw new Exception(
          "You need an equitable score, a tee rating and a tee slope to calculate the handicap differential");
    }
    return handicapDifferential;
  }
  
  /*
   * Calculates the [courseHandicap] and rounds it to the nearest whole number
   * Reference: http://en.wikipedia.org/wiki/Handicap_(golf)
   */
  int calculateCourseHandicap() {
    courseHandicap = null;
    Tee tee = this.teePlayed;
    Player player = this.gamePlayer;
    
    //The player handicap used to calculate the 
    //course handicap is the one he had the game just before
    //If he didn't have one the course handicap can't be calculated
    if (player != null && player.gamesPlayed != null && tee != null && tee.slope != null) {
      var previousGames = player.gamesPlayed.where((x) => x.datePlayed.compareTo(datePlayed) < 0).toList();;
      if (previousGames.length > 4) { //min 5 games to have an handicap
         previousGames.sort(((Game a, Game b) => 
             b.datePlayed.compareTo(a.datePlayed)));
         Game lastGame = previousGames[0];
         if (lastGame.playerHandicapAfter != null) {
          courseHandicap = ((lastGame.playerHandicapAfter * tee.slope) / 113).round();
          netScore = realScore - courseHandicap;
         }
      }     
    }
    return courseHandicap;
  }
  
} 
 
class Games extends GamesGen { 
 
  Games(Concept concept) : super(concept); 
  
  //Two temporary values, not in JSON
  String currentSort;
  String currentSortOrder;
  
  bool preAdd(Game game) {
    if (ErrorMessage.doValidations) {
      List<ErrorMessage> errors = game.validate();
      if (errors.length > 0) {
        throw new Exception("A game was not properly validated before being added to a collection");
      }
    }
    return true;
  }
  
  void doCurrentSort() {
    switch (this.currentSort) {
      case 'datePlayed':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.datePlayed.toUtc().compareTo(b.datePlayed.toUtc()))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.datePlayed.toUtc().compareTo(a.datePlayed.toUtc()))));
        }
        break;
      case 'realScore':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.realScore.compareTo(b.realScore))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.realScore.compareTo(a.realScore))));
        }
        break;
      case 'equitableScore':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.equitableScore.compareTo(b.equitableScore))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.equitableScore.compareTo(a.equitableScore))));
        }
        break;
      case 'handicapDifferential':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.handicapDifferential.compareTo(b.handicapDifferential))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.handicapDifferential.compareTo(a.handicapDifferential))));
        }
        break;
      case 'netScore':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.netScore.compareTo(b.netScore))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.netScore.compareTo(a.netScore))));
        }
        break;
      case 'playerHandicapAfter':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Game a, Game b) => 
              (a.playerHandicapAfter.compareTo(b.playerHandicapAfter))));
        }
        else {
          this.sort(((Game a, Game b) => 
              (b.playerHandicapAfter.compareTo(a.playerHandicapAfter))));
        }
        break;
    }
  }
  
} 
 
