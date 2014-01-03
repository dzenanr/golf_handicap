part of chart;

/**
 * Code based on charts.js by Nick Downie, http://chartjs.org/
 * 
 * (Partial) Dart implementation done by Symcon GmbH, Tim Rasim
 * 
 */

class Bar extends DartChart {
  
  int valueHop;
  double xAxisLength;
  double yAxisPosX;
  double xAxisPosY;
  double barWidth;
  
  Bar(data, config):super(data, config) {
    
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
      'scaleFontFamily' : "'Arial'",
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
      'barShowStroke' : true,
      'barStrokeWidth' : 2,
      'barValueSpacing' : 5,
      'barDatasetSpacing' : 1,
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
   
  Map<String, num> calculateXAxisSize() {
    
    double longestText = 1.0;
    //if we are showing the labels
    if (getConfiguration('scaleShowLabels')) {
      this.context.font = getConfiguration('scaleFontStyle').toString() + " " + getConfiguration('scaleFontSize').toString() + "px " + getConfiguration('scaleFontFamily').toString();
      for (int i = 0; i < this.calculatedScale['labels'].length; i++) {
        double measuredText = this.context.measureText(this.calculatedScale['labels'][i]).width;
        longestText = (measuredText > longestText) ? measuredText : longestText;
      }
      
      //also calculate the width of the scales, so they won't be cut off.
      for (int i = 0; i < calculatedScale['steps']; i++) {
        double measuredText = this.context.measureText(calculatedScale['labels'][i]).width;
        longestText = (measuredText > longestText) ? measuredText : longestText;
      }
      
      //Add a little extra padding for the y axis
      longestText = longestText + 10;
    }

    this.xAxisLength = this.width.toDouble() - longestText - this.widestXLabel.toDouble();
    this.valueHop = (this.xAxisLength / (this.data['labels'].length)).floor();

    this.yAxisPosX = this.width.toDouble() - this.widestXLabel / 2 - this.xAxisLength;
    this.xAxisPosY = this.scaleHeight.toDouble() + getConfiguration('scaleFontSize') / 2;
    this.barWidth = (this.valueHop 
        - getConfiguration('scaleGridLineWidth')*2 
        - getConfiguration('barValueSpacing')*2 
        - (getConfiguration('barDatasetSpacing')*this.data['datasets'].length-1) 
        - ((getConfiguration('barStrokeWidth')/2)*this.data['datasets'].length-1))
        / this.data['datasets'].length;
    
  }
  

  
  void drawBars(animPc){
    
    bool disableFill;
    
    this.chartLayerContext.lineWidth = getConfiguration('barStrokeWidth');
    for (int i=0; i<this.data['datasets'].length; i++){
      disableFill = false;
      //draw twice, once with background, once without
      for (int e = 0; e <= 1; e++){
        this.chartLayerContext.fillStyle = this.data['datasets'][i]['fillColor'];
        this.chartLayerContext.strokeStyle = this.data['datasets'][i]['strokeColor'];
        for (int j=0; j<this.data['datasets'][i]['data'].length; j++){
          //render bar if it's not null
          if (this.data['datasets'][i]['data'][j] != null){
            double barOffset = this.yAxisPosX + getConfiguration('barValueSpacing') + this.valueHop*j + this.barWidth*i + getConfiguration('barDatasetSpacing')*i + getConfiguration('barStrokeWidth')*i;
            this.chartLayerContext.beginPath();
            this.chartLayerContext.moveTo(barOffset +this.getConfiguration('barStrokeWidth') / 2, this.xAxisPosY);
            this.chartLayerContext.lineTo(barOffset +this.getConfiguration('barStrokeWidth') / 2, this.xAxisPosY - animPc*calculateOffset(this.data['datasets'][i]['data'][j].toDouble(),this.calculatedScale,this.scaleHop));
            this.chartLayerContext.lineTo(barOffset + this.barWidth +this.getConfiguration('barStrokeWidth') / 2, this.xAxisPosY - animPc*calculateOffset(this.data['datasets'][i]['data'][j].toDouble(),this.calculatedScale,this.scaleHop));
            this.chartLayerContext.lineTo(barOffset + this.barWidth +this.getConfiguration('barStrokeWidth') / 2, this.xAxisPosY);
            if(getConfiguration('barShowStroke')){
                this.chartLayerContext.stroke();            
            }
            this.chartLayerContext.closePath();    
            this.chartLayerContext.fill();
          }        
        }
        disableFill = true;//DisableFill is set to true when all graphs will be drawn a second time. This is used to solve the "fill overlaps stroke"-issue
      }
    }
  }
  
  void drawScale() {
        
    //X axis line    
    this.gridLayerContext.lineWidth = getConfiguration('scaleLineWidth');
    this.gridLayerContext.strokeStyle = getConfiguration('scaleLineColor');
    this.gridLayerContext.beginPath();
    this.gridLayerContext.moveTo(this.width - this.widestXLabel / 2 + 5, this.xAxisPosY);
    this.gridLayerContext.lineTo(this.width - (this.widestXLabel / 2) - this.xAxisLength - 5, this.xAxisPosY);
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
        this.gridLayerContext.translate(this.yAxisPosX + i * this.valueHop, this.xAxisPosY + getConfiguration('scaleFontSize'));
        this.gridLayerContext.rotate(-(this.rotateLabels * (math.PI / 180)));
        this.gridLayerContext.fillText(this.data['labels'][i].toString(), 0, 0);
        this.gridLayerContext.restore();
      }
      else {
        this.gridLayerContext.fillText(this.data['labels'][i].toString(), this.yAxisPosX + i * this.valueHop + this.valueHop/2, this.xAxisPosY + getConfiguration('scaleFontSize') + 3);               
      }

      this.gridLayerContext.beginPath();
      this.gridLayerContext.moveTo(this.yAxisPosX + (i+1) * this.valueHop, this.xAxisPosY);

      if (getConfiguration('scaleShowGridLines')){
        this.gridLayerContext.save();
        try{
          this.gridLayerContext.setLineDash([6,4]);
        } catch(e){
          //FIXME: FF/Safari/IE 10 support http://www.rgraph.net/blog/2013/january/html5-canvas-dashed-lines.html
        }
        this.gridLayerContext.lineWidth = getConfiguration('scaleGridLineWidth');
        this.gridLayerContext.strokeStyle = getConfiguration('scaleGridLineColor');
        this.gridLayerContext.lineTo(this.yAxisPosX + (i+1) * this.valueHop, 5);
        this.gridLayerContext.stroke();
        this.gridLayerContext.restore();
      }
    }

    //Y axis
    this.gridLayerContext.lineWidth = getConfiguration('scaleLineWidth');
    this.gridLayerContext.strokeStyle = getConfiguration('scaleLineColor');
    this.gridLayerContext.beginPath();
    this.gridLayerContext.moveTo(this.yAxisPosX, this.xAxisPosY + 5);
    this.gridLayerContext.lineTo(this.yAxisPosX, 5);
    this.gridLayerContext.stroke();

    this.gridLayerContext.textAlign = "right";
    this.gridLayerContext.textBaseline = "middle";
    this.gridLayerContext.save();
    for (int j = 0; j <= calculatedScale['steps']; j++) {
      this.gridLayerContext.beginPath();
      this.gridLayerContext.moveTo(this.yAxisPosX - 3, this.xAxisPosY - ((j + 1) * this.scaleHop));
      if (getConfiguration('scaleShowGridLines')) {
        try{
          this.gridLayerContext.setLineDash([6,4]);
        } catch(e){
          //FIXME: FF/Safari/IE 10 support http://www.rgraph.net/blog/2013/january/html5-canvas-dashed-lines.html
        }
        this.gridLayerContext.lineWidth = getConfiguration('scaleGridLineWidth');
        this.gridLayerContext.strokeStyle = getConfiguration('scaleGridLineColor');
        this.gridLayerContext.lineTo(this.yAxisPosX + this.xAxisLength + 5, this.xAxisPosY - ((j + 1) * this.scaleHop));
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
    
    drawBars(animPc);
    
  }
  
}