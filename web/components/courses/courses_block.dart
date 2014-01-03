library courses_block;

import "dart:html"; 
import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart"; 
import "package:dartling/dartling.dart"; 

@CustomTag('courses-block')
class CoursesBlock extends PolymerElement {
  @published Courses courses;
  @published Course currentCourse;
  @published bool isDisplayed = false;
  @published Function returnFunction;
  @published Function saveFunction;
  
  /// Parameters for the dialogs
  @observable bool showConfirmDialog;
  @observable String confirmDialogMessage;
  @observable Oid oidConfirmDialog;
  @observable bool showErrorDialog;
  @observable String errorDialogMessage;
  
  CoursesBlock.created() : super.created();
  
  void openAdd(Event e) {
    currentCourse = new Course(courses.concept);
    isDisplayed = false;
    returnFunction(true);
  }
  
  void openForEdit(Event e) {
    Oid oid = new Oid.ts(int.parse((e.target as InputElement).value));
    currentCourse = courses.singleWhereOid(oid);
    isDisplayed = false;
    returnFunction(false);
  }
    
  /// Event triggerred by a click on the delete icon
  void validateDelete(Event e) {
    Oid oid = new Oid.ts(int.parse((e.target as InputElement).value));
    Course courseToDel = courses.singleWhereOid(oid);
    confirmDialogMessage = "Are you sure you want to delete the course " + 
        courseToDel.name + " ?";
    oidConfirmDialog = oid;
    showConfirmDialog = true;
  }
   
  void doDelete(Oid oid) {
    showConfirmDialog = false;
    bool removed = courses.tryRemoveCourse(courses.singleWhereOid(oid));
    if (!removed) {
      errorDialogMessage = "A course on which games have been played can't be deleted";
      showErrorDialog = true;
    }
    saveFunction();
  }
  
  void changeSort(Event e) {
    String headerId = ((e.target as TableCellElement).id);   
    switch (headerId) {
      case 'thName':
        if (courses.currentSort == 'name' && courses.currentSortOrder == 'asc') {
          courses.currentSortOrder = 'desc';
        }
        else {
          courses.currentSortOrder = 'asc';
        }
        courses.currentSort = 'name';
        break;
      case 'thCountry':
        if (courses.currentSort == 'country' && courses.currentSortOrder == 'asc') {
          courses.currentSortOrder = 'desc';
        }
        else {
          courses.currentSortOrder = 'asc';
        }
        courses.currentSort = 'country';
        break;
      case 'thState':
        if (courses.currentSort == 'state' && courses.currentSortOrder == 'asc') {
          courses.currentSortOrder = 'desc';
        }
        else {
          courses.currentSortOrder = 'asc';
        }
        courses.currentSort = 'state';
        break;
      case 'thPhone':
        if (courses.currentSort == 'phoneNumber' && courses.currentSortOrder == 'asc') {
          courses.currentSortOrder = 'desc';
        }
        else {
          courses.currentSortOrder = 'asc';
        }
        courses.currentSort = 'phoneNumber';
        break;
      case 'thGamesPlayed':
        if (courses.currentSort == 'gamesPlayed' && courses.currentSortOrder == 'asc') {
          courses.currentSortOrder = 'desc';
        }
        else {
          courses.currentSortOrder = 'asc';
        }
        courses.currentSort = 'gamesPlayed';
        break;
    }
    courses.doCurrentSort();
  }
  
}