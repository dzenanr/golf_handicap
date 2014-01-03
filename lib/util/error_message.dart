part of golf_handicap; 

class ErrorMessage {
  
  static bool doValidations = true;
  
  String propertyName;
  String message;
  
  ErrorMessage(this.propertyName, this.message); 
}