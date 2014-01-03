import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 
 
/* Composant Polymer de niveau supérieur de l'application
 * Ne doit servir qu'à initialiser le domaine et gérer la persistence
 * des entitités. Il contient les autres sous-éléments polymer.
 */
@CustomTag('golf-handicap-app')
class GolfHandicapApp extends PolymerElement {
  @observable Players players;
  @observable Player currentPlayer;
  @observable Courses courses;
  @observable Course currentCourse;
  
  GolfModels domain;
  DomainSession session;
  HandicapEntries entries;
  
  GolfHandicapApp.created() : super.created() {
    var golfRepo = new GolfRepo();
    
    domain = golfRepo.getDomainModels(GolfRepo.golfDomainCode);
    session = domain.newSession();
    entries = domain.getModelEntries(GolfRepo.golfHandicapModelCode);

    players = entries.players;
    courses = entries.courses;

    //Load data from local storage
    _readData();
    
    //If nothing on local storage - create default data
    if ((entries.players == null || entries.players.length < 1) &&
        (entries.courses == null || entries.courses.length < 1)) {
      initGolfHandicap(entries); 
      for (Player player in players) {
        player.calculatePlayerHandicap();
      }
    }

    initObservableLists();
    currentPlayer = null;
    currentCourse = null;
  }

  void storeData() {
    window.localStorage['entries'] = JSON.encode(entries.toJson());
  }
  
  void _readData() {
    ErrorMessage.doValidations = false;
    if (window.localStorage.containsKey('entries')) {
      String jsonData = window.localStorage['entries'];
      if (jsonData != null) {
        entries.clear();
        entries.fromJson(JSON.decode(jsonData));
      }
    }
    ErrorMessage.doValidations = true;
  }
  
  /**
   * This method allows polymer UI to refresh correctly
   */
  void initObservableLists() {
    players.internalList = toObservable(players.internalList);
    courses.internalList = toObservable(courses.internalList);
    for (Course course in courses) {
      course.courseTees.internalList = toObservable(course.courseTees.internalList);
    }
    for (Player player in players) {
      player.gamesPlayed.internalList = toObservable(player.gamesPlayed.internalList);
      player.gamesPlayed.currentSort = 'datePlayed';
      player.gamesPlayed.currentSortOrder = 'desc';
    }
  }
  
}

