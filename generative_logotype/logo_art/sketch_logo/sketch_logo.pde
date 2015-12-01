/*
//////////////////////////////////////////////
 --------- generative logotypography ----------
 //////////////////////////////////////////////
 Title   :   sketch_logo
 Date    :   12/23/2014 
 Version :   v0.5
 
 //////////////////////////////////////////////
 */

import geomerative.*;
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.processing.*;

// Globals
final int canvasWidth = 700;
final int canvasHeight = 700;

RShape circumscribingCircle;
RLogotype rrlogo;

// Control
Boolean down = true;

// frame params
int[] list;
int count = 0;
int distance;
PVector axis;
int[] strokeRGBA;

// toxiclibs voronoi params
// radius of the root triangle which encompasses (MUST) all other points
float DSIZE = 10000;
// a Voronoi diagram relies on a Delaunay triangulation behind the scenes
// we simply use this as a front end
Voronoi voronoi;
ToxiclibsSupport gfx;
// render switch
boolean doIgnoreRoot = true;
pt[] P = new pt [2048];


void setup() {
  
  size(700, 700, FX2D);
  pixelDensity(2);  // fullScreen();
  smooth(8);
  frameRate(3);

  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  rrlogo = new RLogotype(400, 500);
  rrlogo.setupRC();
  //////////////////////////////////////////////////////////////////////////////////////////

  // Voronoi
  voronoi = new Voronoi(DSIZE);
  gfx = new ToxiclibsSupport(this);

  // rrlogo.drawDelaunayTriangulation();
  // rrlogo.drawToxiclibsVoronoi();
}


void draw() 
{
 ////////////////////////////////////////////////////////////////////////////////////////
 // draw Guides
 // strokeWeight(2);
 // line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
 // line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
 // end draw Guides
 ////////////////////////////////////////////////////////////////////////////////////////

 // the main drawing
 rrlogo.drawDelaunayTriangulation();

 // DEBUG
 // rrlogo.drawDottedOutline();
 // rrlogo.drawToxiclibsVoronoi();
}



class RLogotype {

  // Component Shapes
  RShape circle;
  RShape rectangle;
  RShape triangle;
  RShape diff;

  int upperLeftX = 0;
  int lowerRight = 0;  
  int letterWidth = 0;
  int letterHeight = 0;

  // Constructor 
  RLogotype(int width, int height) {
    letterWidth = width;
    letterHeight = height;
  }

  void setupRC() {

    // Union shapes
    int circleWidth = letterWidth;
    rectangle = RShape.createRectangle(0, 0, circleWidth/2, circleWidth); 
    circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth , circleWidth);
   
    triangle = new RShape();
    triangle.addLineTo(circleWidth, letterHeight);
    triangle.addLineTo(0, letterHeight);
    
    // Diff
    diff = triangle.union(circle).union(rectangle);
  
    // Translate to center
    int translateWidth = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    int translateHeight = (canvasHeight - letterHeight)/2;
    diff.translate(translateWidth, translateHeight);
    
    // Compute and store important points in the shape
    upperLeftX  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    lowerRight = circleWidth + (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    //lowerLeftY  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;

    System.out.println("UR:" + lowerRight);
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  void geomerativeStaticSegmentation(int segLen) {

    // tell geomerative how to convert the outline
    RCommand.setSegmentLength(segLen);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  }

  void geomerativeVariableSegmentation(int maxFrames, int multiplier) {

    // tell geomerative how to convert the outline

    // V1 variable segments/dots around the outline
    // RCommand.setSegmentLength(frameCount % 50);

    // V2 variable segments/dots around the outline
    int seglenA = frameCount % maxFrames;
    if (seglenA == 0) down = !down;  
    if (down) {
      RCommand.setSegmentLength(seglenA * multiplier);
    } else {   
      RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
    }

    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    System.out.println(seglenA);
  }  

  ////////////////////////////////////////////////////////////////////////////////////////

  void drawDottedOutline() {

    geomerativeStaticSegmentation(25);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  
  void drawToxiclibsVoronoi() {

    geomerativeStaticSegmentation(20);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
      
      // add points from around the logo
      //voronoi.addPoint(new Vec2D(curPoint.x, curPoint.y));
    }
    
      background(255);
      fill(222, 222, 222);
      rrlogo.diff.draw();  

      stroke(0);
      noFill();
      stroke(0, 0, 255, 50);
    
      beginShape(TRIANGLES);
      // get the delaunay triangles
      for (Triangle2D t : voronoi.getTriangles()) {
        // ignore any triangles which share a vertex with the initial root triangle
        if (!doIgnoreRoot || (abs(t.a.x)!=DSIZE && abs(t.a.y)!=DSIZE)) {
          gfx.triangle(t, false);
        }
      }
      endShape();
    
      fill(255, 0, 255);
      noStroke();
      for (Vec2D c : voronoi.getSites()) {
        ellipse(c.x, c.y, 5, 5);
      }
           

  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////
   void testDelaunaySegmentation(int maxFrames, int multiplier) {

    // V1 variable segments/dots around the outline
    //RCommand.setSegmentLength(12 + frameCount % 50);

    //// V2 variable segments/dots around the outline
    int seglenA = frameCount % maxFrames;
    print("seglenA: " + seglenA + " ");
    
    if (seglenA == 0) down = !down;  
    if (down) {
     print("   down: " + down);
     RCommand.setSegmentLength(seglenA * multiplier + 12);
    } else { 
     print(" not down: " + !down);
     int val = (maxFrames - seglenA) * multiplier;
     print (" val " + val);
     RCommand.setSegmentLength(val + 12);
    }

    //RCommand.setSegmentLength(seglenA);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  } 
  
  void drawDelaunayTriangulation() {

    background(200);
    testDelaunaySegmentation(80, 5);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    //pt[] P = new pt [wavePolygon.contours[0].points.length];
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
      
      
      
      ///// IOHAVOC populate P[i] autrement ...same storage 
      P[i] = new pt(curPoint.x, curPoint.y);
      println(curPoint.x + "  " + curPoint.y);
    }
    
      fill(255);
      rrlogo.diff.draw();  
      noFill();
    
      println("wavePolygon.contours[0].points.length: " + wavePolygon.contours[0].points.length);

      drawTriangles(wavePolygon.contours[0].points.length, P);
      
    fill(0);
    ellipse(450, 475, 5, 5);
  }
  
  //*********************************************
  // **** COMPUTES AND DRAWS DELAUNAY TRIANGLES
  //*********************************************
  color red = color(200, 10, 10); color blue = color(10, 10, 200); color green = color(0, 150, 0); 
  boolean dots = true;           // toggles display circle centers
  boolean numbers = true;         // toggles display of vertex numbers 

  void drawTriangles(int vn, pt[] P) { 
     
    pt X = new pt(0,0);
    float r = 1;
     
    for (int i = 0; i < vn-2; i++) {
      for (int j = i+1; j < vn-1; j++) {
        for (int k = j+1; k < vn; k++) {
          boolean found = false; 
       
          for (int m = 0; m < vn; m++) {
             X = centerCC (P[i], P[j], P[k]);  
             r = X.disTo(P[i]);
             
             if ((m != i) && (m != j) && (m != k) && (X.disTo(P[m]) <= r)) {
               found = true;
           }
         };
         
       if (!found) {
           strokeWeight(1); 
           
           if(X.x > 500) {
             //stroke(red); ellipse(X.x, X.y, 2*r, 2*r); 
             continue;
           } else {
             stroke(color(80, 0, 80)); ellipse(X.x, X.y, 1*r, 1*r); 
           }
           
           
           if(rrlogo.diff.contains(X.x, X.y)){
             //print("Contains");
           }
           else {
              //println("Xxxxxxxxxxxxxxx");
              //println("( " + X.x + "," + X.y + ")");
              continue;
           }
           
           if (dots) {
            stroke(blue); X.show(2); 
           };
           strokeWeight(2); stroke(red); 
           
           beginShape(POLYGON);  
           P[i].vert(); P[j].vert(); P[k].vert(); 
           endShape(); 
         };
        }; }; }; // end triple loop
     };  
     
     
  //*********************************************
  // **** COMPUTE CIRCUMCENTER
  //*********************************************
  pt centerCC (pt A, pt B, pt C) {    // computes the center of a circumscirbing circle to triangle (A,B,C)
    vec AB =  A.vecTo(B);  float ab2 = dot(AB,AB);
    vec AC =  A.vecTo(C); AC.left();  float ac2 = dot(AC,AC);
    float d = 2*dot(AB,AC);
    AB.left();
    AB.back(); AB.mul(ac2);
    AC.mul(ab2);
    AB.add(AC);
    AB.div(d);
    pt X =  A.makeCopy();
    X.addVec(AB);
    return(X);
    };
 //<>// //<>// //<>// //<>//
}

////////////////////////////////////////////////////////////////////////////////////////

void mousePressed() {
  voronoi.addPoint(new Vec2D(mouseX, mouseY));
}