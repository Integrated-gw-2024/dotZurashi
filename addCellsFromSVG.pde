void addCellsFromSVG(ArrayList<XML> circles) {
  for (int i=0; i<circles.size(); i++) {
    float x, y, r;

    Boolean hasAttributeR = circles.get(i).hasAttribute("r");
    Boolean hasAttributeRX = circles.get(i).hasAttribute("rx");
    if (hasAttributeR) {
      r = circles.get(i).getFloat("r");
      x = circles.get(i).getFloat("cx");
      y = circles.get(i).getFloat("cy");
    } else if (hasAttributeRX) {
      r = circles.get(i).getFloat("rx");
      x = circles.get(i).getFloat("x");
      y = circles.get(i).getFloat("y");
    } else {
      r = 10;
      x = 10;
      y = 10;
    }

    b = new Cell();

    String fillCol = circles.get(i).getString("fill");
    String strokeCol = circles.get(i).getString("stroke");
    String strokeWidth = circles.get(i).getString("stroke-width");

    try {
      b.setFillColor(fillCol);
      b.setStrokeColor(strokeCol);
      b.setStrokeWeight(strokeWidth);
    }
    catch(NullPointerException err) {
      println(err);
    }

    float offsetX = svgWidth/2;
    float offsetY = svgHeight/2;

    b.initialX = x-offsetX;
    b.initialY = y-offsetY;

    b.x = x-offsetX;
    b.y = y-offsetY;

    b.num = i;


    b.targetX = x-offsetX;
    b.targetY = y-offsetY;
    b.scale = r * 2;

    Cells.add(b);
  }
}


void findCirclesFromSVG(XML element, ArrayList<XML> circles) {
  String elmName = element.getName();
  if ("circle".equals(elmName) || "rect".equals(elmName)) {
    circles.add(element);
  }
  XML[] children = element.getChildren();
  for (XML child : children) {
    findCirclesFromSVG(child, circles);
  }
}
