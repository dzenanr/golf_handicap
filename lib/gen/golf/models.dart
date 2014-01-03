part of golf_handicap; 
 
// lib/gen/golf/models.dart 
 
class GolfModels extends DomainModels { 
 
  GolfModels(Domain domain) : super(domain) { 
    add(fromJsonToHandicapEntries()); 
  } 
 
  HandicapEntries fromJsonToHandicapEntries() { 
    return new HandicapEntries(fromJsonToModel( 
      golfHandicapModelJson, 
      domain, 
      GolfRepo.golfHandicapModelCode)); 
  } 
 
} 
 
