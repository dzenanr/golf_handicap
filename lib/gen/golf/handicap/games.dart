part of golf_handicap; 
 
// lib/gen/golf/handicap/games.dart 
 
abstract class GameGen extends ConceptEntity<Game> { 
 
  GameGen(Concept concept) : super.of(concept); 
 
  Tee get teePlayed => getParent("teePlayed"); 
  set teePlayed(Tee p) => setParent("teePlayed", p); 
  
  Player get gamePlayer => getParent("gamePlayer"); 
  set gamePlayer(Player p) => setParent("gamePlayer", p); 
  
  DateTime get datePlayed => getAttribute("datePlayed"); 
  set datePlayed(DateTime a) => setAttribute("datePlayed", a); 
  
  int get realScore => getAttribute("realScore"); 
  set realScore(int a) => setAttribute("realScore", a); 
  
  int get equitableScore => getAttribute("equitableScore"); 
  set equitableScore(int a) => setAttribute("equitableScore", a); 
  
  double get handicapDifferential => getAttribute("handicapDifferential"); 
  set handicapDifferential(double a) => setAttribute("handicapDifferential", a); 
  
  int get courseHandicap => getAttribute("courseHandicap"); 
  set courseHandicap(int a) => setAttribute("courseHandicap", a); 
  
  int get netScore => getAttribute("netScore"); 
  set netScore(int a) => setAttribute("netScore", a); 
  
  double get playerHandicapAfter => getAttribute("playerHandicapAfter"); 
  set playerHandicapAfter(double a) => setAttribute("playerHandicapAfter", a); 
  
  Game newEntity() => new Game(concept); 
  Games newEntities() => new Games(concept); 
  
} 
 
abstract class GamesGen extends Entities<Game> { 
 
  GamesGen(Concept concept) : super.of(concept); 
 
  Games newEntities() => new Games(concept); 
  Game newEntity() => new Game(concept); 
  
} 
 
