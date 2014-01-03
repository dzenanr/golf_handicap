part of golf_handicap; 
 
// lib/gen/golf/handicap/tees.dart 
 
abstract class TeeGen extends ConceptEntity<Tee> { 
 
  TeeGen(Concept concept) : super.of(concept) { 
    Concept gameConcept = concept.model.concepts.singleWhereCode("Game"); 
    setChild("gamesPlayedOn", new Games(gameConcept)); 
  } 
 
  Course get parentCourse => getParent("parentCourse"); 
  set parentCourse(Course p) => setParent("parentCourse", p); 
  
  String get name => getAttribute("name"); 
  set name(String a) => setAttribute("name", a); 
  
  String get color => getAttribute("color"); 
  set color(String a) => setAttribute("color", a); 
  
  int get slope => getAttribute("slope"); 
  set slope(int a) => setAttribute("slope", a); 
  
  double get rating => getAttribute("rating"); 
  set rating(double a) => setAttribute("rating", a); 
  
  Games get gamesPlayedOn => getChild("gamesPlayedOn"); 
  
  Tee newEntity() => new Tee(concept); 
  Tees newEntities() => new Tees(concept); 
  
} 
 
abstract class TeesGen extends Entities<Tee> { 
 
  TeesGen(Concept concept) : super.of(concept); 
 
  Tees newEntities() => new Tees(concept); 
  Tee newEntity() => new Tee(concept); 
  
} 
 
