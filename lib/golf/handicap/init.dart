                                                                                                                                                                                                                                                                                                part of golf_handicap; 
 
// lib/golf/handicap/init.dart 
 
initGolfHandicap(var entries) { 
  _initPlayers(entries); 
  _initCoursesAndTees(entries);
  _initGames(entries);
} 
 
_initPlayers(var entries) { 
  bool added;
  
  Player player = new Player(entries.players.concept); 
  player.email = "mfgiguere@gmail.com"; 
  player.password = "abc123"; 
  player.firstName = "Maxim"; 
  player.lastName = "Fournier-Giguère"; 
  player.birthDate = new DateTime(1983,5,27);
  player.sex = "M"; 
  player.phoneNumber = "418-645-0123"; 
  added = entries.players.add(player); 
  if (!added) {throw new Exception("Mock data generation error");}

  player = new Player(entries.players.concept); 
  player.email = "nadeau.pierrot@gmail.com"; 
  player.password = "abc123"; 
  player.firstName = "Pierre-Olivier"; 
  player.lastName = "Nadeau"; 
  player.birthDate = new DateTime(1938,3,28); 
  player.sex = "M"; 
  player.phoneNumber = "819-554-3344"; 
  added = entries.players.add(player); 
  if (!added) {throw new Exception("Mock player data generation error");}
 
  player = new Player(entries.players.concept); 
  player.email = "dzenanr@gmail.com"; 
  player.password = "abc123"; 
  player.firstName = "Dzenan"; 
  player.lastName = "Ridjanovic"; 
  player.birthDate = new DateTime(1975,12,17); 
  player.sex = "M"; 
  player.phoneNumber = "418-224-8730"; 
  added = entries.players.add(player); 
  if (!added) {throw new Exception("Mock player data generation error");}
 
  player = new Player(entries.players.concept); 
  player.email = "twoods@nike.com"; 
  player.password = "abc123"; 
  player.firstName = "Tiger"; 
  player.lastName = "Woods"; 
  player.birthDate = new DateTime(1975, 12, 30); 
  player.sex = "M"; 
  player.phoneNumber = "877-334-4434"; 
  added = entries.players.add(player); 
  if (!added) {throw new Exception("Mock player data generation error");}
 
  player = new Player(entries.players.concept); 
  player.email = "michellewie@gmail.com"; 
  player.password = "abc123"; 
  player.firstName = "Michelle"; 
  player.lastName = "Wie"; 
  player.birthDate = new DateTime(1989,10,11); 
  player.sex = "F"; 
  player.phoneNumber = "465-098-7789"; 
  added = entries.players.add(player); 
  if (!added) {throw new Exception("Mock player data generation error");}
} 
 
_initCoursesAndTees(var entries) { 
  bool added;
  
  Course course = new Course(entries.courses.concept); 
  course.name = "Club de golf La Tempête"; 
  course.address = "151 rue des Trois Manoirs, Breakeyville"; 
  course.zipPostalCode = "G0S 1E2"; 
  course.country = "Canada"; 
  course.state = "Quebec"; 
  course.websiteUrl = "http://www.golflatempete.com/en/accueil.asp"; 
  course.locationUrl = "http://goo.gl/maps/HBdvp"; 
  course.phoneNumber = "418-832-8111"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  Tee tee = new Tee(course.courseTees.concept);
  tee = new Tee(course.courseTees.concept);
  tee.name = "Noir";
  tee.color = "#000000";
  tee.slope = 137;
  tee.rating = 74.9;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Bleu";
  tee.color = "#235DFC";
  tee.slope = 133;
  tee.rating = 72.6;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Blanc";
  tee.color = "#FFFFFF";
  tee.slope = 122;
  tee.rating = 69.8;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Jaune";
  tee.color = "#FFFC45";
  tee.slope = 130;
  tee.rating = 73.3;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Rouge";
  tee.color = "#F23900";
  tee.slope = 124;
  tee.rating = 70.5;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  
  course = new Course(entries.courses.concept); 
  course.name = "Club de golf Lévis"; 
  course.address = "6100 boulevard de la Rive Sud, Lévis"; 
  course.zipPostalCode = "G6V8Z7"; 
  course.country = "Canada"; 
  course.state = "Quebec"; 
  course.websiteUrl = "http://www.golflevis.com/"; 
  course.locationUrl = "http://goo.gl/maps/9Kscr"; 
  course.phoneNumber = "418-837-3618"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Bleu";
  tee.color = "#235DFC";
  tee.slope = 127;
  tee.rating = 72.00;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Blanc";
  tee.color = "#FFFFFF";
  tee.slope = 122;
  tee.rating = 69.0;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Jaune";
  tee.color = "#FFFC45";
  tee.slope = 125;
  tee.rating = 71.9;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Rouge";
  tee.color = "#F23900";
  tee.slope = 121;
  tee.rating = 69.8;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  
  course = new Course(entries.courses.concept); 
  course.name = "Club de golf du Bic"; 
  course.address = "150, route du Golf, Rimouski"; 
  course.zipPostalCode = "G0L1B0"; 
  course.country = "Canada"; 
  course.state = "Quebec"; 
  course.websiteUrl = "http://www.clubdegolfbic.com/"; 
  course.locationUrl = "http://goo.gl/maps/eRU01"; 
  course.phoneNumber = "418-736-5323"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Bleu";
  tee.color = "#235DFC";
  tee.slope = 127;
  tee.rating = 71.3;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Blanc";
  tee.color = "#FFFFFF";
  tee.slope = 123;
  tee.rating = 69.5;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Vert";
  tee.color = "#329C4A";
  tee.slope = 110;
  tee.rating = 65.4;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Rouge";
  tee.color = "#F23900";
  tee.slope = 120;
  tee.rating = 69.2;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  
  course = new Course(entries.courses.concept); 
  course.name = "Kapalua Plantation Course"; 
  course.address = "2000 Plantation Club Drive, Lahaina"; 
  course.zipPostalCode = "96761"; 
  course.country = "United States"; 
  course.state = "Hawai"; 
  course.websiteUrl = "http://kapalua.com/golf/plantation-course"; 
  course.locationUrl = "http://goo.gl/maps/VOieK"; 
  course.phoneNumber = "877-527-2582"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Championship";
  tee.color = "#000000";
  tee.slope = 138;
  tee.rating = 74.9;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Regular";
  tee.color = "#EBCD0C";
  tee.slope = 130;
  tee.rating = 71.7;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Foward";
  tee.color = "#F23900";
  tee.slope = 129;
  tee.rating = 73.2;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  
  course = new Course(entries.courses.concept); 
  course.name = "Bethpage State Park Black Course"; 
  course.address = "99 Quaker Meetinghouse Road, Farmingdale"; 
  course.zipPostalCode = "11735"; 
  course.country = "United States"; 
  course.state = "New York"; 
  course.websiteUrl = "http://nysparks.com/golf-courses/11/details.aspx"; 
  course.locationUrl = "http://goo.gl/maps/Kh4sU"; 
  course.phoneNumber = "516-249-0700"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Championship";
  tee.color = "#000000";
  tee.slope = 148;
  tee.rating = 76.6;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Regulation";
  tee.color = "#EBCD0C";
  tee.slope = 140;
  tee.rating = 73.1;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
  
  
  course = new Course(entries.courses.concept); 
  course.name = "Plantation Preserve Golf Course & Club"; 
  course.address = "7050 West Broward Boulevard, Plantation"; 
  course.zipPostalCode = "33317"; 
  course.country = "United States"; 
  course.state = "Florida"; 
  course.websiteUrl = "http://www.plantation.org/Golf/Plantation-Preserve/"; 
  course.locationUrl = "http://goo.gl/maps/kBscw"; 
  course.phoneNumber = "954-585-5020"; 
  added = entries.courses.add(course); 
  if (!added) {throw new Exception("Mock course data generation error");}
  
  tee = new Tee(course.courseTees.concept);
  tee.name = "Black";
  tee.color = "#000000";
  tee.slope = 136;
  tee.rating = 74.2;
  tee.parentCourse = course;
  added = course.courseTees.add(tee);
  if (!added) {throw new Exception("Mock tee data generation error");}
} 
 
_initGames(var entries) {
  Players players = entries.players;
  Courses courses = entries.courses;

  Player mfg = players.singleWhereAttributeId('email', 'mfgiguere@gmail.com');
  Player pon = players.singleWhereAttributeId('email', 'nadeau.pierrot@gmail.com');
  Player dr = players.singleWhereAttributeId('email', 'dzenanr@gmail.com');
  Player tw = players.singleWhereAttributeId('email', 'twoods@nike.com');
  Player mw = players.singleWhereAttributeId('email', 'michellewie@gmail.com');
  
  Course tempete = courses.singleWhereAttributeId('name', 'Club de golf La Tempête'); //Noir Bleu Blanc Jaune Rouge
  Course levis = courses.singleWhereAttributeId('name', 'Club de golf Lévis'); //Bleu Blanc Jaune Rouge
  Course bic = courses.singleWhereAttributeId('name', 'Club de golf du Bic'); //Bleu Blanc Vert Rouge
  Course kapalua = courses.singleWhereAttributeId('name', 'Kapalua Plantation Course'); //Championship Regular Foward
  Course bethpage = courses.singleWhereAttributeId('name', 'Bethpage State Park Black Course'); //Championship Regulation

  Tee tempeteNoir = tempete.courseTees.singleWhere((x) => x.name == 'Noir');
  Tee tempeteBleu = tempete.courseTees.singleWhere((x) => x.name == 'Bleu');
  Tee tempeteBlanc = tempete.courseTees.singleWhere((x) => x.name == 'Blanc');
  Tee tempeteJaune = tempete.courseTees.internalList.singleWhere((x) => x.name == 'Jaune');
  Tee tempeteRouge = tempete.courseTees.singleWhere((x) => x.name == 'Rouge');
  
  Tee levisBleu = levis.courseTees.singleWhere((x) => x.name == 'Bleu');
  Tee levisBlanc = levis.courseTees.singleWhere((x) => x.name == 'Blanc');
  Tee levisJaune = levis.courseTees.singleWhere((x) => x.name == 'Jaune');
  Tee levisRouge = levis.courseTees.singleWhere((x) => x.name == 'Rouge');
  
  Tee bicBleu = bic.courseTees.singleWhere((x) => x.name == 'Bleu');
  Tee bicBlanc = bic.courseTees.singleWhere((x) => x.name == 'Blanc');
  Tee bicVert = bic.courseTees.singleWhere((x) => x.name == 'Vert');
  Tee bicRouge =bic.courseTees.singleWhere((x) => x.name == 'Rouge');

  Tee kapaChamp = kapalua.courseTees.singleWhere((x) => x.name == 'Championship');
  Tee kapaReg = kapalua.courseTees.singleWhere((x) => x.name == 'Regular');
  Tee kapaFwd = kapalua.courseTees.singleWhere((x) => x.name == 'Foward');
  
  Tee bethChamp = bethpage.courseTees.singleWhere((x) => x.name == 'Championship');
  Tee bethReg = bethpage.courseTees.singleWhere((x) => x.name == 'Regulation');
  
  Game game;
  bool added;
  
  //Games mfg
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2011,5,27);
  game.realScore = 86;
  game.equitableScore = 85;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2011,6,10);
  game.realScore = 89;
  game.equitableScore = 88;
  game.teePlayed = bicBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = bicBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2011,6,26);
  game.realScore = 94;
  game.equitableScore = 91;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2011,7,12);
  game.realScore = 88;
  game.equitableScore = 88;
  game.teePlayed = bicBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = bicBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,6,1);
  game.realScore = 84;
  game.equitableScore = 83;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,6,23);
  game.realScore = 88;
  game.equitableScore = 86;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept); //oldest (20th) for calculation
  game.datePlayed = new DateTime(2012,7,2);
  game.realScore = 74;
  game.equitableScore = 73;
  game.teePlayed = bicBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = bicBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,7,10);
  game.realScore = 92;
  game.equitableScore = 89;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,7,17);
  game.realScore = 85;
  game.equitableScore = 83;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,3);
  game.realScore = 84;
  game.equitableScore = 84;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,6);
  game.realScore = 81;
  game.equitableScore = 80;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,11);
  game.realScore = 82;
  game.equitableScore = 82;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,19);
  game.realScore = 78;
  game.equitableScore = 78;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,21);
  game.realScore = 89;
  game.equitableScore = 87;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,24);
  game.realScore = 83;
  game.equitableScore = 82;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,9,5);
  game.realScore = 86;
  game.equitableScore = 85;
  game.teePlayed = levisBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,3,13);
  game.realScore = 88;
  game.equitableScore = 86;
  game.teePlayed = kapaReg;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = kapaReg.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,3,14);
  game.realScore = 84;
  game.equitableScore = 84;
  game.teePlayed = kapaReg;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = kapaReg.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,3,15);
  game.realScore = 87;
  game.equitableScore = 86;
  game.teePlayed = kapaReg;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = kapaReg.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,3,17);
  game.realScore = 89;
  game.equitableScore = 87;
  game.teePlayed = kapaChamp;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = kapaChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,5,29);
  game.realScore = 94;
  game.equitableScore = 91;
  game.teePlayed = tempeteBleu;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,10);
  game.realScore = 85;
  game.equitableScore = 83;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,4);
  game.realScore = 88;
  game.equitableScore = 86;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,8);
  game.realScore = 79;
  game.equitableScore = 78;
  game.teePlayed = tempeteBleu;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
    
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,12);
  game.realScore = 77;
  game.equitableScore = 77;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mfg.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,25);
  game.realScore = 81;
  game.equitableScore = 80;
  game.teePlayed = tempeteBlanc;
  game.gamePlayer = mfg;
  mfg.gamesPlayed.add(game);
  added = tempeteBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  if (mfg.gamesPlayed.count != 26)  {throw new Exception("Wrong number of games for mfg data generation");}
  

  //Games pon
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,6,21);
  game.realScore = 77;
  game.equitableScore = 75;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,7,14);
  game.realScore = 79;
  game.equitableScore = 79;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,11);
  game.realScore = 84;
  game.equitableScore = 83;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,16);
  game.realScore = 88;
  game.equitableScore = 85;
  game.teePlayed = levisBlanc;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,22);
  game.realScore = 79;
  game.equitableScore = 78;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,8,31);
  game.realScore = 83;
  game.equitableScore = 83;
  game.teePlayed = levisBlanc;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,9,3);
  game.realScore = 78;
  game.equitableScore = 77;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,16);
  game.realScore = 85;
  game.equitableScore = 84;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,20);
  game.realScore = 84;
  game.equitableScore = 83;
  game.teePlayed = bicBlanc;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = bicBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,21);
  game.realScore = 88;
  game.equitableScore = 86;
  game.teePlayed = bicBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = bicBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,25);
  game.realScore = 90;
  game.equitableScore = 88;
  game.teePlayed = levisBlanc;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,12);
  game.realScore = 94;
  game.equitableScore = 91;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,21);
  game.realScore = 97;
  game.equitableScore = 94;
  game.teePlayed = levisBleu;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(pon.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,10,10);
  game.realScore = 104;
  game.equitableScore = 99;
  game.teePlayed = levisBlanc;
  game.gamePlayer = pon;
  pon.gamesPlayed.add(game);
  added = levisBlanc.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  if (pon.gamesPlayed.count != 14)  {throw new Exception("Wrong number of games for mfg data generation");}
  
  //Games dr
  game = new Game(dr.gamesPlayed.concept);
  game.datePlayed = new DateTime(2010,8,25);
  game.realScore = 76;
  game.equitableScore = 74;
  game.teePlayed = tempeteNoir;
  game.gamePlayer = dr;
  dr.gamesPlayed.add(game);
  added = tempeteNoir.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(dr.gamesPlayed.concept);
  game.datePlayed = new DateTime(2011,10,1);
  game.realScore = 79;
  game.equitableScore = 78;
  game.teePlayed = levisBleu;
  game.gamePlayer = dr;
  dr.gamesPlayed.add(game);
  added = levisBleu.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(dr.gamesPlayed.concept);
  game.datePlayed = new DateTime(2012,6,22);
  game.realScore = 81;
  game.equitableScore = 80;
  game.teePlayed = tempeteNoir;
  game.gamePlayer = dr;
  dr.gamesPlayed.add(game);
  added = tempeteNoir.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(dr.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,24);
  game.realScore = 74;
  game.equitableScore = 74;
  game.teePlayed = tempeteNoir;
  game.gamePlayer = dr;
  dr.gamesPlayed.add(game);
  added = tempeteNoir.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  if (dr.gamesPlayed.count != 4)  {throw new Exception("Wrong number of games for mfg data generation");}
  
  //Games tw
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,20);
  game.realScore = 68;
  game.equitableScore = 67;
  game.teePlayed = kapaChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = kapaChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,21);
  game.realScore = 71;
  game.equitableScore = 71;
  game.teePlayed = kapaChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = kapaChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,22);
  game.realScore = 66;
  game.equitableScore = 66;
  game.teePlayed = kapaChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = kapaChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,23);
  game.realScore = 72;
  game.equitableScore = 72;
  game.teePlayed = kapaChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = kapaChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,9,1);
  game.realScore = 75;
  game.equitableScore = 73;
  game.teePlayed = bethChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = bethChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,9,2);
  game.realScore = 72;
  game.equitableScore = 72;
  game.teePlayed = bethChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = bethChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(tw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,9,3);
  game.realScore = 70;
  game.equitableScore = 69;
  game.teePlayed = bethChamp;
  game.gamePlayer = tw;
  tw.gamesPlayed.add(game);
  added = bethChamp.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  if (tw.gamesPlayed.count != 7)  {throw new Exception("Wrong number of games for mfg data generation");}
  
  //Games mw
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,22);
  game.realScore = 74;
  game.equitableScore = 73;
  game.teePlayed = kapaFwd;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = kapaFwd.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,23);
  game.realScore = 77;
  game.equitableScore = 75;
  game.teePlayed = kapaFwd;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = kapaFwd.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,6,24);
  game.realScore = 69;
  game.equitableScore = 69;
  game.teePlayed = kapaFwd;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = kapaFwd.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,4);
  game.realScore = 70;
  game.equitableScore = 70;
  game.teePlayed = bethReg;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = bethReg.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,5);
  game.realScore = 82;
  game.equitableScore = 81;
  game.teePlayed = bethReg;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = bethReg.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,19);
  game.realScore = 83;
  game.equitableScore = 82;
  game.teePlayed = levisRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = levisRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,7,20);
  game.realScore = 77;
  game.equitableScore = 75;
  game.teePlayed = levisRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = levisRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,4);
  game.realScore = 76;
  game.equitableScore = 76;
  game.teePlayed = tempeteRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = tempeteRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,5);
  game.realScore = 75;
  game.equitableScore = 75;
  game.teePlayed = tempeteRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = tempeteRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,6);
  game.realScore = 77;
  game.equitableScore = 76;
  game.teePlayed = tempeteRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = tempeteRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  game = new Game(mw.gamesPlayed.concept);
  game.datePlayed = new DateTime(2013,8,7);
  game.realScore = 72;
  game.equitableScore = 72;
  game.teePlayed = tempeteRouge;
  game.gamePlayer = mw;
  mw.gamesPlayed.add(game);
  added = tempeteRouge.gamesPlayedOn.add(game);
  if (!added) {throw new Exception("Mock game data generation error");}
  
  if (mw.gamesPlayed.count != 11)  {throw new Exception("Wrong number of games for mfg data generation");}
}

