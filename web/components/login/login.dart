library login;

import 'dart:html';
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart";

@CustomTag('login-block')
class Login extends PolymerElement {
  @published Players players;
  @published Player currentPlayer;
  
  @published bool isDisplayed;
  @published Function loginFunction;
  @published Function registerFunction;
  
  Login.created() : super.created();
   
  ImageElement _imgErrEmail;
  ImageElement _imgErrPassword;
  
  enteredView() {
    super.enteredView();
    
    if (currentPlayer.oid != null) {
      loginFunction();
    }
  }
  
  // Function to login
  void validateLogin() {

    // Required fields
    if (validateRequired()) {
      // Email/pass validation
      if (login()) {
        // It worked
        loginFunction();
      } else {
        // Combination error
        ShadowRoot sr = this.shadowRoot;
        DivElement logonMsg = sr.querySelector('#box-login-bottom');
        logonMsg.hidden = false;
      }
    }
  }

  // Function to validate login form
  bool validateRequired() {
    ShadowRoot sr = this.shadowRoot;
    // Error images
    _imgErrEmail = sr.querySelector('#imgErrEmail');
    _imgErrPassword = sr.querySelector('#imgErrPassword');
    
    // Required fields
    var email = (sr.querySelector('#email') as InputElement).value;
    var password = (sr.querySelector('#password') as InputElement).value;
    
    // Errors managment
    clearErrors();
    List<ErrorMessage> errors = [];
    if (email == null || email == '') {
      errors.add(new ErrorMessage('email','The email address is required'));
    }
    else {
      RegExp regex = new RegExp(REGEX_EMAIL);
      if (!regex.hasMatch(email)) {
        errors.add(new ErrorMessage('email','The email format is invalid'));
      }
    }

    if (password == null || password == '') {
      errors.add(new ErrorMessage('password','The password is required'));
    }

    // Display errors
    if (errors.length > 0) {
      bindErrors(errors);
      return false;
    } 
    else {
      return true;
    }
  }
  
  // Function which actually tries to login the user
  bool login() {
    ShadowRoot sr = this.shadowRoot;
    // Required fields
    var email = (sr.querySelector('#email') as InputElement).value;
    var password = (sr.querySelector('#password') as InputElement).value;
    
    // Set currentPlayer
    currentPlayer = players.singleWhereAttributeId('email', email);
    
    if (currentPlayer != null && password == currentPlayer.password) {
      // Login succeeded
      return true;
    } 
    else {
      // Didnt work, nullify currentPlayer
      currentPlayer = null;
      return false;
    }
  }
  
  // Clear errors and red dots
  void clearErrors() {
    _imgErrEmail.hidden = true;
    _imgErrEmail.title = '';
    _imgErrPassword.hidden = true;
    _imgErrPassword.title = '';
  }
  
  // Bin errors to proper fields
  void bindErrors(List<ErrorMessage> errors) {
    for (ErrorMessage err in errors) {
      ImageElement errorDisplay;
      switch (err.propertyName) {
        case 'email':
          errorDisplay = _imgErrEmail;
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
  
  // Function to call the register form
  void switchRegister(){
    registerFunction();
  }
  
}