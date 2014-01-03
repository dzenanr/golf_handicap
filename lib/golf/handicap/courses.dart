part of golf_handicap; 

// lib/golf/handicap/courses.dart 
 
const String REGEX_PHONE = "[0-9]{3}-[0-9]{3}-[0-9]{4}";
const String REGEX_EMAIL = """^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]
                              {0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$""";

const String REGEX_ZIP = """^\\d{5}(-\\d{4})?\$""";

const String REGEX_POSTAL_CODE = """^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1} *\\d{1}[A-Z]{1}\\d{1}\$""";

class Course extends CourseGen { 
 
  Course(Concept concept) : super(concept); 
 
  Course.withId(Concept concept, String name) : 
    super.withId(concept, name); 
  
  int gamesPlayed() {
    int played = 0;
    if (courseTees != null && courseTees.length > 0) {  
      for (Tee tee in courseTees) {
        if (tee.gamesPlayedOn != null) {
          played += tee.gamesPlayedOn.length;
        }
      }
    }
    return played;
  }
  
  
  List<ErrorMessage> validate() {
    List<ErrorMessage> errors = new List<ErrorMessage>();
    
    if (name == null || name == '') {
      errors.add(new ErrorMessage('name','The name of the course is required'));
    }
    else if (name.length > 100) {
      errors.add(new ErrorMessage('name','The name of the course is limited to 100 characters'));
    }
    
    if (country != null && country != '' && country != 'Canada' && country != 'United States') {
      errors.add(new ErrorMessage('country','This system only works for RCGA (Canadian) and USGA (United States) rules of golf'));
    }
    else {
      if (country == 'United States' && zipPostalCode != null && zipPostalCode != '') {
        RegExp regex = new RegExp(REGEX_ZIP);
        if (!regex.hasMatch(zipPostalCode)) {
          errors.add(new ErrorMessage('zipPostalCode','The zip code is not a valid US zip code'));
        }
      }
      if (country == 'Canada' && zipPostalCode != null && zipPostalCode != '') {
        RegExp regex = new RegExp(REGEX_POSTAL_CODE);
        if (!regex.hasMatch(zipPostalCode)) {
          errors.add(new ErrorMessage('zipPostalCode','The postal code is not a valid canadian postal code'));
        }
      }
    }
    
    if (phoneNumber != null && phoneNumber.length > 0) {
      RegExp regex = new RegExp(REGEX_PHONE);
      if (!regex.hasMatch(phoneNumber)) {
        errors.add(new ErrorMessage('phoneNumber','The phone number format is invalid'));
      }
    }
    
    return errors;
  }
 
} 

class Courses extends CoursesGen { 
 
  Courses(Concept concept) : super(concept); 
 
  //Two temporary values, not in JSON
  String currentSort;
  String currentSortOrder;
  
  bool preAdd(Course course) {
    if (ErrorMessage.doValidations) {
      List<ErrorMessage> errors = course.validate();
      if (errors.length > 0) {
        throw new Exception("A course was not properly validated before being added to a collection");
      }
    }
    return true;
  }  
  
  void doCurrentSort() {
    switch (this.currentSort) {
      case 'name':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Course a, Course b) => 
              (a.name.toUpperCase().compareTo(b.name.toUpperCase()))));
        }
        else {
          this.sort(((Course a, Course b) => 
              (b.name.toUpperCase().compareTo(a.name.toUpperCase()))));
        }
        break;
      case 'country':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Course a, Course b) => 
              (a.country.toUpperCase().compareTo(b.country.toUpperCase()))));
        }
        else {
          this.sort(((Course a, Course b) => 
              (b.country.toUpperCase().compareTo(a.country.toUpperCase()))));
        }
        break;
      case 'state':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Course a, Course b) => 
              (a.state.compareTo(b.state))));
        }
        else {
          this.sort(((Course a, Course b) => 
              (b.state.compareTo(a.state))));
        }
        break;
      case 'phoneNumber':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Course a, Course b) => 
              (a.phoneNumber.compareTo(b.phoneNumber))));
        }
        else {
          this.sort(((Course a, Course b) => 
              (b.phoneNumber.compareTo(a.phoneNumber))));
        }
        break;
      case 'gamesPlayed':
        if (this.currentSortOrder == 'asc') {
          this.sort(((Course a, Course b) => 
              (a.gamesPlayed().compareTo(b.gamesPlayed()))));
        }
        else {
          this.sort(((Course a, Course b) => 
              (b.gamesPlayed().compareTo(a.gamesPlayed()))));
        }
        break;
    }
  }
  
  /**
   * Removes a [course] from the collection only if 
   * no game has been played on this [course]
   */
  bool tryRemoveCourse(Course course) {
    bool gameFound = false;
    
    if (course.courseTees != null) {
      for (Tee tee in course.courseTees){
        if (tee.gamesPlayedOn != null && tee.gamesPlayedOn.length > 0) {
          gameFound = true;
          break;
        }
      }
    }
    if (!gameFound) {
      this.remove(course);
      return true;
    }
    return false;
  }

} 
 
