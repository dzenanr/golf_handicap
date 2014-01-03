part of golf_handicap; 
 
// lib/golf/handicap/tees.dart 
 
class Tee extends TeeGen { 
 
  Tee(Concept concept) : super(concept);
  
  List<ErrorMessage> validate() {
    List<ErrorMessage> errors = new List<ErrorMessage>();
    
    if (name == null || name == '') {
      errors.add(new ErrorMessage('name','The tee name is required'));
    }
    
    if (color == null || color == '') {
      errors.add(new ErrorMessage('color','The tee color is required'));
    }
    
    if (slope == null) {
      errors.add(new ErrorMessage('slope','The tee slope is required'));
    }
    else if (slope < 55 || slope > 155 ){
      errors.add(new ErrorMessage('slope','A tee slope must be between 55 and 155'));
    }
    
    if (rating == null) {
      errors.add(new ErrorMessage('rating','The tee rating is required'));
    }
    else if (rating < 60 || rating > 80 ){
      errors.add(new ErrorMessage('rating','A tee rating must be between 60 and 80'));
    }
    
    if (parentCourse == null) {
      errors.add(new ErrorMessage('parentCourse','A parent course must be provided for the tee'));
    }
    else {
      bool sameName = false;
      bool sameColor = false;
      for (Tee t in parentCourse.courseTees) {
        if (t.oid != oid) {
          if (t.name == name) {sameName = true;}
          if (t.color == color) {sameColor = true;}
        }
      }
      if (sameName) {
        errors.add(new 
            ErrorMessage('name',"There can't be two tees with the same name on the same course"));
      }
      if (sameColor)  {
        errors.add(new 
            ErrorMessage('color',"There can't be two tees with the same color on the same course"));
      }
    }
    
    return errors;
  }
 
} 
 
class Tees extends TeesGen { 
 
  Tees(Concept concept) : super(concept); 
 
  //Two temporary values, not in JSON
  String currentSort;
  String currentSortOrder;
  
  bool preAdd(Tee tee) {
    if (ErrorMessage.doValidations) {
      List<ErrorMessage> errors = tee.validate();
      if (errors.length > 0) {
        throw new Exception("A tee was not properly validated before being added to a collection");
      }
    }
    return true;
  }
  
  /**
   * Removes a [tee] from the collection only if 
   * no game has been played on this [tee]
   */
  bool tryRemoveTee(Tee tee) {
    if (tee.gamesPlayedOn != null && tee.gamesPlayedOn.length > 0) {
      return false;
    }
    else {
      this.remove(tee);
      return true;
    }
  }
  
} 
 
