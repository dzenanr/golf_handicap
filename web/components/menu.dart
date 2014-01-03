library menu;

import 'package:polymer/polymer.dart';

@CustomTag('menu-block')
class Menu extends PolymerElement {

  @observable bool profile;
  @observable bool games;
  @observable bool courses;
  @published String type;
  @published Function gamesFunction;
  @published Function coursesFunction;
  @published Function profileFunction;
  @published Function logoutFunction;

  Menu.created() : super.created();

  void dispCourses() {
    coursesFunction();
  }

  void dispGames() {
    gamesFunction();
  }

  void dispProfile() {
    profileFunction();
  }

  void logout() {
    logoutFunction();
  }

  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    switchMenu();
  }

  void resetAll() {
    profile = false;
    games = false;
    courses = false;
  }

  void switchMenu() {
    resetAll();
    switch (type) {
      case 'profile':
        profile = true;
        break;
      case 'games':
        games = true;
        break;
      case 'courses':
        courses = true;
        break;
    }

  }

}