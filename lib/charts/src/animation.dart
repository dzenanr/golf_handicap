part of chart;

/**
 * Code based on charts.js by Nick Downie, http://chartjs.org/
 * 
 * (Partial) Dart implementation done by Symcon GmbH, Tim Rasim
 * 
 */

class Animation {
  
  Animation(){
    
  }
  
  //Easing functions adapted from Robert Penner's easing equations
  //http://www.robertpenner.com/easing/
  double linear(double t) {
    return t;
  }

  double easeInQuad(double t) {
    return t * t;
  }

  double easeOutQuad(double t) {
    return -1 * t * (t - 2);
  }

  double easeInOutQuad(double t) {
    if ((t /= 1 / 2) < 1) return 1 / 2 * t * t;
    return -1 / 2 * ((--t) * (t - 2) - 1);
  }

  double easeInCubic(double t) {
    return t * t * t;
  }

  double easeOutCubic(double t) {
    return 1 * ((t = t / 1 - 1) * t * t + 1);
  }

  double easeInOutCubic(double t) {
    if ((t /= 1 / 2) < 1) return 1 / 2 * t * t * t;
    return 1 / 2 * ((t = t - 2) * t * t + 2);
  }

  double easeInQuart(double t) {
    return t * t * t * t;
  }

  double easeOutQuart(double t) {
    return -1 * ((t = t / 1 - 1) * t * t * t - 1);
  }

  double easeInOutQuart(double t) {
    if ((t /= 1 / 2) < 1) return 1 / 2 * t * t * t * t;
    return -1 / 2 * ((t = t - 2) * t * t * t - 2);
  }

  double easeInQuint(double t) {
    return t * t * t * t * t;
  }

  double easeOutQuint(double t) {
    return ((t = t - 1) * t * t * t * t + 1);
  }

  double easeInOutQuint(double t) {
    if ((t = t / (1 / 2)) < 1) return (1 / 2) * t * t * t * t * t;
    return 1 / 2 * ((t = t - 2) * t * t * t * t + 2);
  }

  double easeInSine(double t) {
    return -1 * math.cos(t / 1 * (math.PI / 2)) + 1;
  }

  double easeOutSine(double t) {
    return 1 * math.sin(t / 1 * (math.PI / 2));
  }

  double easeInOutSine(double t) {
    return -1 / 2 * (math.cos(math.PI * t / 1) - 1);
  }

  double easeInExpo(double t) {
    return (t == 0) ? 1 : 1 * math.pow(2, 10 * (t / 1 - 1));
  }

  double easeOutExpo(double t) {
    return (t == 1) ? 1 : 1 * (-math.pow(2, -10 * t / 1) + 1);
  }

  double easeInOutExpo(double t) {
    if (t == 0) return 0.0;
    if (t == 1) return 1.0;
    if ((t = t / (1 / 2)) < 1) return 1 / 2 * math.pow(2, 10 * (t - 1));
    return 1 / 2 * (-math.pow(2, -10 * --t) + 2);
  }

  double easeInCirc(double t) {
    if (t >= 1) return t;
    return -1 * (math.sqrt(1 - t * t) - 1);
  }

  double easeOutCirc(double t) {
    return 1 * math.sqrt(1 - (t = t - 1) * t);
  }

  double easeInOutCirc(double t) {
    if ((t = t / 0.5) < 1) return -1 / 2 * (math.sqrt(1 - t * t) - 1);
    return 1 / 2 * (math.sqrt(1 - (t = t - 2) * t) + 1);
  }

  double easeInElastic(double t) {
    double s = 1.70158;
    double p = 0.0;
    double a = 1.0;
    if (t == 0) return 0.0;
    if (t == 1) return 1.0;
    if (p == 0) p = 1 * .3;
    if (a < 1) {
      a = 1.0;
      var s = p / 4;
    } else s = p / (2 * math.PI) * math.asin(1 / a);
    return -(a * math.pow(2, 10 * (t = t - 1)) * math.sin((t * 1 - s) * (2 * math.PI) / p));
  }

  double easeOutElastic(double t) {
    double s = 1.70158;
    double p = 0.0;
    double a = 1.0;
    if (t == 0) return 0.0;
    if (t == 1) return 1.0;
    if (p == 0) p = 1 * .3;
    if (a < 1) {
      a = 1.0;
      var s = p / 4;
    } else s = p / (2 * math.PI) * math.asin(1 / a);
    return a * math.pow(2, -10 * t) * math.sin((t * 1 - s) * (2 * math.PI) / p) + 1;
  }

  double easeInOutElastic(double t) {
    double s = 1.70158;
    double p = 0.0;
    double a = 1.0;
    if (t == 0) return 0.0;
    if ((t /= 1 / 2) == 2) return 1.0;
    if (p == 0.0) p = 1 * (.3 * 1.5);
    if (a < 1) {
      a = 1.0;
      var s = p / 4;
    } else s = p / (2 * math.PI) * math.asin(1 / a);
    if (t < 1) return -.5 * (a * math.pow(2, 10 * (t = t - 1)) * math.sin((t * 1 - s) * (2 * math.PI) / p));
    return a * math.pow(2, -10 * (t = t - 1)) * math.sin((t * 1 - s) * (2 * math.PI) / p) * .5 + 1;
  }

  double easeInBack(double t) {
    double s = 1.70158;
    return t * t * ((s + 1) * t - s);
  }

  double easeOutBack(double t) {
    double s = 1.70158;
    return 1 * ((t = t / 1 - 1) * t * ((s + 1) * t + s) + 1);
  }

  double easeInOutBack(double t) {
    double s = 1.70158;
    if ((t = t / 0.5) < 1) return 1 / 2 * (t * t * (((s *= (1.525)) + 1) * t - s));
    return 1 / 2 * ((t = t - 2) * t * (((s *= (1.525)) + 1) * t + s) + 2);
  }

  double easeInBounce(double t) {
    return 1 - easeOutBounce(1 - t);
  }

  double easeOutBounce(double t) {
    if (t < (1 / 2.75)) {
      return 1 * (7.5625 * t * t);
    } else if (t < (2 / 2.75)) {
      return 1 * (7.5625 * (t = t - (1.5 / 2.75)) * t + .75);
    } else if (t < (2.5 / 2.75)) {
      return 1 * (7.5625 * (t = t - (2.25 / 2.75)) * t + .9375);
    } else {
      return 1 * (7.5625 * (t = t - (2.625 / 2.75)) * t + .984375);
    }
  }

  double easeInOutBounce(double t) {
    if (t < 1 / 2) return easeInBounce(t * 2) * .5;
    return easeOutBounce(t * 2 - 1) * .5 + 1 * .5;
  }

  double getEaseValue(String key, double time) {
    switch (key) {
      case 'linear':
        return linear(time);
        break;
      case 'easeInQuad':
        return easeInQuad(time);
        break;
      case 'easeOutQuad':
        return easeOutQuad(time);
        break;
      case 'easeInOutQuad':
        return easeInOutQuad(time);
        break;
      case 'easeInCubic':
        return easeInCubic(time);
        break;
      case 'easeOutCubic':
        return easeOutCubic(time);
        break;
      case 'easeInOutCubic':
        return easeInOutCubic(time);
        break;
      case 'easeInQuart':
        return easeInQuart(time);
        break;
      case 'easeOutQuart':
        return easeOutQuart(time);
        break;
      case 'easeInOutQuart':
        return easeInOutQuart(time);
        break;
      case 'easeInQuint':
        return easeInQuint(time);
        break;
      case 'easeOutQuint':
        return easeOutQuint(time);
        break;
      case 'easeInOutQuint':
        return easeInOutQuint(time);
        break;
      case 'easeInSine':
        return easeInSine(time);
        break;
      case 'easeOutSine':
        return easeOutSine(time);
        break;
      case 'easeInOutSine':
        return easeInOutSine(time);
        break;      
      case 'easeInExpo':
        return easeInExpo(time);
        break;
      case 'easeOutExpo':
        return easeOutExpo(time);
        break;
      case 'easeInOutExpo':
        return easeInOutExpo(time);
        break;      
      case 'easeInCirc':
        return easeInCirc(time);
        break;
      case 'easeOutCirc':
        return easeOutCirc(time);
        break;
      case 'easeInOutCirc':
        return easeInOutCirc(time);
        break;
      case 'easeInElastic':
        return easeInElastic(time);
        break;
      case 'easeOutElastic':
        return easeOutElastic(time);
        break;
      case 'easeInOutElastic':
        return easeInOutElastic(time);
        break;
      case 'easeInBack':
        return easeInBack(time);
        break;
      case 'easeOutBack':
        return easeOutBack(time);
        break;
      case 'easeInOutBack':
        return easeInOutBack(time);
        break;
      case 'easeInBounce':
        return easeInBack(time);
        break;
      case 'easeOutBounce':
        return easeOutBounce(time);
        break;
      case 'easeInOutBounce':
        return easeInOutBounce(time);
        break;
      default:
        throw new Exception('Unknown animation '+key+' used!');
    }
  }
  
  
}