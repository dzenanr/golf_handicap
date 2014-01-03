part of chart;

/**
 * Code based on charts.js by Nick Downie, http://chartjs.org/
 * 
 * (Partial) Dart implementation done by Symcon GmbH, Tim Rasim
 * 
 */

class Line extends DartChart {
  
  int labelHop; //x-distance between two x-axis labels
  int widestXLabel;
  double xAxisLength;
  double yAxisPosX;
  double xAxisPosY;
  bool showLastStep;

  Line(data, config):super(data, config) {

    defaultConfiguration({
        'scaleOverlay' : false, 
        'scaleOverride' : false, 
        'scaleStepValue' : null, 
        'scaleMinValue' : 0.0,
        'scaleMaxValue' : 1.0,
        'scaleLineColor' : "rgba(0,0,0,.1)", 
        'scaleLineWidth' : 1, 
        'scaleShowLabels' : true, 
        'scaleLabel' : null, 
        'scaleFontFamily' : "'Verdana'", 
        'scaleFontSize' : 12, 
        'scaleFontStyle' : "normal", 
        'scaleFontColor' : "#666", 
        'titleText' : '',
        'titleFontFamily' : "'Verdana'", 
        'titleFontSize' : 16, 
        'titleFontStyle' : "normal", 
        'titleFontColor' : "#666", 
        'scaleShowGridLines' : true, 
        'scaleGridLineColor' : "rgba(0,0,0,.05)", 
        'scaleGridLineWidth' : 1, 
        'bezierCurve' : true, 
        'pointDot' : true, 
        'pointDotRadius' : 4.0, 
        'pointDotStrokeWidth' : 2, 
        'datasetStroke' : true, 
        'datasetStrokeWidth' : 2, 
        'datasetFill' : true, 
        'animation' : true, 
        'animationSteps' : 60, 
        'animationEasing' : "easeOutQuart", 
        'onAnimationComplete' : null
    });
    
  }
  
  void show(Element parentNode){
    
    super.show(parentNode);

    setScale();
    
    calculateXAxisSize();
    
    animationLoop();    
    
  }

  calculateXAxisSize() {
    
    double longestText = 1.0;
    //if we are showing the labels
    if (getConfiguration('scaleShowLabels')) {
      this.context.font = getConfiguration('scaleFontStyle').toString() + " " + getConfiguration('scaleFontSize').toString() + "px " + getConfiguration('scaleFontFamily').toString();
      for (int i = 0; i < this.data['labels'].length; i++) {
        double measuredText = this.context.measureText(this.data['labels'][i].toString()).width;
        longestText = (measuredText > longestText) ? measuredText : longestText;
      }
    }
    
    double longestLabel = longestText;
    
    //also calculate the width of the scales, so they won't be cut off.
    for (int i = 0; i < calculatedScale['labels'].length; i++) {
      this.context.font = getConfiguration('scaleFontStyle').toString() + " " + getConfiguration('scaleFontSize').toString() + "px " + getConfiguration('scaleFontFamily').toString();
      double measuredText = this.context.measureText(calculatedScale['labels'][i]).width;
      longestText = (measuredText > longestText) ? measuredText : longestText;
    }
    
    this.showLastStep = false;
    this.data['datasets'].forEach( (dataset) {
      if (dataset['data'].last is List) {
        this.showLastStep = true;
      }
    });
        
    this.xAxisLength = this.width.toDouble() - longestText;
    
    if (this.showLastStep)
      this.labelHop = ((this.xAxisLength - 10) / (this.data['labels'].length)).floor();
    else 
      this.labelHop = ((this.xAxisLength - 10)  / (this.data['labels'].length - 1) - (longestLabel / 2) / (this.data['labels'].length -1) ).floor();
    
    this.yAxisPosX = this.width.toDouble() - this.xAxisLength + 10;
    
    this.xAxisPosY = this.scaleHeight.toDouble() + getConfiguration('scaleFontSize')/2;
    
  }
  
  
  /**
   * 
   * draw one step which can consists of two points or multiple inter steps
   * 
   * pointBefore: the last point before this step
   * 
   * returns: the last point inside this step
   */
  Object drawStep(dynamic previousValue, dynamic currentValue, Map dataset, num lastStartX, double currentX, double stepSizeX, double lastStepSizeX, double animPc, bool disableFill){  
    
    if (previousValue == null && currentValue == null){
      //if the point before the current point was null, only move the pencil to the point
      this.chartLayerContext.moveTo(xPos(lastStartX), yPos(0.0, animPc));      
      lastStartX = currentX;
      return {
        'currentValue' : null,
        'lastStartX' : lastStartX,
        'lastStepSizeX' : stepSizeX
      };
    }
    
    if (previousValue != null && currentValue == null){
      // the last set of points ends with the last point
      closePath(dataset,lastStartX, currentX -lastStepSizeX,animPc,disableFill);      
      
      return {
        'currentValue' : null,
        'lastStartX' : lastStartX,
        'lastStepSizeX' : stepSizeX
      };
    }
    
    if (previousValue != null && (currentValue is List && currentValue.last == null)){
      //the first value in the list is empty
      
      Map data = {
                     'currentValue' : previousValue,
                     'lastStartX' : lastStartX,
                     'lastStepSizeX' : lastStepSizeX
      };
      stepSizeX = 1 / currentValue.length;
      for (int z = 0; z < currentValue.length; z++)
        data = drawStep(data['currentValue'], currentValue[z],dataset, data['lastStartX'], currentX + stepSizeX * z, stepSizeX, data['lastStepSizeX'], animPc,disableFill);  

      
      return {
        'currentValue' : data['currentValue'],
        'lastStartX' : data['lastStartX'],
        'lastStepSizeX' : stepSizeX
      };
    }

    if (currentValue != null){
      //continue context from before
      if (previousValue == null){
        lastStartX = currentX;
        if (currentValue is List && currentValue.first is num){
          this.chartLayerContext.moveTo(xPos(lastStartX), yPos(currentValue.first, animPc));
        } else if (currentValue is num){
          this.chartLayerContext.moveTo(xPos(lastStartX), yPos(currentValue, animPc));
        }
      } else if (currentValue is num){
        if (getConfiguration('bezierCurve')) {
          if (previousValue == null){
            previousValue = 0;
          }

          this.chartLayerContext.bezierCurveTo(xPos(currentX  - math.min(stepSizeX, lastStepSizeX)/2), yPos(previousValue.toDouble(), animPc), xPos(currentX  - math.min(stepSizeX, lastStepSizeX)/2), yPos(currentValue.toDouble(), animPc), xPos(currentX), yPos(currentValue, animPc));
        } else {
          this.chartLayerContext.lineTo(xPos(currentX), yPos(currentValue, animPc));
        }
      } 
      
      if (currentValue is List){
        Map data = {
                       'currentValue' : previousValue,
                       'lastStartX' : lastStartX,
                       'lastStepSizeX' : lastStepSizeX
        };
        stepSizeX = 1 / currentValue.length;
        if (previousValue == null){
          data['currentValue'] = currentValue.first;
          data['lastStartX'] = currentX + stepSizeX;
          for (int z = 1; z < currentValue.length; z++){
            data = drawStep(data['currentValue'], currentValue[z],dataset, data['lastStartX'], currentX + stepSizeX * z, stepSizeX, data['lastStepSizeX'], animPc, disableFill);
          }
        } else {
          for (int z = 0; z < currentValue.length; z++){
            data = drawStep(data['currentValue'], currentValue[z],dataset, data['lastStartX'], currentX + stepSizeX * z, stepSizeX, data['lastStepSizeX'], animPc, disableFill);  
          }
        }
      lastStartX = data['lastStartX'];
      currentValue = data['currentValue'];
      }
      
      return {
        'currentValue' : currentValue,
        'lastStartX' : lastStartX,
        'lastStepSizeX' : stepSizeX
      };
    }     
    
  }

  void drawLines(double animPc) {
    
    bool disableFill;
    
    //for all: drawStep
    //then draw end if last is not null
    
    this.data['datasets'].forEach( (Map dataset){
      disableFill = false;
      //draw twice, once with background, once without
      for (int i = 0; i <= 1; i++){
        this.chartLayerContext.strokeStyle = dataset['strokeColor'];
        this.chartLayerContext.lineWidth = getConfiguration('datasetStrokeWidth');
        
        this.chartLayerContext.beginPath();
        
        if (dataset['data'][0] is List && dataset['data'][0][0] != null ){
          this.chartLayerContext.moveTo(this.yAxisPosX, this.xAxisPosY - animPc * (calculateOffset(dataset['data'][0][0].toDouble(), this.calculatedScale, this.scaleHop)));
        } else if (dataset['data'][0] is num){
          this.chartLayerContext.moveTo(this.yAxisPosX, this.xAxisPosY - animPc * (calculateOffset(dataset['data'][0].toDouble(), this.calculatedScale, this.scaleHop)));
        }
        
        List test = new List();
        int x = 0;
        Map data = {
         'currentValue' : null,
         'lastStartX' : 0,
         'lastStepSizeX' : 1.0
        };
        dataset['data'].forEach( (value){
          data = drawStep(data['currentValue'], value, dataset, data['lastStartX'], x.toDouble(), 1.0, data['lastStepSizeX'], animPc,disableFill);
          x++;
        });
        
        if ((dataset['data'].last is num) || (dataset['data'].last is List && dataset['data'].last.last != null)){ 
          closePath(dataset, data['lastStartX'], dataset['data'].length -1, animPc, disableFill);
        } 
        
        if (getConfiguration('pointDot')) {
          this.chartLayerContext.fillStyle = dataset['pointColor'];
          this.chartLayerContext.strokeStyle = dataset['pointStrokeColor'];
          this.chartLayerContext.lineWidth = getConfiguration('pointDotStrokeWidth');
          for (var k = 0; k < dataset['data'].length; k++) {
            if (dataset['data'][k] is List){
              //multiple intermediary steps   
              double stepSizeX = 1 / dataset['data'][k].length;
              int n = 0;
              dataset['data'][k].forEach( (item) {
                if (item != null && item is num){
                  this.chartLayerContext.beginPath();
                  this.chartLayerContext.arc(xPos(k + stepSizeX *n++ ), this.xAxisPosY - animPc * (calculateOffset(item.toDouble(), this.calculatedScale, this.scaleHop)), getConfiguration('pointDotRadius'), 0, math.PI * 2, true);
                  this.chartLayerContext.fill();
                  this.chartLayerContext.stroke();
                }
              });
             } else if (dataset['data'][k] is num) {
              //one step
              this.chartLayerContext.beginPath();
              this.chartLayerContext.arc(xPos(k), this.xAxisPosY - animPc * (calculateOffset(dataset['data'][k].toDouble(), this.calculatedScale, this.scaleHop)), getConfiguration('pointDotRadius'), 0, math.PI * 2, true);
              this.chartLayerContext.fill();
              this.chartLayerContext.stroke();
             }
          }
        }
        disableFill = true;//DisableFill is set to true when all graphs will be drawn a second time. This is used to solve the "fill overlaps stroke"-issue
      }
    });    
  }
  
  void closePath(Map dataset, num startX, num endX, double animPc, bool disableFill){

    this.chartLayerContext.stroke();
       
    if (getConfiguration('datasetFill') && !disableFill) {
      if (dataset['data'][endX.floor()] is List && dataset['data'][endX.floor()].last != null && endX % 1 == 0){
        //1 - 1 / dataset['data'].last.length means the last step exclusive a next full step (confusing but better than no comment at all)
        drawDatasetFill(dataset, startX, endX + 1 - 1 / dataset['data'][endX.floor()].length, animPc);
      } else {
        drawDatasetFill(dataset, startX, endX, animPc);
      }
    } else {
      this.chartLayerContext.closePath();
      this.chartLayerContext.beginPath();
    }  

  }
  
  /*
   * Draws the background between the points startX and endX
   * 
   * TODO: potentially exception ehrn dataset['data'][endX.floor()] contains an array or null!
   */
  void drawDatasetFill(Map dataset, num startX, num endX, animPc){
      if (dataset['fillColor'] != 'clear'){
        this.chartLayerContext.strokeStyle = dataset['fillColor'];
        this.chartLayerContext.lineTo(this.yAxisPosX + (this.labelHop * endX), this.xAxisPosY);
      } else {
        this.chartLayerContext.strokeStyle = "rgba(0,0,0,0)"; //transparent  
        this.chartLayerContext.lineTo(this.yAxisPosX + (this.labelHop * endX) + getConfiguration('datasetStrokeWidth').toDouble(), this.xAxisPosY - animPc * (calculateOffset(dataset['data'][endX.floor()].toDouble(),this.calculatedScale, this.scaleHop)));
        this.chartLayerContext.lineTo(this.yAxisPosX + (this.labelHop * endX) + getConfiguration('datasetStrokeWidth').toDouble(), this.xAxisPosY);
      }
      
      this.chartLayerContext.stroke();
    
      this.chartLayerContext.strokeStyle = "rgba(0,0,0,0)"; //transparent
      this.chartLayerContext.lineTo(this.yAxisPosX + (this.labelHop * startX), this.xAxisPosY);
      this.chartLayerContext.stroke();
    
      this.chartLayerContext.closePath();

      if (dataset['fillColor'] != 'clear'){
        this.chartLayerContext.fillStyle = dataset['fillColor'];
      } else {
        this.chartLayerContext.fillStyle = dataset['strokeColor'];
      }

      this.chartLayerContext.fill();
      
      if (dataset['fillColor'] == 'clear'){
        this.chartLayerContext.globalCompositeOperation = 'destination-out';
        this.chartLayerContext.fill();
      }
      
      this.chartLayerContext.globalCompositeOperation = 'source-over';
      
      this.chartLayerContext.beginPath();
      this.chartLayerContext.strokeStyle = dataset['strokeColor'];


  }

  double yPos(num value, double animPc) {
    
    return this.xAxisPosY - animPc * (calculateOffset(value.toDouble(), this.calculatedScale, this.scaleHop));
  
  }

  //FIXME: iterations name is confusing. (suggests it is of the type int, but istn't)
  double xPos(num iteration) {
    
    return this.yAxisPosX + (this.labelHop * iteration);
    
  }

  //@override
  void drawScale() {
    
    //X axis line
    this.gridLayerContext.lineWidth = getConfiguration('scaleLineWidth');
    this.gridLayerContext.strokeStyle = getConfiguration('scaleLineColor');
    this.gridLayerContext.beginPath();
    this.gridLayerContext.moveTo(this.width - this.widestXLabel / 2 , this.xAxisPosY);
    this.gridLayerContext.lineTo(this.width - this.xAxisLength +5, this.xAxisPosY);
    this.gridLayerContext.stroke();

    if (this.rotateLabels > 0) {
      this.gridLayerContext.save();
      this.gridLayerContext.textAlign = 'right';
    } else {
      this.gridLayerContext.textAlign = 'center';
    }
    this.gridLayerContext.fillStyle = getConfiguration('scaleFontColor');
    for (var i = 0; i < this.data['labels'].length; i++) {
      this.gridLayerContext.save();
      if (this.rotateLabels > 0) {
        this.gridLayerContext.translate(this.yAxisPosX + i * this.labelHop, this.xAxisPosY + getConfiguration('scaleFontSize'));
        this.gridLayerContext.rotate(-(this.rotateLabels * (math.PI / 180)));
        this.gridLayerContext.fillText(this.data['labels'][i].toString(), 0, 0); 
      } else {
        this.gridLayerContext.textBaseline  = 'middle';
        this.gridLayerContext.fillText(this.data['labels'][i].toString(), this.yAxisPosX + i * this.labelHop, this.xAxisPosY + getConfiguration('scaleFontSize') + 3);
      }
      this.gridLayerContext.restore();
      this.gridLayerContext.beginPath();
      this.gridLayerContext.moveTo(this.yAxisPosX + i * this.labelHop, this.xAxisPosY + 3);

      this.gridLayerContext.save();
      //Check i isnt 0, so we dont go over the Y axis twice.
      if (getConfiguration('scaleShowGridLines') && i > 0) {
        try{
          this.gridLayerContext.setLineDash([6,4]);
        } catch(e){
          //FIXME: FF/Safari/IE 10 support http://www.rgraph.net/blog/2013/january/html5-canvas-dashed-lines.html
        }
        this.gridLayerContext.lineWidth = getConfiguration('scaleGridLineWidth');
        this.gridLayerContext.strokeStyle = getConfiguration('scaleGridLineColor');
        this.gridLayerContext.lineTo(this.yAxisPosX + i * this.labelHop, 5);
      } else {
        this.gridLayerContext.lineTo(this.yAxisPosX + i * this.labelHop, this.xAxisPosY + 3);
      }
      this.gridLayerContext.stroke();
      this.gridLayerContext.restore();
    }

    //Y axis
    this.gridLayerContext.lineWidth = getConfiguration('scaleLineWidth');
    this.gridLayerContext.strokeStyle = getConfiguration('scaleLineColor');
    this.gridLayerContext.beginPath();
    this.gridLayerContext.moveTo(this.yAxisPosX, this.xAxisPosY + 5);
    this.gridLayerContext.lineTo(this.yAxisPosX, 5);
    this.gridLayerContext.stroke();
    
    this.gridLayerContext.save();
    this.gridLayerContext.textAlign = "right";
    this.gridLayerContext.textBaseline = "middle";
    for (int j = 0; j <= calculatedScale['steps']; j++) {
      this.gridLayerContext.beginPath();
      this.gridLayerContext.moveTo(this.yAxisPosX , this.xAxisPosY - ((j + 1) * this.scaleHop));
      if (getConfiguration('scaleShowGridLines')) {
        try{
          this.gridLayerContext.setLineDash([6,4]);
        } catch(e){
          //FIXME: FF/Safari/IE 10 support http://www.rgraph.net/blog/2013/january/html5-canvas-dashed-lines.html
        }
        this.gridLayerContext.lineWidth = getConfiguration('scaleGridLineWidth');
        this.gridLayerContext.strokeStyle = getConfiguration('scaleGridLineColor');
        this.gridLayerContext.lineTo(this.width - this.widestXLabel / 2, this.xAxisPosY - ((j + 1) * this.scaleHop));
      } else {
        this.gridLayerContext.lineTo(this.yAxisPosX - 0.5, this.xAxisPosY - ((j + 1) * this.scaleHop));
      }

      this.gridLayerContext.stroke();

      if (getConfiguration('scaleShowLabels')) {
        this.gridLayerContext.fillText(calculatedScale['labels'][j], this.yAxisPosX - 8, this.xAxisPosY - (j * this.scaleHop));
      }
    }
    this.gridLayerContext.restore();
  }
  
  //@override
  void drawChart(double animPc){
    
    drawLines(animPc);

    
  }

}