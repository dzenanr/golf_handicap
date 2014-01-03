library games;

import 'dart:html';
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 
import "../utilities/utils.dart";

@CustomTag('games-block')
class GamesBlock extends PolymerElement {
  @published bool isDisplayed;
  @published Player currentPlayer;
  @published Courses courses;
  @published Function saveFunction;
  
  /// Parameters for the dialogs
  @observable bool showConfirmDialog;
  @observable String confirmDialogMessage;
  @observable Oid oidConfirmDialog;
  @observable bool showErrorDialog;
  @observable String errorDialogMessage;
  
  @observable Game currentGame;
  @observable Course selectCourse;
  @observable Tees selectedTees;
  @observable Tee selectTee;

  GamesBlock.created() : super.created();
  
  ImageElement _imgErrCourse;
  ImageElement _imgErrTee;
  ImageElement _imgErrDate;
  ImageElement _imgErrRealScore;
  ImageElement _imgErrEqScore;
  
  ////////////////////
  //GAME LIST SECTION
  ////////////////////
  
  enteredView() {
    currentPlayer.gamesPlayed.doCurrentSort();
  }
  
  // Event triggerred by a click on the delete icon
  void validateDelete(Event e) {
    Oid oid = new Oid.ts(int.parse((e.target as InputElement).value));
    Game gameToDel = currentPlayer.gamesPlayed.singleWhereOid(oid);
    confirmDialogMessage = "Are you really sure that you want to delete this game? " + 
        gameToDel.realScore.toString() + " on " + gameToDel.datePlayed.toString().substring(0, 10) + " at " + gameToDel.teePlayed.parentCourse.name;
    oidConfirmDialog = oid;
    showConfirmDialog = true;
  }
  
  // Delete a game
  void doDelete(Oid oid) {
    showConfirmDialog = false;
    Game gameToDel = currentPlayer.gamesPlayed.singleWhereOid(oid);
    
    // Since we will delete a game, we need to clear the handicap
    currentPlayer.clearHandicapsAfterGame(gameToDel);
    
    // Remove game from player
    bool removed = currentPlayer.gamesPlayed.remove(gameToDel);
    
    // Remove game from tees
    gameToDel.teePlayed.gamesPlayedOn.remove(gameToDel);
    
    // Then recalculate the handicap
    currentPlayer.calculatePlayerHandicap();
    currentPlayer.gamesPlayed.doCurrentSort();
    
    // Persistency
    saveFunction();
  }
  
  // Function which saves a new game
  void saveNewGame(Event e, var detail, Element target) {
    //For potential rollback
    currentGame = new Game(currentPlayer.gamesPlayed.concept);
    getDisplayedValues(currentGame);
    clearErrors();
    List<ErrorMessage> errors = currentGame.validate();
    if (errors.length > 0) {
      bindErrors(errors);
    }
    else {
      // Add game to player and tees
      currentPlayer.gamesPlayed.add(currentGame);
      currentGame.teePlayed.gamesPlayedOn.add(currentGame);
      
      // Since we added a game, we need to recalculate the handicap
      currentPlayer.clearHandicapsAfterGame(currentGame);
      currentPlayer.calculatePlayerHandicap();
      
      //Put back with most recent game on top
      currentPlayer.gamesPlayed.internalList = toObservable(currentPlayer.gamesPlayed.internalList);
      currentPlayer.gamesPlayed.currentSort = 'datePlayed';
      currentPlayer.gamesPlayed.currentSortOrder = 'desc';
      currentPlayer.gamesPlayed.doCurrentSort();
      
      // Persistency
      saveFunction();

      // Hide form
      DivElement divName = shadowRoot.querySelector('#add_form');
      toggle(divName);
      // Clear form
      ShadowRoot sr = this.shadowRoot;
      (sr.querySelector('#date') as InputElement).value = "";
      (sr.querySelector('#realScore') as InputElement).value = "";
      (sr.querySelector('#eqScore') as InputElement).value = "";
      (sr.querySelector('#tee') as SelectElement).value = "";
      (sr.querySelector('#course') as SelectElement).value = "";
    }
  }
  
  void getDisplayedValues(Game game) {
    //Because controls are inside a conditional template we need
    //to access them through the shadow root
    ShadowRoot sr = this.shadowRoot;
    _imgErrCourse = sr.querySelector('#imgErrCourse');
    _imgErrTee = sr.querySelector('#imgErrTee');
    _imgErrDate = sr.querySelector('#imgErrDate');
    _imgErrRealScore = sr.querySelector('#imgErrRealScore');
    _imgErrEqScore = sr.querySelector('#imgErrEqScore');
    
    var datePlayed = (sr.querySelector('#date') as InputElement).value;
    if (datePlayed != "") { game.datePlayed = DateTime.parse(datePlayed); }
    var realScore = (sr.querySelector('#realScore') as InputElement).value;
    if (realScore != "") { game.realScore = int.parse(realScore); }
    var eqScore = (sr.querySelector('#eqScore') as InputElement).value;
    if (eqScore != "") { game.equitableScore = int.parse(eqScore); }
    var teePlayed = (sr.querySelector('#tee') as SelectElement).value;
    if (teePlayed != "") { game.teePlayed = selectCourse.courseTees.singleWhere((x) => x.color == teePlayed); }
    game.gamePlayer = currentPlayer;
  }
  
  // Clear error messages
  void clearErrors() {
    _imgErrCourse.hidden = true;
    _imgErrCourse.title = '';
    _imgErrTee.hidden = true;
    _imgErrTee.title = '';
    _imgErrDate.hidden = true;
    _imgErrDate.title = '';
    _imgErrRealScore.hidden = true;
    _imgErrRealScore.title = '';
    _imgErrEqScore.hidden = true;
    _imgErrEqScore.title = '';
  }
  
  // Bind error messages to input fields
  void bindErrors(List<ErrorMessage> errors) {
    for (ErrorMessage err in errors) {
      ImageElement errorDisplay;
      switch (err.propertyName) {
        case 'datePlayed':
          errorDisplay = _imgErrDate;
          break;
        case 'realScore':
          errorDisplay = _imgErrRealScore;
          break;
        case 'equitableScore':
          errorDisplay = _imgErrEqScore;
          break;
        case 'teePlayed':
          errorDisplay = _imgErrTee;
          break;
        default :
          throw new Exception('Error in message data binding');
      }
      errorDisplay.hidden = false;
      errorDisplay.title += err.message + '\n';
    }
  }
  
  ////////////////////
  //GAME ADD SECTION
  ////////////////////
  
  // Function which opens the new form and changes the labels
  void toggleAddForm(Event e, var detail, Element target) {
    DivElement divName = shadowRoot.querySelector('#add_form');
    toggle(divName);
  }
  
  // Fetch tees according to courses
  void fetchTees (Event e) {
    var courseOid = (e.target as SelectElement).value;
    Oid oid = new Oid.ts(int.parse(courseOid));
    
    if (oid != "") {      
      // Get selected course
      selectCourse = courses.singleWhereOid(oid);
      selectedTees = selectCourse.courseTees;
      // Façon de contourner le observable selectedTees qui ne se refraichit pas...
      var htmlOptions = '<option></option>';
      for (int j=0;j < selectedTees.count;j++){
        htmlOptions += '<option template value="' + selectedTees.internalList[j].color +'">'
            + selectedTees.internalList[j].name + '</option>';
      }
      shadowRoot.querySelector('#tee').innerHtml = htmlOptions;
    } else {
      // Reset select
      var htmlOptions = '<option></option>';
      shadowRoot.querySelector('#tee').innerHtml = htmlOptions;
    }
  }
  
  // Utilities function
  void toggle(Element elem) {
    if (elem.style.getPropertyValue("display") == "none") {
      elem.style.setProperty("display", "block");  
    }
    else {
      elem.style.setProperty("display", "none");
    }
  }
  
  // Show block
  void showBlock() {
    isDisplayed = true;
  }
  
  // Hide block
  void hideBlock() {
    isDisplayed = false;
  }
  
  void enforceIntegerInputMask(KeyboardEvent e) {
    integerInputMask(e);
  } 
  
  void enforceDateInputMask(KeyboardEvent e) {
    dateInputMask(e);
  }
  
  void clearDateInvalid(Event e) {
    clearDateIfInvalid(e);
  }

}