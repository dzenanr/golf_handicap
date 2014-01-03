 
// test/golf/handicap/golf_handicap_gen.dart 
 
import "package:dartling/dartling.dart"; 
 
import "package:golf_handicap/golf_handicap.dart"; 
 
genCode() { 
  var repo = new Repo(); 
 
  var golfDomain = new Domain("Golf"); 
 
  Model golfHandicapModel = 
      fromJsonToModel(golfHandicapModelJson, golfDomain, "Handicap"); 
 
  repo.domains.add(golfDomain); 
 
  repo.gen("golf_handicap"); 
} 
 
initGolfData(GolfRepo golfRepo) { 
   var golfModels = 
       golfRepo.getDomainModels(GolfRepo.golfDomainCode); 
 
   var golfHandicapEntries = 
       golfModels.getModelEntries(GolfRepo.golfHandicapModelCode); 
   initGolfHandicap(golfHandicapEntries); 
   golfHandicapEntries.display(); 
   golfHandicapEntries.displayJson(); 
} 
 
void main() { 
  genCode(); 
 
  var golfRepo = new GolfRepo(); 
  initGolfData(golfRepo); 
} 
 
