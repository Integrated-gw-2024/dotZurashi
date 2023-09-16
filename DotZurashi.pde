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

Boolean isMouseReleased = true;

float displayScale = 1;

float svgWidth = 0;
float svgHeight = 0;

float randX, randY = 10;

ControlP5 slider;
int sliderWidth, sliderHeight;
Boolean isViewCopiedText = false;

void setup() {
  surface.setTitle("Dot Zurashi");
  size(1100, 700);
  textFont(createFont("IBMPlexSansJP-Regular.ttf", 48));


  b = new Cell();
  Cells = new ArrayList<Cell>();

  sliderWidth = 240;
  sliderHeight = 20;
  ControlFont font = new ControlFont(createFont("IBMPlexSansJP-Regular.ttf", 10));
  slider = new ControlP5(this);
  slider.addSlider("randX")
    .setCaptionLabel("random X")
    .setValue(20)
    .setRange(0, 160)
    .setPosition(20, 30)
    .setSize(sliderWidth, sliderHeight)
    .setFont(font)
    .setColorValue(color(255))
    .setColorBackground(color(10));
  slider.addSlider("randY")
    .setCaptionLabel("random Y")
    .setValue(20)
    .setRange(0, 160)
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

  pushMatrix();
  translate((width/2), (height/2));
  scale(displayScale);

  fill(0);

  for (int i=0; i<=Cells.size()-1; i++) {
    if (floor(Cells.get(i).targetX)!=floor(Cells.get(i).x) && floor(Cells.get(i).targetY)!=floor(Cells.get(i).y)) {
      Cells.get(i).move();
    }
  }

  for (int i=0; i<=Cells.size()-1; i++) {
    Cells.get(i).render();
  }


  loadSVG();
  popMatrix();
  sliderBackground();
  slider.draw();
  displayDragEnterScene();


  float textSz = 15;
  float space = 33;
  float textSpaceX = 27;
  float szW = 180;
  float szH = 70;

  float textZabutonX = width;

  if (isViewCopiedText && !isDragEnter) {
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
    findCirclesFromSVG(xml, circles);

    autoResizeCells(xml);
    addCellsFromSVG(circles);


    isDragEnter = false;
    isDrop = false;
  }
}

void sliderBackground() {
  fill(0, 0, 0, 100);
  noStroke();
  rect(10, 10, sliderWidth*1.42, 90);
}
