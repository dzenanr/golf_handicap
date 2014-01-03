library home;

import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart";

@CustomTag('home-block')
class Home extends PolymerElement {
  @published Players players;
  @published Player currentPlayer;
  @published Courses courses;
  @published Course currentCourse;
  @published Function saveFunction;

  @observable bool isRegistered = false;
  @observable bool isLoggedIn = false;
  @observable bool dispGames = false;
  @observable bool dispProfile = false;
  @observable bool dispCourses = false;
  @observable String title = "login";

  Home.created() : super.created();

  ////////////////////
  // LOGIN FCTS
  ////////////////////
  void doLogin() {
    isLoggedIn = true;
    isRegistered = true;
    showGames();
  }

  // Switch to register form
  void doRegister() {
    isRegistered = true;
    title = "player";
  }

  // Home page when logged on
  void doProfile() {
    isLoggedIn = true;
    showGames();
  }

  // Cancel create, come back to login
  void cancelCreate() {
    title = "login";
    isLoggedIn = false;
    isRegistered = false;
  }

  ///////////////////
  // MENU FCTS
  ///////////////////
  void doLogout() {
    title = "login";
    isLoggedIn = false;
    isRegistered = false;
    currentPlayer = null;
  }

  void showGames() {
    title = "games";
    dispGames = true;
    dispProfile = false;
    dispCourses = false;
  }

  void showCourses() {
    title = "courses";
    dispGames = false;
    dispProfile = false;
    dispCourses = true;
  }

  void showProfile() {
    title = "profile";
    dispGames = false;
    dispProfile = true;
    dispCourses = false;
  }

}