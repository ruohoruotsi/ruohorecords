/*
//////////////////////////////////////////////
--------- generative logotypography ----------
//////////////////////////////////////////////
Title   :   sketch_logo
Date    :   12/23/2014 
Version :   v0.5

 */
//////////////////////////////////////////////
import geomerative.*;


PShape s;     // The PShape object
PShape logo;  // Create the shape group

final int canvasWidth = 800;
final int canvasHeight = 800;

void setup() {
  
  smooth();
  size(canvasWidth, canvasHeight, P2D);

  int width = 200;
  int height = 200;

  logo = createShape(GROUP);
  s = createShape();
  s.beginShape();
  s.stroke(0);
  s.strokeWeight(5);
  s.vertex(0, 0);
  s.vertex(0, height);
  s.vertex(width, height);
  s.vertex(width + 34, height - height/2);
  s.vertex(width, 0);
  s.vertex(30, 20);
  s.bezierVertex(80, 0, 80, 75, 30, 75);
  s.endShape(CLOSE);
  
  ////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  
}


void draw() {
  
  // draw Guides
  ellipseMode(CENTER);
  ellipse(canvasWidth/2, canvasHeight/2, canvasWidth/4, canvasHeight/4);
  
  line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  // draw Guides

   shape(s, 50, 50);
}
