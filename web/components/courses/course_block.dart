library course_block;

import "dart:html"; 
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 
import "../utilities/utils.dart";
import "../utilities/phone_number.dart";


@CustomTag('course-block')
class CourseBlock extends PolymerElement {
  @published Courses courses;
  @published Course currentCourse;
  @published bool isDisplayed = false;
  @published bool addMode;
  @published Function returnFunction;
  @published Function saveFunction;
  
  /// Parameters for the dialogs
  @observable bool showConfirmDeleteDialog;
  @observable bool showConfirmReturnDialog;
  @observable String confirmDialogMessage;
  @observable Oid oidConfirmDialog;
  @observable bool showErrorDialog;
  @observable String errorDialogMessage;
  @observable bool showSuccessDialog;
  @observable String successDialogMessage;
  @observable Tee currentTee;
  @observable bool showTeeDialog;
  @observable bool teeAddMode;
  
  CourseBlock.created() : super.created();
  
  InputElement _txtName;
  SelectElement _ddlCountry;
  SelectElement _ddlState;
  ImageElement _imgErrName;
  ImageElement _imgErrAddress;
  ImageElement _imgErrZipPostalCode;
  ImageElement _imgErrCountry;
  ImageElement _imgErrState;
  ImageElement _imgErrWebsite;
  ImageElement _imgErrPhone;
  ImageElement _imgErrLocationUrl;
  Element _flsTees;

  enteredView() {
    super.enteredView();    
    bindControls();
    //Workaround a polymer data binding problem (one-way workaround)
    _ddlCountry.value = currentCourse.country;
    fillStatesList(_ddlCountry.value, _ddlState);
    _ddlState.value = currentCourse.state;
    //Unique identifier - binding messes it up
    _txtName = $['txtName'];
    if (!addMode) {
      _flsTees.hidden = false;
      _txtName.value = currentCourse.name;
      _txtName.readOnly = true;
      _txtName.style.backgroundColor = 'LightGray';
      _txtName.style.borderColor = 'DarkGray';
      ($['txtAddress'] as InputElement).focus();
    }
  }
  
  void bindControls() {
    _ddlCountry = $['ddlCountry'];
    _ddlState = $['ddlState'];
    _imgErrName = $['imgErrName'];
    _imgErrAddress = $['imgErrAddress'];
    _imgErrZipPostalCode = $['imgErrZipPostalCode'];
    _imgErrCountry = $['imgErrCountry'];
    _imgErrState = $['imgErrState'];
    _imgErrWebsite = $['imgErrWebsite'];
    _imgErrPhone = $['imgErrPhone'];
    _imgErrLocationUrl = $['imgErrLocationUrl'];
    _flsTees = $['flsTees'];
  }
  
  void changeCountry(Event e) {
    fillStatesList(_ddlCountry.value, _ddlState);
  }
  
  void validateClose(Event e) {
    if (detectChanges()) {
      confirmDialogMessage = "Changes to the course have not been saved. Return anyway?";
      showConfirmReturnDialog = true;
    }
    else {
      closeSection(null);
    }

  }
  
  void closeSection(Oid dummy) {
    isDisplayed = false;
    returnFunction();
  }
   
  void saveCourse(Event e) {
    clearErrors();
    //For potential rollback
    Course oldValues = currentCourse.copy();
    //The binded values are a copy so no update is done util we click save
    getDisplayedValues(currentCourse);
    
    List<ErrorMessage> errors = currentCourse.validate();
    if (errors.length > 0) {
      bindErrors(errors);
      if (!addMode) {
        rollbackChanges(oldValues);
      }
    }
    else {
      if (addMode) {
        courses.add(currentCourse);
        successDialogMessage = "Your new course has been created. Now add some tees to it!";
        showSuccessDialog = true;
        addMode = false;
        _flsTees.hidden = false;
        currentCourse.courseTees.internalList = 
            toObservable(currentCourse.courseTees.internalList);
      }
      else {
        isDisplayed = false;
        returnFunction();
      }
      saveFunction();
    }
  }
  
  void clearErrors() {
    _imgErrName.hidden = true;
    _imgErrName.title = '';
    _imgErrAddress.hidden = true;
    _imgErrAddress.title = '';
    _imgErrZipPostalCode.hidden = true;
    _imgErrZipPostalCode.title = '';
    _imgErrCountry.hidden = true;
    _imgErrCountry.title = '';
    _imgErrState.hidden = true;
    _imgErrState.title = '';
    _imgErrWebsite.hidden = true;
    _imgErrWebsite.title = '';
    _imgErrPhone.hidden = true;
    _imgErrPhone.title = '';
    _imgErrLocationUrl.hidden = true;
    _imgErrLocationUrl.title = '';
  }
  
  void bindErrors(List<ErrorMessage> errors) {
    for (ErrorMessage err in errors) {
      ImageElement errorDisplay;
      switch (err.propertyName) {
        case 'name':
          errorDisplay = _imgErrName;
          break;
        case 'address':
          errorDisplay = _imgErrAddress;
          break;
        case 'zipPostalCode':
          errorDisplay = _imgErrZipPostalCode;
          break;
        case 'country':
          errorDisplay = _imgErrCountry;
          break;
        case 'state':
          errorDisplay = _imgErrState;
          break;
        case 'websiteUrl':
          errorDisplay = _imgErrWebsite;
          break;
        case 'phoneNumber':
          errorDisplay = _imgErrPhone;
          break;
        case 'locationUrl':
          errorDisplay = _imgErrLocationUrl;
          break;
        default :
          throw new Exception('Error in message data binding');
      }
      errorDisplay.hidden = false;
      errorDisplay.title += err.message + '\n';
    }
  }
  
  void getDisplayedValues(Course course) {
    if (addMode) {
      currentCourse = new Course(courses.concept);
      currentCourse.name = ($['txtName'] as InputElement).value;
    }
    currentCourse.address = ($['txtAddress'] as InputElement).value;
    currentCourse.zipPostalCode = ($['txtZipPostalCode'] as InputElement).value.toUpperCase();
    currentCourse.country = _ddlCountry.value; 
    currentCourse.state = _ddlState.value; 
    if (currentCourse.state == "Select") {
      currentCourse.state = null;
    }
    currentCourse.websiteUrl = ($['txtWebsite'] as InputElement).value;
    currentCourse.locationUrl = ($['txtLocation'] as InputElement).value;
    currentCourse.phoneNumber = ($['phone-number'] as PhoneNumber).phoneNumber;
  }
  
  void rollbackChanges(Course oldValues) {
    currentCourse.address = oldValues.address;
    currentCourse.zipPostalCode = oldValues.zipPostalCode;
    currentCourse.country = oldValues.country;
    currentCourse.state = oldValues.state;
    currentCourse.websiteUrl = oldValues.websiteUrl;
    currentCourse.locationUrl = oldValues.locationUrl;
    currentCourse.phoneNumber = oldValues.phoneNumber;
  }
  
  bool detectChanges() {
    if (currentCourse.name != ($['txtName'] as InputElement).value) {
      return true;
    }
    if (currentCourse.address != ($['txtAddress'] as InputElement).value) {
      return true;
    }
    if (currentCourse.zipPostalCode != ($['txtZipPostalCode'] as InputElement).value) {
      return true;
    }
    if (currentCourse.country != _ddlCountry.value) {
      return true;
    }
    if (currentCourse.state != _ddlState.value) {
      return true;
    }
    if (currentCourse.websiteUrl != ($['txtWebsite'] as InputElement).value) {
      return true;
    }
    if (currentCourse.locationUrl != ($['txtLocation'] as InputElement).value) {
      return true;
    }
    if (currentCourse.phoneNumber != ($['phone-number'] as PhoneNumber).phoneNumber) {
      return true;
    }
    return false;
  }
  
  ////////////////////////////////////////
  //Group of methods for the tees
  ////////////////////////////////////////
  
  void openAddTee(Event e) {
    currentTee = new Tee(currentCourse.courseTees.concept);
    teeAddMode = true;
    showTeeDialog = true;
  }
  
  void openTeeForEdit(Event e) {
    Oid oid = new Oid.ts(int.parse((e.target as InputElement).value));
    currentTee = currentCourse.courseTees.singleWhereOid(oid);
    teeAddMode = false;
    showTeeDialog = true;
  }
  
  void validateTeeDelete(Event e) {
    Oid oid = new Oid.ts(int.parse((e.target as InputElement).value));
    Tee teeToDel = currentCourse.courseTees.singleWhereOid(oid);
    confirmDialogMessage = "Are you sure you want to delete the tee " + 
        teeToDel.name + " ?";
    oidConfirmDialog = oid;
    showConfirmDeleteDialog = true;
  }

  void doDelete(Oid oid) {
    showConfirmDeleteDialog = false;
    bool removed = currentCourse.courseTees.tryRemoveTee(
        currentCourse.courseTees.singleWhereOid(oid));
    if (!removed) {
      errorDialogMessage = "A tee on which games have been played can't be deleted";
      showErrorDialog = true;
    }
    saveFunction();
  }
  

  
}