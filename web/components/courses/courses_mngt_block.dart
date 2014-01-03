library courses_mngt_block;

import 'package:polymer/polymer.dart';
import "package:golf_handicap/golf_handicap.dart";

@CustomTag('courses-mngt-block')
class CoursesMngtBlock extends PolymerElement {
  @published Courses courses;
  @published Course currentCourse;
  @published bool isDisplayed = false;
  @published Function saveFunction;

  @observable bool addMode = true;
  @observable bool displayList = true;

  CoursesMngtBlock.created() : super.created();

  void coursesSectionClosed(bool forAdd) {
    addMode = forAdd;
  }

  void courseSectionClosed() {
    displayList = true;
  }

//  enteredView() {
//    super.enteredView();
//
//  }

}