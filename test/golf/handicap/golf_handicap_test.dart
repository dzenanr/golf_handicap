
// test/golf/handicap/golf_handicap_test.dart

import "package:unittest/unittest.dart";

import "package:dartling/dartling.dart";

import "package:golf_handicap/golf_handicap.dart";

testGolfHandicap(Repo repo, String domainCode, String modelCode) {
  var models;
  var session;
  var entries;
  group("Testing ${domainCode}.${modelCode}", () {

    setUp(() {
      models = repo.getDomainModels(domainCode);
      session = models.newSession();
      entries = models.getModelEntries(modelCode);
      expect(entries, isNotNull);
    });

    tearDown(() {
      entries.clear();
    });

    test("Empty Entries Test", () {
      expect(entries.isEmpty, isTrue);
    });

//    test("Data generation test", () {
//      initGolfHandicap(entries);
//      entries.display();
//      entries.displayJson();
//      expect(entries.isEmpty, isFalse);
//    });
//
//    test("JSON Encoding/Decoding with generated data", () {
//      initGolfHandicap(entries);
//      entries.display();
//      entries.displayJson();
//      expect(entries.isEmpty, isFalse);
//
//      //Encode the entries in json
//      var json = JSON.encode(entries.toJson());
//      expect(json, isNotNull);
//      print(json);
//
//      //Decode the json
//      entries.clear();
//      ErrorMessage.doValidations = false;
//      entries.fromJson(JSON.decode(json));
//      ErrorMessage.doValidations = true;
//
//      Players players = entries.players;
//      Courses courses = entries.courses;
//
//      expect(players.count, equals(5));
//      expect(courses.count, equals(6));
//
//      //Test that the relationships are intact
//      Player p = players.singleWhereAttributeId('email', 'mfgiguere@gmail.com');
//      expect(p.gamesPlayed.at(0).teePlayed.parentCourse.name, equals('Club de golf La Tempête'));
//
//      Course c = courses.singleWhereAttributeId('name', 'Club de golf La Tempête');
//      c.address = "TEST CHANGE";
//      expect(c.address, equals(p.gamesPlayed.at(0).teePlayed.parentCourse.address));
//    });

    test("Player validation test", () {
      Player p = new Player(entries.players.concept);
      p.password = "xxx";
      List<ErrorMessage> msg = p.validate();
      expect(msg.length, equals(6));
    });

    test("Handicap differential test", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Game game = players.at(0).gamesPlayed.at(0);
      double differential = game.calculateHandicapDifferential();
      expect(differential, equals(game.handicapDifferential));
      expect(differential, equals(14.1));
    });

    test("Course handicap test", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Game game = players.at(0).gamesPlayed.at(5);
      int courseHdcp = game.calculateCourseHandicap();
    });

    test("Calculating a player's handicap", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player mw = players.singleWhereAttributeId('email', 'michellewie@gmail.com');
      double hdcp = mw.calculatePlayerHandicap();
      expect(hdcp, equals(-1.2));

      //Make sure the values were calculated
      //No handicap can be calculated before player at least 5 games
      mw.gamesPlayed.sort((Game a, Game b) => a.datePlayed.compareTo(b.datePlayed));
      int i = 1;
      for (Game g in mw.gamesPlayed) {
        expect(g.handicapDifferential, isNotNull);
        if (i >= 5) {
          expect(g.playerHandicapAfter, isNotNull);
        }
        if (i >= 6) {
          expect(g.netScore, isNotNull);
        }
        i++;
      }

      //After a very good game, it should improve
      Game goodGame = mw.gamesPlayed.at(0).copy();
      goodGame.datePlayed = new DateTime(2013,12,1);
      goodGame.realScore = 66;
      goodGame.equitableScore = 65;
      goodGame.handicapDifferential = null;
      mw.gamesPlayed.add(goodGame);
      double improvedHdcp = mw.calculatePlayerHandicap();
      expect(hdcp, greaterThan(improvedHdcp));
      expect(improvedHdcp.toString(), equals(mw.getCurrentHandicap()));
    });

    test("Handicap getting worse", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player mfg = players.singleWhereAttributeId('email', 'mfgiguere@gmail.com');
      int gameCount = mfg.gamesPlayed.length;
      double hdcp = mfg.calculatePlayerHandicap();
      expect(hdcp, equals(8.3));
      //The 20th game was a very good one
      //If we post a bad one, this score is erased and the
      //handicap should get worse
      Game badGame = mfg.gamesPlayed.at(0).copy();
      badGame.datePlayed = new DateTime(2013,12,1);
      badGame.realScore = 103;
      badGame.equitableScore = 99;
      badGame.handicapDifferential = null;
      mfg.gamesPlayed.add(badGame);
      double worseningHdcp = mfg.calculatePlayerHandicap();
      expect(worseningHdcp, greaterThan(hdcp));
    });

    test("Insert a game", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player mfg = players.singleWhereAttributeId('email', 'mfgiguere@gmail.com');
      int gameCount = mfg.gamesPlayed.length;
      double hdcp = mfg.calculatePlayerHandicap();
      expect(hdcp, equals(8.3));
      Game lastGame = mfg.gamesPlayed.at(mfg.gamesPlayed.length-1);
      expect(hdcp, equals(lastGame.playerHandicapAfter));
      double hdcpGameBefore = mfg.gamesPlayed.at(mfg.gamesPlayed.length-2).playerHandicapAfter;

      //There are games at those dates:
      //2013-08-12
      //2013-08-25
      //Insert a very good game just before will make the hdcp of
      //those two improve
      Game goodGame = mfg.gamesPlayed.at(0).copy();
      goodGame.datePlayed = new DateTime(2013,08,11);
      goodGame.realScore = 66;
      goodGame.equitableScore = 65;
      goodGame.handicapDifferential = null;
      mfg.gamesPlayed.add(goodGame);

      mfg.clearHandicapsAfterGame(goodGame);

      double improvedHdcp = mfg.calculatePlayerHandicap();

      expect(improvedHdcp, equals(lastGame.playerHandicapAfter));
      expect(hdcp, greaterThan(improvedHdcp));
      double hdcpGameBeforeImp = mfg.gamesPlayed.at(mfg.gamesPlayed.length-2).playerHandicapAfter;
      expect(hdcpGameBefore, greaterThan(hdcpGameBeforeImp));
    });

    test("Not enough games for handicap", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player dz = players.singleWhereAttributeId('email', 'dzenanr@gmail.com');
      double hdcp = dz.calculatePlayerHandicap();
      expect(hdcp, isNull);
    });

    test("One-game handicap (after 5th)", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player dz = players.singleWhereAttributeId('email', 'dzenanr@gmail.com');
      Game game = dz.gamesPlayed.at(0).copy();
      game.datePlayed = new DateTime(2013,12,1);
      game.realScore = 88;
      game.equitableScore = 85;
      game.handicapDifferential = null;
      dz.gamesPlayed.add(game);
      double hdcp = dz.calculatePlayerHandicap();
      expect(hdcp, -0.7);
    });

    test("Favorite course", () {
      initGolfHandicap(entries);
      Players players = entries.players;
      Player mfg = players.singleWhereAttributeId('email', 'mfgiguere@gmail.com');
      Course favoriteCourse = mfg.getFavoriteCourse();
      expect(favoriteCourse.name, equals('Club de golf La Tempête'));

      Player mw = players.singleWhereAttributeId('email', 'michellewie@gmail.com');
      favoriteCourse = mw.getFavoriteCourse();
      expect(favoriteCourse.name, equals('Club de golf La Tempête'));
    });


//    test("Testing bi-directional links after json encode then decode", () {
//      entries.clear;
//      Player p1 = new Player(entries.players.concept);
//      p1.email = 'gberube@gmail.com';
//      p1.password = 'abc123';
//      p1.firstName = 'Ghislain';
//      p1.lastName = 'Bérubé';
//      p1.birthDate = new DateTime(1980,1,1);
//      p1.sex = 'M';
//      p1.phoneNumber = '418-333-4444';
//
//      Game g1 = new Game(p1.gamesPlayed.concept);
//      g1.datePlayed = new DateTime(2013,6,22);
//      g1.realScore = 87;
//      g1.equitableScore = 84;
//
//      Game g2 = new Game(p1.gamesPlayed.concept);
//      g2.datePlayed =new DateTime(2013, 7, 15);
//      g2.realScore = 77;
//      g2.equitableScore = 76;
//
//      Course c1 = new Course(entries.courses.concept);
//      c1.name = 'Pebble Beach Golf Club';
//      c1.websiteUrl = 'http://www.pebblebeach.com/golf/pebble-beach-golf-links';
//
//      Tee t1 = new Tee(c1.courseTees.concept);
//      t1.name = "Black tee";
//      t1.color = "#000000";
//      t1.slope = 145;
//      t1.rating = 75.5;
//
//      bool added;
//
//      //Links between a course and its tees
//      t1.parentCourse = c1; //mandatory - othewise the add of t1 in courseTees ne does not work
//      added = c1.courseTees.add(t1);
//      expect(added, isTrue);
//
//      //Link between a player and a game
//      g1.gamePlayer = p1; //mandatory property of the game
//      g1.teePlayed = t1; //mandatory property of the game
//      g2.gamePlayer = p1; //mandatory property of the game
//      g2.teePlayed = t1; //mandatory property of the game
//      added = p1.gamesPlayed.add(g1);
//      expect(added, isTrue);
//      added = p1.gamesPlayed.add(g2);
//      expect(added, isTrue);
//
//      //Linkts between a game and its tee
//      added = t1.gamesPlayedOn.add(g1);
//      expect(added, isTrue);
//      added = t1.gamesPlayedOn.add(g2);
//      expect(added, isTrue);
//
//      //*********** **************************************************************
//      //*********** THE TEST IS OK BEFORE ENCODING AND DECODING IN JSON ********* //
//      //*********** **************************************************************
//      Game ga = t1.gamesPlayedOn.internalList[0];
//      Game gb = p1.gamesPlayed.internalList[0];
//      ga.realScore = 60;
//      expect(ga.realScore, equals(gb.realScore));
//
//      //Encode the entries in json
//      entries.courses.add(c1);
//      entries.players.add(p1);
//      var json = entries.toJson();
//      expect(json, isNotNull);
//      print(json);
//
//      //Decode the json
//      entries.clear();
//      ErrorMessage.doValidations = false;
//      entries.fromJson(json);
//      ErrorMessage.doValidations = true;
//
//      //Build variables from the player entry point
//      Players pla = entries.players;
//      Player p = pla.internalList[0];
//      Game g = p.gamesPlayed.internalList[0];
//      Tee t = g.teePlayed;
//      Course c = t.parentCourse;
//
//      //Build variables from the course entry point
//      Courses crs = entries.courses;
//      Course cc = crs.internalList[0];
//      Tee tt = cc.courseTees.internalList[0];
//      Game gg = tt.gamesPlayedOn.internalList[0];
//      Player pp = gg.gamePlayer;
//
//      //*************************************************************************
//      //Test that the variables made from both entry point
//      //are actually the same objects in memory and that
//      //making a modification to one impacts both
//      //************************************************************************
//
//      //OK
//      cc.websiteUrl = 'changed url';
//      expect(c.websiteUrl, equals(cc.websiteUrl)); //both are changed
//
//      //OK
//      tt.slope = 100;
//      expect(tt.slope, equals(t.slope)); //both are changed
//
//      //OK
//      pp.firstName = "Roger";
//      expect(pp.firstName, equals(p.firstName)); //both are changed
//
//      //OK
//      expect(gg.oid.toString(), equals(g.oid.toString())); //Same oid
//      g.realScore = 85; //both should change
//      expect(gg.realScore, equals(g.realScore)); //they don't!
//
//      //Same as last but all from Player entry point - OK
//      Game gameFromTee = t.gamesPlayedOn.internalList[0];
//      gameFromTee.equitableScore = 55;
//      expect(gameFromTee.oid.toString(), equals(g.oid.toString()));
//      expect(gameFromTee.equitableScore,equals(g.equitableScore)); //not the same!
//    });

  });
}

testGolfData(GolfRepo golfRepo) {
  testGolfHandicap(golfRepo, GolfRepo.golfDomainCode,
      GolfRepo.golfHandicapModelCode);
}

void main() {
  var golfRepo = new GolfRepo();
  testGolfData(golfRepo);
}

