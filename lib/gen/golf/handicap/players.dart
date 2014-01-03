part of golf_handicap; 
 
// lib/gen/golf/handicap/players.dart 
 
abstract class PlayerGen extends ConceptEntity<Player> { 
 
  PlayerGen(Concept concept) : super.of(concept) { 
    Concept gameConcept = concept.model.concepts.singleWhereCode("Game"); 
    setChild("gamesPlayed", new Games(gameConcept)); 
  } 
 
  PlayerGen.withId(Concept concept, String email) : super.of(concept) { 
    setAttribute("email", email); 
    Concept gameConcept = concept.model.concepts.singleWhereCode("Game"); 
    setChild("gamesPlayed", new Games(gameConcept)); 
  } 
 
  String get email => getAttribute("email"); 
  set email(String a) => setAttribute("email", a); 
  
  String get password => getAttribute("password"); 
  set password(String a) => setAttribute("password", a); 
  
  String get firstName => getAttribute("firstName"); 
  set firstName(String a) => setAttribute("firstName", a); 
  
  String get lastName => getAttribute("lastName"); 
  set lastName(String a) => setAttribute("lastName", a); 
  
  DateTime get birthDate => getAttribute("birthDate"); 
  set birthDate(DateTime a) => setAttribute("birthDate", a); 
  
  String get sex => getAttribute("sex"); 
  set sex(String a) => setAttribute("sex", a); 
  
  String get phoneNumber => getAttribute("phoneNumber"); 
  set phoneNumber(String a) => setAttribute("phoneNumber", a); 
  
  Games get gamesPlayed => getChild("gamesPlayed"); 
  
  Player newEntity() => new Player(concept); 
  Players newEntities() => new Players(concept); 
  
  int emailCompareTo(Player other) { 
    return email.compareTo(other.email); 
  } 
 
} 
 
abstract class PlayersGen extends Entities<Player> { 
 
  PlayersGen(Concept concept) : super.of(concept); 
 
  Players newEntities() => new Players(concept); 
  Player newEntity() => new Player(concept); 
  
} 
 
