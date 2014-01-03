library title;

import 'package:polymer/polymer.dart';

@CustomTag('title-block')
class Title extends PolymerElement {
  
  Title.created() : super.created();
  
  @observable bool login;
  @observable bool profile;
  @observable bool games;
  @observable bool player;
  @observable bool courses;
  @published String type;
  
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    switchMenu();
  }
  
  void resetAll() {
    login = false;
    profile = false;
    games = false;
    player = false;
    courses = false;
  }
  
  void switchMenu() {
    resetAll();
    switch (type) {
      case 'login':
        login = true;
        break;
      case 'profile':
        profile = true;
        break;
      case 'games':
        games = true;
        break;
      case 'player':
        player = true;
        break;
      case 'courses':
        courses = true;
        break;
    }
  }

}