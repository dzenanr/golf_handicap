part of chart;

/**
 * Code based on charts.js by Nick Downie, http://chartjs.org/
 * 
 * (Partial) Dart implementation done by Symcon GmbH, Tim Rasim
 * 
 */

abstract class DartChart {
  
  CanvasElement domNode;

  CanvasElement chartLayer;
  CanvasElement gridLayer;
  CanvasElement titleLayer;
  
  CanvasRenderingContext2D chartLayerContext;
  CanvasRenderingContext2D gridLayerContext;
  CanvasRenderingContext2D titleLayerContext;

  int width = 0;
  int height = 0;
  CanvasRenderingContext2D context;
  Map config, defaultConfig;
  Map<String, List<Map>> data; 
  double animFrameAmount = 0.0;  
  double percentAnimComplete = 0.0;
  Animation animation;
  int widestXLabel;
  Map calculatedScale;
  int labelHeight;
  int scaleHeight;
  int rotateLabels = 0;
  int maxSize;
  int scaleHop;

  DartChart(Map<String, List<Map>> data, Map config) {
    
    this.domNode = new CanvasElement();
    
    //CanvasLayers:
    this.chartLayer = new CanvasElement();
    this.gridLayer = new CanvasElement();
    this.titleLayer = new CanvasElement();
    
    this.data = data;

    if (config != null) {
      this.config = config;
    } else {
      //we will use the dafault configuration
      this.config = new Map();
    }
    
    this.context = this.domNode.getContext("2d");  
    
    this.chartLayerContext = this.chartLayer.getContext("2d");
    this.gridLayerContext = this.gridLayer.getContext("2d");
    this.titleLayerContext = this.titleLayer.getContext("2d");
    
  }

   /*
   * This function has to be overridden 
   */

  void render() {
  }

  void drawTitle(){
    
    if (getConfiguration('titleText') != ''){
      String title = getConfiguration('titleText').toString();
      this.titleLayerContext.save();
      this.titleLayerContext.font = getConfiguration('titleFontStyle').toString() + " " + getConfiguration('titleFontSize').toString() + "px " + getConfiguration('titleFontFamily').toString();
      this.titleLayerContext.fillStyle = getConfiguration('titleFontColor');
      //delete background
      this.gridLayerContext.clearRect(this.width - this.titleLayerContext.measureText(title).width - getConfiguration('titleFontSize') * 2, 0, this.titleLayerContext.measureText(title).width + getConfiguration('titleFontSize') * 2, getConfiguration('titleFontSize') * 2);
      //paint text
      this.titleLayerContext.translate(this.width - this.titleLayerContext.measureText(title).width - getConfiguration('titleFontSize'), getConfiguration('titleFontSize'));
      this.titleLayerContext.fillText(title, 0, 0);
      this.titleLayerContext.restore();
    }    
    
  }
  
  double log10(double value){    
    return math.log(value) / math.log(10);    
  }
  
  double findMaxValue(datasets){
    
    double maxValue = double.NEGATIVE_INFINITY;
    //for every dataset do
    datasets.forEach((dynamic set){
      //calculate maxValue with maximal value in list
      set['data'].forEach((dynamic value) { 
        if (value != null)
          if (value is num){
            maxValue = math.max(value.toDouble(), maxValue);
          } else if (value is List){
            value.forEach( (num interValue) {
              if (interValue != null){
                maxValue = math.max(interValue.toDouble(), maxValue);
              }
            });
          }
      });
    });
    return maxValue;
    
  }
  
  void setScale(){    
    
    Map<String, int> drawingSizes = calculateDrawingSizes(this.maxSize, this.rotateLabels);
    this.labelHeight = drawingSizes['labelHeight'];
    this.scaleHeight = drawingSizes['scaleHeight'];
    this.widestXLabel = drawingSizes['widestXLabel']; 

    //set the scale
    this.calculatedScale = calculateScaling(this.scaleHeight);
    
    this.calculatedScale['labels'] = [];
    populateLabels(this.calculatedScale['labels'], this.calculatedScale['steps'], this.calculatedScale['graphMin'], this.calculatedScale['stepSize']);
    
    this.scaleHop = (this.scaleHeight / this.calculatedScale['steps']).floor();
    
  }
  
  Map calculateScale(){
    
    Map<String, dynamic> scale = new Map<String, dynamic>();
        
    scale['graphMax'] = findMaxValue(this.data['datasets']);
    
    //calculate accurate minvalue
    scale['graphMin'] = double.MAX_FINITE;
    this.data['datasets'].forEach((dynamic set){
      set['data'].forEach((dynamic value) {
        if (value != null)
          if (value is num){
            scale['graphMin'] = math.min(value, scale['graphMin']);
          } else if (value is List){
            value.forEach( (num interValue) {
              if (interValue != null){
                scale['graphMin'] = math.min(interValue.toDouble(), scale['graphMin']);
              }
            });
          }
      });
    });
    
    //check whether min is equal to max
    if (scale['graphMax'] == scale['graphMin']){
      // only one value  
      if (scale['graphMin'] == 0.0){
        scale['graphMax'] =  1.0;
        scale['stepSize'] =  1.0;     
      } else if (scale['graphMin'] == 1.0){
        scale['graphMax'] =  1.0;
        scale['stepSize'] =  1.0;  
        scale['graphMin'] =  0.0;
      } else{
        scale['stepSize'] = scale['graphMin'] * 0.25; 
        scale['graphMin'] =  scale['graphMin'] - scale['stepSize'];
        scale['graphMax'] = scale['graphMax'] + scale['stepSize']; 
      }
    } else {
      double range = scale['graphMax'] - scale['graphMin'];
      //calculate digit-count
      if (log10(range / 12) > 0){
        scale['digits'] = 0;
      } else {
        scale['digits'] = (-1 * log10(range / 12)).ceil();
      }
    }

    return scale;
    
  }
  
  /**
   * 'Rounds'(floor) a value to a length of digit and making it look 'nice'.
   */
  double getNiceMinValue(double value, int digits, double range){
    
    value = value * math.pow(10, digits);
    range = range * math.pow(10, digits);

    bool isNegative = false;
    
    value = value.floor().toDouble();
    
    if (value == 0)
      return 0.0;
    
    if (value < 0){
      isNegative = true;
      value = value * -1;
    }    
    
    //get value length
    int valueLength = log10(value).ceil();
    
    //2 > value / (10^(valueLength - digits)) > 0 
    
    int minimalLength = log10(value - valueLength).floor();
    
    value = (value / math.pow(10, minimalLength - 1)).floor().toDouble();
    
    //set value back to real decimal places
    value = (value * math.pow(10, minimalLength - 1)) / math.pow(10, digits);
    
    if (isNegative)
      value = value * -1;
    
    return value;
      
  }
  
  double calculateStepSize(Map scale, List values,[ int maxSteps ]){
    
    //TODO: implement value-sensitiv stepmatching
    
    double range = scale['graphMax'] - scale['graphMin'];
    
    /*
    int minSteps = 3;    
    double stepSize;

    for (int i = minSteps; i < maxSteps; i++){      
      //TODO: determine best value
      stepSize = getRoundedValue(range/i, scale['digits']);
    }
    */
    
    return getRoundedValue(range/5, scale['digits']);  
    
  }
  
  /**
   * Rounds a value to a length of digit.
   */
  double getRoundedValue(double value, int digits){
    
    value = (value * math.pow(10, digits)).round() / math.pow(10, digits);
    
    bool isNegative = (value < 0);
    double decimalPlaces; //a factor to restore the decimal places

    if (value >= -1 && value <= 1)
      decimalPlaces = math.pow(10, (value != 0 ? (1 / value).round() : 1).toString().length).toDouble(); 
    else 
      decimalPlaces = 1 / (math.pow(10, value.round().toString().length - 1)); 

    int step = (value * decimalPlaces).round().abs();
    value = 10.0;
    if ((value - step).abs() >= (5 - step).abs()) { value = 5.0; }
    if ((value - step).abs() >= (2 - step).abs()) { value = 2.0; }
    if ((value - step).abs() >= (1 - step).abs()) { value = 1.0; }
    
    if (isNegative)
      value = -1 * (value / decimalPlaces);  
    else 
      value = value / decimalPlaces;  
    
    return value;
    
  }
  
  Map calculateScaling(int drawingHeight) {
    
    Map<String, dynamic> scale = new Map<String, dynamic>();    
    
    scale = calculateScale(); 
    
    if (getConfiguration('scaleOverride') && getConfiguration('scaleStepValue') == null){
      scale['graphMin'] =  getConfiguration('scaleMinValue');
      scale['graphMax'] =  getConfiguration('scaleMaxValue');
    } else if (getConfiguration('scaleOverride')){
      return {
        'steps' : ((getConfiguration('scaleMaxValue') - getConfiguration('scaleMinValue')) / getConfiguration('scaleStepValue')).ceil(), 
        'stepSize' : getConfiguration('scaleStepValue'), 
        'graphMin' : getConfiguration('scaleMinValue')
      };
    }

    //calculate fitting digit value
    double rangeDigits = log10(1/(scale['graphMax'] - scale['graphMin']));
    
    double minValueDigits = 0.0;
    if (scale['graphMin'] != 0.0)
      minValueDigits = log10(1/scale['graphMin']);
    
    if (math.max(rangeDigits, minValueDigits) > 1)
      scale['digits'] = math.max(rangeDigits, minValueDigits).ceil();
    else 
      scale['digits'] = 0;

    if (!getConfiguration('scaleOverride')){
      scale['graphMin'] = getNiceMinValue(scale['graphMin'].toDouble(), scale['digits'], scale['graphMax'] - scale['graphMin']);
    }
    
    scale['stepSize'] = calculateStepSize(scale, this.data['values']);
    
    scale['steps'] = ((scale['graphMax'] - scale['graphMin']) / scale['stepSize']).ceil();

    return scale;

  }
  
  int calculateOrderOfMagnitude(num val) {
    
    if (val != 0)
      if ((math.log(val) / math.LN10).floor() >= 0)
        return (math.log(val) / math.LN10).floor();
      else
        return 0;
    else
      return 1;
    
  }

  /*
   * Populate an array of all the labels by interpolating the string.
   */
  void populateLabels(List<Object> labels, int numberOfSteps, double graphMin, double stepSize) {
    
    //convert labels to a fixed fractionDigits length so that they look neater
    int maxDecimalPlaces = math.max(getDecimalPlaces(stepSize),getDecimalPlaces(graphMin));
    NumberFormat f = new NumberFormat.decimalPattern();
    f.minimumFractionDigits = maxDecimalPlaces;
    f.maximumFractionDigits = maxDecimalPlaces;
    
    double labelValue;
    for (int i = 0; i <= numberOfSteps; i++) {
      labelValue = graphMin + (stepSize * i);
      
      dynamic getLabel = getConfiguration('scaleLabel');
      
      if (getLabel != null && getLabel(labelValue, maxDecimalPlaces) != null)
        labels.add(getLabel(labelValue, maxDecimalPlaces));
      else
        labels.add(f.format(labelValue));

      
    }
    
  }

  double roundToPlaces(double value, int places){
    
    value = value * math.pow(10, places);
    value = value.round().toDouble();
    value = value / math.pow(10, places);

    return value;
    
  }
  
  int getDecimalPlaces(double num) {    
    
    if (num % 1 != 0) {
      return properDoubletoString(num).split(".")[1].length;
    } else {
      return 0;
    }

  }
  
  String properDoubletoString(double number){
    
    //Preliminary fix for: https://code.google.com/p/dart/issues/detail?id=1533
    //Discussion: https://groups.google.com/a/dartlang.org/forum/#!topic/compiler-dev/ZSoaHoPWHbg
    
    /*
     * (0.0).toDouble -> 0.0 in DartVM
     * (0.0).toDouble -> 0 in Javascript with dart2js (Dart SDK version 0.5.13.1_r23552)
     *  
     */
    
    String result = number.toString();
    if (result.indexOf('.') == -1){
      result = result + ".0";
    }
    return result;
    
  }

  void defaultConfiguration(Map defaultConfiguration) {

    this.defaultConfig = defaultConfiguration;

    //check if we have too much key in the configuration
    this.config.forEach((String key, value) {
      if (!this.defaultConfig.containsKey(key)) {
        print('Unknown configuration key ' + key);
      }
    });

  }

  getConfiguration(String key) {

    if (!this.defaultConfig.containsKey(key)) {
      print('Invalid configuration key ' + key);
    }

    if (this.config.containsKey(key)) {
      return this.config[key];
    } else {
      return this.defaultConfig[key];
    }

  }

  double calculateOffset(double val, Map calculatedScale, int scaleHop) {
    
    double outerValue = calculatedScale['steps'] * calculatedScale['stepSize'];
    double adjustedValue = val - calculatedScale['graphMin'];
    double scalingFactor = CapValue(adjustedValue / outerValue, 1.0, 0.0);
    return (scaleHop * calculatedScale['steps']) * scalingFactor;
    
  }

  //Apply cap a value at a high or low number

  double CapValue(double valueToCap, double maxValue, double minValue) {
    
    if (maxValue != null)if (valueToCap > maxValue) {
      return maxValue;
    }

    if (valueToCap < minValue) {
      return minValue;
    }

    return valueToCap;
    
  }
    
  Map<String, int> calculateDrawingSizes(int maxSize,int rotateLabels) {
    
    maxSize = this.height;
    //Need to check the X axis first - measure the length of each text metric, and figure out if we need to rotate by 45 degrees.
    this.context.font = getConfiguration('scaleFontStyle').toString() + " " + getConfiguration('scaleFontSize').toString() + "px " + getConfiguration('scaleFontFamily');
    int widestXLabel = 1;
    for (int i = 0; i < this.data['labels'].length; i++) {
      double textLength = this.context.measureText(this.data['labels'][i].toString()).width;
      //If the text length is longer - make that equal to longest text!
      widestXLabel = (textLength.round() > widestXLabel) ? textLength.round() : widestXLabel;
    }
    if (this.width / this.data['labels'].length < widestXLabel) {
      rotateLabels = 45;
      if (this.width / this.data['labels'].length < math.cos(rotateLabels) * widestXLabel) {
        rotateLabels = 90;
        maxSize -= widestXLabel;
      } else {
        maxSize -= (math.sin(rotateLabels) * widestXLabel).round();
      }
    } else {
      maxSize -= getConfiguration('scaleFontSize');
    }

    //Add a little padding between the x line and the text
    maxSize -= 5;

    int labelHeight = getConfiguration('scaleFontSize');

    maxSize -= labelHeight.round();
    //Set 5 pixels greater than the font size to allow for a little padding from the X axis.
   
    int scaleHeight = maxSize.toInt();
    //Then get the area above we can safely draw on.
   
    return {
      'labelHeight' : labelHeight,
      'scaleHeight' : scaleHeight,
      'widestXLabel' : widestXLabel
    };
    
  }
  
  void animateFrame() {
    
    double easeAdjustedAnimationPercent = (getConfiguration('animation')) ? CapValue(this.animation.getEaseValue(getConfiguration('animationEasing'), this.percentAnimComplete), null, 0.0) : 1.0;
    clear();
        
    drawChart(easeAdjustedAnimationPercent);
    drawScale();
    drawTitle();
    
    if (getConfiguration('scaleOverlay')) {
      this.context.drawImage(this.chartLayer, 0, 0);
      this.context.drawImage(this.gridLayer, 0, 0);
    } else {
      this.context.drawImage(this.gridLayer, 0, 0);
      this.context.drawImage(this.chartLayer, 0, 0);
    }
    this.context.drawImage(this.titleLayer, 0, 0);
    
  }
  
  void animationLoop() {
    
    this.animFrameAmount = (getConfiguration('animation')) ? 1 / CapValue(getConfiguration('animationSteps').toDouble(), double.MAX_FINITE, 1.0) : 1.0;
    this.percentAnimComplete = getConfiguration('animation') ? 0.0 : 1.0;
    requestAnimFrame(animLoop);
    
  }
  
  void animLoop(double time) {
    
    this.percentAnimComplete += this.animFrameAmount;
    animateFrame();

    //break the recursion when animation is complete
    if (percentAnimComplete <= 1) {
      requestAnimFrame(animLoop);
    } else {
    //Animation is complete
    }
    
  }
  
  void clear() {
    
    this.context.clearRect(0, 0, this.width, this.height);
    this.chartLayerContext.clearRect(0, 0, this.width, this.height);
    this.gridLayerContext.clearRect(0, 0, this.width, this.height);
    this.titleLayerContext.clearRect(0, 0, this.width, this.height);
    
  }
  
  Object requestAnimFrame(RequestAnimationFrameCallback callback) {
    
    return window.requestAnimationFrame(callback);
    
  }
  

  void drawChart(double animPc){    
  }
  
  void drawScale(){    
  }  
  
  void show(Element parentNode){
    
    this.domNode.width = parentNode.offsetWidth;
    this.domNode.height = parentNode.offsetHeight;

    this.context.canvas.width = this.domNode.width;
    this.context.canvas.height = this.domNode.height;
    this.height = this.domNode.height;
    this.width = this.domNode.width;
    
    this.chartLayerContext.canvas.width = this.domNode.width;
    this.chartLayerContext.canvas.height = this.domNode.height;
    
    this.gridLayerContext.canvas.width = this.domNode.width;
    this.gridLayerContext.canvas.height = this.domNode.height;
    
    this.titleLayerContext.canvas.width = this.domNode.width;
    this.titleLayerContext.canvas.height = this.domNode.height;

    //High pixel density displays - multiply the size of the canvas height/width by the device pixel ratio, then scale.
    if (window.devicePixelRatio != null) {
      this.context.canvas.style.width = this.width.toString() + "px";
      this.context.canvas.style.height = this.height.toString() + "px";
      this.context.canvas.height = (this.context.canvas.height * window.devicePixelRatio).round();
      this.context.canvas.width = (this.context.canvas.width * window.devicePixelRatio).round();
      this.context.scale(window.devicePixelRatio, window.devicePixelRatio);
    }
    
    this.animation = new Animation();
    
    parentNode.children.add(this.domNode);
    
  }
  
  void hide(){
    
    this.domNode.remove();
    
  }
}