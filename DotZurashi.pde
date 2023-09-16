import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.awt.datatransfer.*;
import java.awt.dnd.*;
import java.awt.Toolkit;
import java.io.File;
import java.io.IOException;
import java.awt.Component;
import java.util.List;
import java.util.ArrayDeque;
import controlP5.*;

import java.util.HashMap;
import java.util.Map;



Boolean debugMode = false;

float x = 0;
float y = 0;

float targetX = 0;
float targetY = 0;


PImage img;

Cell b;
Cell b1;
ArrayList<Cell> Cells;

ColorMap colmap = new ColorMap();

XML[] firstChild;

String[] importedRectColor;

Boolean isMouseReleased = true;

float displayScale = 1;

float svgWidth = 0;
float svgHeight = 0;

float randX, randY = 10;
ControlP5 slider;

int sliderWidth, sliderHeight;
Boolean isViewCopiedText = false;

void setup() {
  PImage icon = loadImage( "icon.png" );
  surface.setIcon( icon );
  surface.setTitle("Dot Zurashi");
  size(1100, 700);
  textFont(createFont("IBMPlexSansJP-Regular.ttf", 48));


  b = new Cell();
  Cells = new ArrayList<Cell>();

  sliderWidth = 200;
  sliderHeight = 20;
  ControlFont font = new ControlFont(createFont("IBMPlexSansJP-Regular.ttf", 10));
  slider = new ControlP5(this);
  slider.addSlider("randX")
    .setCaptionLabel("random X")
    .setValue(20)
    .setRange(0, 100)
    .setPosition(20, 30)
    .setSize(sliderWidth, sliderHeight)
    .setFont(font)
    .setColorValue(color(255))
    .setColorBackground(color(10));
  slider.addSlider("randY")
    .setCaptionLabel("random Y")
    .setValue(20)
    .setRange(0, 100)
    .setPosition(20, 60)
    .setSize(sliderWidth, sliderHeight)
    .setColorCaptionLabel(color(255))
    .setFont(font)
    .setColorValue(color(255))
    .setColorBackground(color(10));


  slider.setAutoDraw(false);

  background(255);
  DragAndDrop();
  scale(1);
}

void draw() {
  background(241, 240, 240);

  sliderBackground();

  pushMatrix();
  //translate((width/2)-svgWidth/2, (height/2)-svgHeight/2);
  translate((width/2), (height/2));
  scale(displayScale);

  //println(mouseX,mouseY);
  //fill(255,0,0);
  //rect(0,0,40,40);
  //println(displayScale);

  fill(0);

  for (int i=0; i<=Cells.size()-1; i++) {
    if (floor(Cells.get(i).targetX)!=floor(Cells.get(i).x) && floor(Cells.get(i).targetY)!=floor(Cells.get(i).y)) {
      Cells.get(i).move();
    } else {
      //Cells.get(i).setTargetRandom();
    }
  }

  for (int i=0; i<=Cells.size()-1; i++) {
    Cells.get(i).render();
  }


  loadSVG();
  popMatrix();
  slider.draw();
  displayDragEnterScene();


  float textSz = 15;
  float space = 33;
  float textSpaceX = 27;
  float szW = 180;
  float szH = 70;

  float textZabutonX = width;

  if (isViewCopiedText) {
    szH = 37;
    szW = 122;
    fill(255);

    textZabutonX = width-szW-space;

    rect(textZabutonX, height-szH-(10+10), szW, szH);

    noStroke();
    fill(0);

    textSize(textSz);

    text("[Copied!!]", textZabutonX+textSpaceX, (height-szH)+(13-10));
  }
}


void mousePressed() {
  isMouseReleased = false;
  isViewCopiedText = false;
  for (int i=0; i<=Cells.size()-1; i++) {
    Cells.get(i).initPosition();
  }
}

void mouseReleased() {
  isMouseReleased = true;

  for (int i=0; i<=Cells.size()-1; i++) {
    Cells.get(i).setTargetRandom();
  }

  for (int i=0; i<=Cells.size()-1; i++) {
    Cells.get(i).move();
  }
}

void keyPressed() {
  if (keyCode==82) {
    for (Cell c : Cells) {
      c.initPosition();
    }
  }
  isViewCopiedText = true;
  setClipboardCells();
}

void displayDragEnterScene() {
  if (isDragEnter) {
    cursor(WAIT);
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255);
    int textSZ = 50;
    textSize(textSZ);
    float offsetY = 10;
    text("svg:", 30, 20+offsetY, width-100, height-50);

    textLeading(textSZ+10);
    if (imgPath != null) {
      text(""+imgPath, 30, textSZ+80+offsetY, width/1.1, height-50);
    }
  } else {
    cursor(ARROW);
  }
}

void loadSVG() {
ArrayList<XML> circles;
  XML xml;
  if (isDrop && (500<millis()-dropMillis)) {
    Cells.clear();

    xml = loadXML(imgPath);

    circles = new ArrayList<XML>();
    findCircles(xml);
    importedRectColor = new String[circles.size()];

    println(xml);
    
    autoResizeCells(xml);

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
      
      println(strokeWidth);

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
    isDragEnter = false;
    isDrop = false;
  }
}


String extractColor(String input, String pattern) {
  Pattern p = Pattern.compile(pattern);
  Matcher matcher = p.matcher(input);

  if (matcher.find()) {
    return "#" + matcher.group(1);
  } else {
    return null;
  }
}

void findCircles(XML element) {
  String elmName = element.getName();
  if ("circle".equals(elmName) || "rect".equals(elmName)) {
    circles.add(element);
  }
  XML[] children = element.getChildren();
  for (XML child : children) {
    findCircles(child);
  }
}

void sliderBackground() {
  fill(0, 0, 0, 100);
  noStroke();
  rect(10, 10, sliderWidth*1.42, 90);
}

void autoResizeCells(XML x) {
  String viewBox = x.getString("viewBox");

    Pattern viewBoxPatt = Pattern.compile("\\b(?:0|(?:[1-9]\\d*))(\\.\\d+)?\\b");
    Matcher viewBoxMatc = viewBoxPatt.matcher(viewBox);

    String[] svgSizeString = new String[4];

    int a = 0;
    while (viewBoxMatc.find()) {
      svgSizeString[a] = viewBoxMatc.group();
      a++;
    }

    try {
      svgWidth = Float.parseFloat(svgSizeString[2]);
      svgHeight = Float.parseFloat(svgSizeString[3]);
    }
    catch (NumberFormatException e) {
      println("整数に変換できませんでした。");
    }

    float topValue = 0;


    if (svgWidth>svgHeight) {
      println(svgWidth);
      topValue = svgWidth;
    } else if (svgWidth<svgHeight) {
      println(svgHeight);
      topValue = svgHeight;
    } else {
      println("svgのサイズが取得されていません。サイズの比較に失敗しました。");
    }

    float scaleFactor = min(width / svgWidth, height / svgHeight);

    displayScale = scaleFactor * 0.65;
    println(displayScale);
}
