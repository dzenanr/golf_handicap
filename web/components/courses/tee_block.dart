library tee_block;

import 'dart:html';
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 
import "../utilities/utils.dart";

@CustomTag('tee-block')
class TeeBlock extends PolymerElement {
  @published Tee currentTee;
  @published Course currentCourse;
  @published bool showDialog;
  @published bool addMode;
  @published Function saveFunction;
  
  TeeBlock.created() : super.created();
     
  ImageElement _imgErrName;
  ImageElement _imgErrColor;
  ImageElement _imgErrSlope;
  ImageElement _imgErrRating;
  
  enteredView() {
    super.enteredView();   
  }
  
  void saveTee(Event e) {
    //For potential rollback
    Tee oldValues = currentTee.copy(); 
    getDisplayedValues(currentTee);
    List<ErrorMessage> errors = currentTee.validate();
    clearErrors();
    if (errors.length > 0) {
      bindErrors(errors);
      if (!addMode) {
        rollbackChanges(oldValues);
      }
    }
    else {
      if (addMode) {
        currentCourse.courseTees.add(currentTee);
      }
      else {
        forceRefresh();
      }
      showDialog = false;
      saveFunction();
    }
  }

  void cancelAction(Event e) {
    showDialog = false;
  }
  
  void getDisplayedValues(Tee tee) {
    if (addMode) {
      currentTee.parentCourse = currentCourse;
    }
    //Because controls are inside a conditional template we need
    //to access them through the shadow root
    ShadowRoot sr = this.shadowRoot;
    _imgErrName = sr.querySelector('#imgErrName');
    _imgErrColor = sr.querySelector('#imgErrColor');
    _imgErrSlope = sr.querySelector('#imgErrSlope');
    _imgErrRating = sr.querySelector('#imgErrRating');
    currentTee.name = (sr.querySelector('#txtName') as InputElement).value;
    currentTee.color = (sr.querySelector('#ddlColor') as SelectElement).value;
    String slope = (sr.querySelector('#txtSlope') as InputElement).value;
    String rating = (sr.querySelector('#txtRating') as InputElement).value;
    if (slope != null && slope != '') {
      currentTee.slope = int.parse(slope);
    }
    else {
      currentTee.slope = null;
    }
    if (rating != null && rating != '' && !moreThanOnePeriod(rating)) {
      currentTee.rating = double.parse(rating);
    }
    else {
      (sr.querySelector('#txtRating') as InputElement).value = '';
      currentTee.rating = null;
    }
  }
  
  void rollbackChanges(Tee oldValues) {
    currentTee.parentCourse = oldValues.parentCourse;
    currentTee.name = oldValues.name;
    currentTee.color = oldValues.color;
    currentTee.slope = oldValues.slope;
    currentTee.rating = oldValues.rating;
  }
  
  void clearErrors() {
    _imgErrName.title = '';
    _imgErrColor.title = '';
    _imgErrSlope.title = '';
    _imgErrRating.title = '';
    _imgErrName.hidden = true;
    _imgErrRating.hidden = true;
    _imgErrSlope.hidden = true;
    _imgErrColor.hidden = true;
  }
  
  void bindErrors(List<ErrorMessage> errors) {
    for (ErrorMessage err in errors) {
      ImageElement errorDisplay;
      switch (err.propertyName) {
        case 'name':
          errorDisplay = _imgErrName;
          break;
        case 'color':
          errorDisplay = _imgErrColor;
          break;
        case 'slope':
          errorDisplay = _imgErrSlope;
          break;
        case 'rating':
          errorDisplay = _imgErrRating;
          break;
        default :
          throw new Exception('Error in message data binding');
      }
      errorDisplay.hidden = false;
      errorDisplay.title += err.message + "\n";
    }
  }
  
  void forceRefresh() {
    Tee dummyTee = new Tee(currentCourse.courseTees.concept);
    dummyTee.name = "     ";
    dummyTee.color = "     ";
    dummyTee.slope = 100;
    dummyTee.rating = 70.0;
    dummyTee.parentCourse = currentCourse;
    currentCourse.courseTees.add(dummyTee);
    currentCourse.courseTees.remove(dummyTee);
    dummyTee.parentCourse = null;
    dummyTee = null;
  }
  
  void enforceSlopeNumericInputMask(KeyboardEvent e) {
    integerInputMask(e);
  }

  void enforceRatingNumericInputMask(KeyboardEvent e) {
    doubleInputMask(e);
  }    
}