import geomerative.*;           // library for text manipulation and point extraction


PShape s;  // The PShape object
PShape logo; // Create the shape group
PShape bezier; 


void setup() {
  size(500, 500, P2D);

  // Creating a custom PShape by specifying a series of vertices.  
  int width = 100;
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
  
  ////////////////////////////////////////////
  
  bezier = createShape();
  bezier.beginShape();
  
  bezier.stroke(0);
  bezier.strokeWeight(5);
  bezier.vertex(30, 20);
  bezier.bezierVertex(80, 0, 80, 75, 30, 75);
  bezier.endShape();
  
  ////////////////////////////////////////////
  
  ////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  
  
}


void draw() {
  shape(s, 50, 50);
  // shape(bezier, 200, 200);
}
