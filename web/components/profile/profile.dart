library profile;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 
import "package:golf_handicap/charts/chart.dart";
import "../utilities/utils.dart";
import "../utilities/phone_number.dart";

@CustomTag('profile-block')
class Profile extends PolymerElement {
  @published bool isNew;
  @published bool isDisplayed;
  @published Player currentPlayer;
  @published Players players;
  @published Function saveFunction;
  @published Function returnFunction;
  @published Function cancelFunction;
  
  @observable String currentHandicap;
  @observable bool graphShown = false;
  @observable Player copyPlayer;
  
  Profile.created() : super.created();
  
  ImageElement _imgErrFirstName;
  ImageElement _imgErrLastName;
  ImageElement _imgErrEmail;
  ImageElement _imgErrBirthDate;
  ImageElement _imgErrSex;
  ImageElement _imgErrPhone;
  ImageElement _imgErrPassword;
  
  enteredView() {
    super.enteredView();
    
    copyPlayer = currentPlayer.copy();
  }

  void saveProfile() {
    //For potential rollback
    Player oldValues = currentPlayer.copy();
    //The binded values are a copy so no update is done util we click save
    getDisplayedValues(currentPlayer, false);
    
    clearErrors();
    List<ErrorMessage> errors = currentPlayer.validate();
    if (errors.length > 0) {
      bindErrors(errors);
      rollbackChanges(oldValues);
    }
    else {      
      // Persistency
      saveFunction();
      
      // Message
      this.shadowRoot.querySelector('#confirmationMsg').innerHtml = 'Profile saved';
      
      new Timer(new Duration(seconds:5), clearMsg);
    }
  }
  
  void clearMsg() {
    var confMsg = this.shadowRoot.querySelector('#confirmationMsg');
    if (confMsg != null) {
      confMsg.innerHtml = '';
    }
  }
  
  void createProfile() {
    //For potential rollback
    currentPlayer = new Player(players.first.concept);
    getDisplayedValues(currentPlayer, true);
    
    clearErrors();
    List<ErrorMessage> errors = currentPlayer.validate();
    if (errors.length > 0) {
      bindErrors(errors);
    }
    else {
      // Add to players list
      players.add(currentPlayer);
      
      // Make collection observable for the first game refresh when creating a player
      currentPlayer.gamesPlayed.internalList = toObservable(currentPlayer.gamesPlayed.internalList);
      
      // Persistency
      saveFunction();
      
      // Redirect to profile page
      returnFunction();
    }
  }
  
  
  // Rollback changes if errors while saving
  void rollbackChanges(Player oldValues) {
    currentPlayer.firstName = oldValues.firstName;
    currentPlayer.lastName = oldValues.lastName;
    currentPlayer.email = oldValues.email;
    currentPlayer.birthDate = oldValues.birthDate;
    currentPlayer.sex = oldValues.sex;
    currentPlayer.phoneNumber = oldValues.phoneNumber;
    currentPlayer.password = oldValues.password;
    copyPlayer.firstName = oldValues.firstName;
    copyPlayer.lastName = oldValues.lastName;
    copyPlayer.email = oldValues.email;
    copyPlayer.birthDate = oldValues.birthDate;
    copyPlayer.sex = oldValues.sex;
    copyPlayer.phoneNumber = oldValues.phoneNumber;
    copyPlayer.password = oldValues.password;
  }

  void getDisplayedValues(Player player, bool addMode) {
    //Because controls are inside a conditional template we need
    //to access them through the shadow root
    ShadowRoot sr = this.shadowRoot;
    _imgErrFirstName = sr.querySelector('#imgErrFirstName');
    _imgErrLastName = sr.querySelector('#imgErrLastName');
    _imgErrEmail = sr.querySelector('#imgErrEmail');
    _imgErrBirthDate = sr.querySelector('#imgErrBirthDate');
    _imgErrSex = sr.querySelector('#imgErrSex');
    _imgErrPhone = sr.querySelector('#imgErrPhone');
    _imgErrPassword = sr.querySelector('#imgErrPassword');
    
    var firstName = (sr.querySelector('#firstname') as InputElement).value;
    if (firstName != "") { player.firstName = firstName; }
    var lastName = (sr.querySelector('#lastname') as InputElement).value;
    if (lastName != "") { player.lastName = lastName; }
    if (addMode) {
      var email = (sr.querySelector('#email') as InputElement).value;
      if (email != "") { player.email = email; }
    }
    var birthDate = (sr.querySelector('#birthdate') as InputElement).value;
    if (birthDate == "") {
      player.birthDate = null;
    }
    else {
      try { player.birthDate = DateTime.parse(birthDate); } catch (e) {}
    }
    var sex = (sr.querySelector('#sex') as SelectElement).value;
    if (sex != "") { player.sex = sex; }
    var phoneNumber = (sr.querySelector('#phone-number') as PhoneNumber).phoneNumber;
    if (phoneNumber != "") { player.phoneNumber = phoneNumber; }
    var password = (sr.querySelector('#password') as InputElement).value;
    if (password != "") { player.password = password; } else { player.password = player.password; }
  }
  
  // Clear error messages
  void clearErrors() {
    _imgErrFirstName.hidden = true;
    _imgErrFirstName.title = '';
    _imgErrLastName.hidden = true;
    _imgErrLastName.title = '';
    _imgErrEmail.hidden = true;
    _imgErrEmail.title = '';
    _imgErrBirthDate.hidden = true;
    _imgErrBirthDate.title = '';
    _imgErrSex.hidden = true;
    _imgErrSex.title = '';
    _imgErrPhone.hidden = true;
    _imgErrPhone.title = '';
    _imgErrPassword.hidden = true;
    _imgErrPassword.title = '';
  }
  
  // Bind error messages to input fields
  void bindErrors(List<ErrorMessage> errors) {
    for (ErrorMessage err in errors) {
      ImageElement errorDisplay;
      switch (err.propertyName) {
        case 'firstName':
          errorDisplay = _imgErrFirstName;
          break;
        case 'lastName':
          errorDisplay = _imgErrLastName;
          break;
        case 'email':
          errorDisplay = _imgErrEmail;
          break;
        case 'birthDate':
          errorDisplay = _imgErrBirthDate;
          break;
        case 'sex':
          errorDisplay = _imgErrSex;
          break;
        case 'phoneNumber':
          errorDisplay = _imgErrPhone;
          break;
        case 'password':
          errorDisplay = _imgErrPassword;
          break;
        default :
          throw new Exception('Error in message data binding');
      }
      errorDisplay.hidden = false;
      errorDisplay.title += err.message + '\n';
    }
  }
  
  void enforceDateInputMask(KeyboardEvent e) {
    dateInputMask(e);
  }
  
  void clearDateInvalid(Event e) {
    clearDateIfInvalid(e);
  }
  
  bool canDisplayGraph() {
    if (currentPlayer.gamesPlayed.count >= 7) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void showGraph() {
    DivElement graphDiv = this.shadowRoot.querySelector('#statsGraph');
    DivElement temphDiv = this.shadowRoot.querySelector('#tempGraph');
    if (!graphShown) {
      List<double> gamesData = new List<double>();
      List<String> labels = new List<String>();
      for (Game game in currentPlayer.gamesPlayed) {
        if (game.playerHandicapAfter != null) {
          gamesData.add(game.playerHandicapAfter);
          labels.add(' ');
        }
      }
      Line chart = new Line({
        'labels' : labels,
        'datasets' : [
                      {
                        'fillColor' : "rgba(70,157,66,0.5)",
                        'strokeColor' : "rgba(0,0,0,1)",
                        'pointColor' : "rgba(0,0,0,1)",
                        'pointStrokeColor' : "#fff",
                        'pointDot' : true,
                        'data' : gamesData,
                      }
                      ]
      }, {
        'scaleOverride' : false, 
        'scaleMinValue' : -10.0, 
        'scaleMaxValue' : 36.0, 
        'scaleStepValue' : null, 
        'bezierCurve' : false, 
        'animation' : true,
        'animationSteps' : 60,
        'animationEasing' : "easeOutQuart",
        'onAnimationComplete' : null,
        'titleText' : 'Handicap progression'     
      });
      graphDiv.innerHtml = '';
      graphDiv.style.height ='450px';
      graphDiv.style.width =  '450px';
      temphDiv.hidden = true;
      chart.show(graphDiv);
    }
    graphShown = true;
  }
  
  void cancelProfile() {
    // Redirect to login page
    cancelFunction();
  }

}