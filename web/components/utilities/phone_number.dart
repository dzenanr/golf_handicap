library phone_number;

import "dart:html"; 
import "utils.dart";
import 'package:polymer/polymer.dart';

@CustomTag('phone-number')
class PhoneNumber extends PolymerElement {
  @published String phoneNumber;
  
  PhoneNumber.created() : super.created();
     
  /**
   * Allows only numeric characters in the field and
   * automaticaly adds dashes
   */
  void enforcePhoneInputMask(KeyboardEvent e) {
    int keyCode = e.keyCode;
    
    if (keyCode == KeyCode.TAB || keyCode == KeyCode.BACKSPACE) {
      return;
    }
    else if (keyCode == KeyCode.ENTER) {
      clearPhoneIfInvalid(e);
      return;
    }
    else {
      Map<int, String> numericCodes = getNumericCodes();
      InputElement phone = (e.target as InputElement);
      
      if (!numericCodes.keys.contains(keyCode)) {
        e.preventDefault();
      }
      else {
        if (phone.value.length == 2 || phone.value.length == 6) {
          phone.value = phone.value + numericCodes[keyCode] + '-';
          e.preventDefault();
        }
        else if (phone.value.length == 3 || phone.value.length == 7) {
          phone.value = phone.value + '-' + numericCodes[keyCode];
          e.preventDefault();
        }
      }
    }
  }
  
  void clearPhoneIfInvalid(Event e) {
    InputElement phone = (e.target as InputElement);
    if (phone.value != null && phone.value.length != 12) {
      phone.value = null;
    }
  }

}