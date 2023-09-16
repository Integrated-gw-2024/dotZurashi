class Cell {

  float initialX = 0;
  float initialY = 0;

  float x = 0;
  float y = 0;

  int num;

  float targetX = 300;
  float targetY = 300;
  float scale = 30;

  String fill = "#000";
  String stroke = null;
  float strokeWeight = 0;

  void setStrokeColor(String col) {
    if (col.startsWith("#")) {
      stroke = col;
    } else {
      stroke = colmap.convertColorNameToHex(col);
    }
  }

  void setFillColor(String col) {
    if (col.startsWith("#")) {
      fill = col;
    } else {
      fill = colmap.convertColorNameToHex(col);
    }
  }

  void setStrokeWeight(String input) {
    if (input.startsWith(".")) {
      String weightStr = 0 + input ;
      strokeWeight = Float.parseFloat(weightStr);
    } else {
      strokeWeight = Float.parseFloat(input);
    }
  }

  void move() {
    float easing = 0.1;

    float dx = targetX - x;
    float dy = targetY - y;

    x += dx * easing;
    y += dy * easing;

    //fill(255,0,0);
    //ellipse(targetX,targetY,10,10);
  }

  void initPosition() {
    targetX = initialX;
    targetY = initialY;
    x = initialX;
    y = initialY;
  }

  void setTargetRandom() {
    //println("[x]" + targetX + "   " + targetX);
    //println("[y]" + targetY + "   " + targetY);

    targetX += random(-randX, randX);
    targetY += random(-randY, randY);
  }

  void render() {
    strokeWeight(strokeWeight);
    if (stroke != null) {
      stroke(hexValueToRGB(stroke));
    }else{
      noStroke();
    }
    fill(hexValueToRGB(fill));

    ellipse(x, y, scale, scale);
    noStroke();


    if (debugMode) {
      fill(0);
      textSize(scale*0.8);
      text(num, x, y);
    }
  }

  color hexValueToRGB(String hex) {
    color c;
    if (hex.startsWith("#")) {
      if (hex.length() == 4) {
        char r = hex.charAt(1);
        char g = hex.charAt(2);
        char b = hex.charAt(3);
        hex = "#" + r + r + g + g + b + b;
      }

      int red = Integer.parseInt(hex.substring(1, 3), 16);
      int green = Integer.parseInt(hex.substring(3, 5), 16);
      int blue = Integer.parseInt(hex.substring(5, 7), 16);

      c = color(red, green, blue);
    } else {
      c = color(0, 0, 0);
    }

    return c;
  }
}
