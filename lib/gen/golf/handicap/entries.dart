part of golf_handicap; 
 
// lib/gen/golf/handicap/entries.dart 
 
class HandicapEntries extends ModelEntries { 
 
  HandicapEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = new Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Player"); 
    entries["Player"] = new Players(concept); 
    concept = model.concepts.singleWhereCode("Course"); 
    entries["Course"] = new Courses(concept); 
    return entries; 
  } 
 
  Entities newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw new ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Player") { 
      return new Players(concept); 
    } 
    if (concept.code == "Game") { 
      return new Games(concept); 
    } 
    if (concept.code == "Tee") { 
      return new Tees(concept); 
    } 
    if (concept.code == "Course") { 
      return new Courses(concept); 
    } 
  } 
 
  ConceptEntity newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw new ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Player") { 
      return new Player(concept); 
    } 
    if (concept.code == "Game") { 
      return new Game(concept); 
    } 
    if (concept.code == "Tee") { 
      return new Tee(concept); 
    } 
    if (concept.code == "Course") { 
      return new Course(concept); 
    } 
  } 
 
  fromJsonToData() { 
    fromJson(golfHandicapDataJson); 
  } 
 
  Players get players => getEntry("Player"); 
  Courses get courses => getEntry("Course"); 
 
} 
 
