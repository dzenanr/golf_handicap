part of golf_handicap; 
 
// lib/gen/golf/repository.dart 
 
class GolfRepo extends Repo { 
 
  static final golfDomainCode = "Golf"; 
  static final golfHandicapModelCode = "Handicap"; 
 
  GolfRepo([String code="GolfRepo"]) : super(code) { 
    _initGolfDomain(); 
  } 
 
  _initGolfDomain() { 
    var golfDomain = new Domain(golfDomainCode); 
    domains.add(golfDomain); 
    add(new GolfModels(golfDomain)); 
  } 
 
} 
 
