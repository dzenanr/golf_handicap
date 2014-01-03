library utils;

import "dart:html"; 

/**
 * Buils a KeyCode map vs their textual representation
 * Necessary to ensure cross-platform compatibility
 */
Map<int, String> getNumericCodes() {
  Map<int, String> numericCodes = new Map<int,String>();
  numericCodes[KeyCode.ZERO] = '0';
  numericCodes[KeyCode.ONE] = '1';
  numericCodes[KeyCode.TWO] = '2';
  numericCodes[KeyCode.THREE] = '3';
  numericCodes[KeyCode.FOUR] = '4';
  numericCodes[KeyCode.FIVE] = '5';
  numericCodes[KeyCode.SIX] = '6';
  numericCodes[KeyCode.SEVEN] = '7';
  numericCodes[KeyCode.EIGHT] = '8';
  numericCodes[KeyCode.NINE] = '9';
  return numericCodes;
}

void integerInputMask(KeyboardEvent e) {
  int keyCode = e.keyCode;
  if (keyCode == KeyCode.TAB || keyCode == KeyCode.BACKSPACE) {
    return;
  }
  else {
    Map<int, String> numericCodes = getNumericCodes();
    InputElement slope = (e.target as InputElement);
    
    if (!numericCodes.keys.contains(keyCode)) {
      e.preventDefault();
    }
  }
}

void doubleInputMask(KeyboardEvent e) {
  int keyCode = e.keyCode;
  if (keyCode == KeyCode.TAB || 
      keyCode == KeyCode.BACKSPACE ||
      keyCode == KeyCode.PERIOD) {
    return;
  }
  else {
    Map<int, String> numericCodes = getNumericCodes();
    InputElement slope = (e.target as InputElement);
    
    if (!numericCodes.keys.contains(keyCode)) {
      e.preventDefault();
    }
  }
}

void dateInputMask(KeyboardEvent e) {
  int keyCode = e.keyCode;
  
  if (keyCode == KeyCode.TAB || keyCode == KeyCode.BACKSPACE) {
    return;
  }
  else if (keyCode == KeyCode.ENTER) {
    clearDateIfInvalid(e);
    return;
  }
  else {
    Map<int, String> numericCodes = getNumericCodes();
    InputElement date = (e.target as InputElement);
    
    if (!numericCodes.keys.contains(keyCode)) {
      e.preventDefault();
    }
    else {
      if (date.value.length == 3 || date.value.length == 6) {
        date.value = date.value + numericCodes[keyCode] + '-';
        e.preventDefault();
      }
      else if (date.value.length == 4 || date.value.length == 7) {
        date.value = date.value + '-' + numericCodes[keyCode];
        e.preventDefault();
      }
    }
  }
}

void clearDateIfInvalid(Event e) {
  InputElement date = (e.target as InputElement);
  if (date.value != null && date.value.length != 10) {
    date.value = null;
  }
}


bool moreThanOnePeriod(String value) {
  if (value.length < 2) {
    return false;
  }
  else {
    if (value.indexOf('.') != value.lastIndexOf('.')) return true;
    return false;
  }
}

void fillStatesList(String country, SelectElement ddlState) {
  ddlState.nodes.clear();
  OptionElement selectElement = new OptionElement(data:null, value:null, selected:true);
  selectElement.innerHtml = "Select";
  ddlState.nodes.add(selectElement);
  if (country == 'Canada') {
    ddlState.nodes.add(new OptionElement(data:'Alberta', value:'Alberta', selected:false));
    ddlState.nodes.add(new OptionElement(data:'British Columbia', value:'British Columbia', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Manitoba', value:'Manitoba', selected:false));
    ddlState.nodes.add(new OptionElement(data:'New Brunswick', value:'New Brunswick', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Newfoundland and Labrador', value:'Newfoundland and Labrador', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Nova Scotia', value:'Nova Scotia', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Northwest Territories', value:'Northwest Territories', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Nunavut', value:'Nunavut', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Ontario', value:'Ontario', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Prince Edward Island', value:'Prince Edward Island', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Saskatchewan', value:'Saskatchewan', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Quebec', value:'Quebec', selected:false));
    ddlState.nodes.add(new OptionElement(data:'Yukon', value:'Yukon', selected:false));
  }
  else if (country == 'United States') {
    ddlState.nodes.add(new OptionElement(data:'Alaska', value:'Alaska', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Alabama', value:'Alabama', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Arkansas', value:'Arkansas', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Arizona', value:'Arizona', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'California', value:'California', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Colorado', value:'Colorado', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Connecticut', value:'Connecticut', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'District of Columbia', value:'District of Columbia', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Delaware', value:'Delaware', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Florida', value:'Florida', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Georgia', value:'Georgia', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Hawai', value:'Hawai', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Iowa', value:'Iowa', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Idaho', value:'Idaho', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Illinois', value:'Illinois', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Indiana', value:'Indiana', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Kansas', value:'Kansas', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Kentucky', value:'Kentucky', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Louisiana', value:'Louisiana', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Massachusetts', value:'Massachusetts', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Maryland', value:'Maryland', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Maine', value:'Maine', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Michigan', value:'Michigan', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Minnesota', value:'Minnesota', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Missouri', value:'Missouri', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Mississippi', value:'Mississippi', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Montana', value:'Montana', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'North Carolina', value:'North Carolina', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'North Dakota', value:'North Dakota', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Nebraska', value:'Nebraska', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'New Hampshire', value:'New Hampshire', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'New Jersey', value:'New Jersey', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'New Mexico', value:'New Mexico', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Nevada', value:'Nevada', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'New York', value:'New York', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Ohio', value:'Ohio', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Oklahoma', value:'Oklahoma', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Oregon', value:'Oregon', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Pennsylvania', value:'Pennsylvania', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Rhode Island', value:'Rhode Island', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'South Carolina', value:'South Carolina', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'South Dakota', value:'South Dakota', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Tennessee', value:'Tennessee', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Texas', value:'Texas', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Utah', value:'Utah', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Virginia', value:'Virginia', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Vermont', value:'Vermont', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Washington', value:'Washington', selected:false));   
    ddlState.nodes.add(new OptionElement(data:'Wisconsin', value:'Wisconsin', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'West Virginia', value:'West Virginia', selected:false));      
    ddlState.nodes.add(new OptionElement(data:'Wyoming', value:'Wyoming', selected:false));            
    
  }
}