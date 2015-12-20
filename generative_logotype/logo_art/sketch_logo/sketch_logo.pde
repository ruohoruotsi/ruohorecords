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

// PGraphics layers
PGraphics maskHole;
PGraphics maskBorder;

// Colors
color rrred = color(120, 10, 10); 
color rrblue = color(255, 70, 50); 
color rrgreen = color(0, 150, 0); 


// Control
Boolean down = true;

// global array of points
pt[] P = new pt [2048];

int pd = 1; // pixelDensity multiplier
int pdG = 1;
void setup() {

  size(700, 700, FX2D);
  pixelDensity(pd);  // fullScreen();
  smooth(8);
  frameRate(1);

  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  rrlogo = new RLogotype(400, 500);
  rrlogo.setupRC();

  maskHole = createGraphics(pdG*width, pdG*height);
  maskBorder = createGraphics(pdG*width, pdG*height);
}


void draw() 
{

  println("maskHole.width = " + maskHole.width);
  println("maskHole.height = " + maskHole.height);

  ////////////////////////////////////////////////////////////////////////////////////////
  // draw Guides
  // strokeWeight(2);
  // line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  // line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  // end draw Guides
  ////////////////////////////////////////////////////////////////////////////////////////

  background(255);
  // (1) Main drawing to the canvas
  rrlogo.drawDelaunayTriangulation();

  // (2) Draw the hole (R shape) into a pgraphics (black == transparent, white == opaque)
  maskHole.beginDraw();
  maskHole.background(255);  // white
  maskHole.fill(0);          // black
  maskHole.smooth(8); 
  maskHole.noStroke();
  rrlogo.diff.draw(maskHole);  
  maskHole.endDraw();

  // (3) Draw the border into a pgraphics, basically big reddish rect
  maskBorder.beginDraw();
  maskBorder.background(255);    // white
  maskBorder.fill(255);        // reddish
  maskBorder.smooth(8); 
  maskBorder.noStroke();
  maskBorder.rect(0, 0, pd*width, pd*height);
  maskBorder.endDraw();


  // (3) apply/blend the mask hole to the border (to create a transparent cutout)
  //maskBorder.mask(maskHole);
  //image(maskBorder, 0, 0, pd*width, pd*height);
  //blend(maskBorder, 0, 0, pd*width, pd*height, 0, 0, pd*width, pd*height, SUBTRACT);

  maskBorder.mask(maskHole);
  image(maskBorder, 0, 0, pd*width, pd*height);

  // saveFrame("line-######.png");
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
    circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth, circleWidth);

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

    System.out.println("upperLeftX:" + upperLeftX);
    System.out.println("UR:" + lowerRight);
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  void geomerativeVariableSegmentation(int maxFrames, int multiplier) {

    // V1 variable segments/dots around the outline
    //RCommand.setSegmentLength(12 + frameCount % 50);

    //// V2 variable segments/dots around the outline
    int seglenA = frameCount % maxFrames;
    print("seglenA: " + seglenA + " ");

    if (seglenA == 0) down = !down;  
    if (down) {
      print("   down: " + down + " ");
      RCommand.setSegmentLength(seglenA * multiplier + 12);
    } else { 
      print(" not down: " + !down + " " );
      int val = (maxFrames - seglenA) * multiplier;
      print (" val " + val);
      RCommand.setSegmentLength(val + 12);
    }

    // RCommand.setSegmentLength(seglenA);
    // RCommand.setSegmentLength(12);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    // RCommand.setSegmentator(RCommand.CUBICBEZIERTO);
    // RCommand.setSegmentator(RCommand.ADAPTATIVE);
  } 

  void geomerativeStaticSegmentation(int segmentLength) {
    RCommand.setSegmentLength(segmentLength);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  } 


  void drawDelaunayTriangulation() {

    // clear background on each frame redraw
    // background(255);
    // geomerativeVariableSegmentation(100, 1);
    // geomerativeVariableSegmentation(60, 1);

    geomerativeVariableSegmentation(60, 10);
    //geomerativeStaticSegmentation(98);


    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    //pt[] P = new pt [wavePolygon.contours[0].points.length];
    int i = 0;
    for ( i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);  // dots that circulate the perimeter

      ///// IOHAVOC populate P[i] autrement ... same storage 
      P[i] = new pt(curPoint.x, curPoint.y);
      // println(curPoint.x + "  " + curPoint.y);
    }
    P[0] = new pt(300, 498); // (300,100), (300,300), (300,200), (350, 350)

    // R outline
    fill(rrred);      // add an alpha 150 is good 
    rrlogo.diff.draw();  
    noFill();

    println("wavePolygon.contours[0].points.length: " + wavePolygon.contours[0].points.length);
    drawTriangles(wavePolygon.contours[0].points.length, P);
  }


  color getColorPalette() {
    int anchor = 50 + int(random(-20, 50));
    // color rrred = color(anchor, 10, 10); 
    color rrred = color(anchor, int(random(0, 20)), int(random(0, 20))); 
    return rrred;
  }

  //*********************************************
  // **** COMPUTES AND DRAWS DELAUNAY TRIANGLES
  //*********************************************
  boolean dots = true;           // toggles display circle centers
  boolean numbers = true;        // toggles display of vertex numbers 

  void drawTriangles(int vn, pt[] P) { 

    pt X = new pt(0, 0);
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
 //<>//
          if (!found) { //<>//
            //strokeWeight(2); 

            if (rrlogo.diff.contains(X.x, X.y)) {
              //print("Contains"); //<>// //<>//
              // stroke(color(80, 80, 80)); ellipse(X.x, X.y, 1*r, 1*r);
            } else {
              //println("Xxxxxxxxxxxxxxx");
              //println("( " + X.x + "," + X.y + ")"); //<>//
              // continue;
            } 

            /*****************************************
             // triangle circumscribing circles
             stroke(green); ellipse(X.x,X.y,2*r,2*r); 
             stroke(color(80, 0, 80)); ellipse(X.x, X.y, 1*r, 1*r); 
             // */


            if (dots) {
              strokeWeight(1);
              stroke(rrblue); 
              X.show(3); // little blue dots
            };

            strokeWeight(5);  //<>//
            stroke(255); 

            // draw actual tiangles
            color c = getColorPalette();
            // fill(random(200, 255) , random(20), random(20)); 
            // fill(c, 0);      // add an alpha 150 is good 
            fill(c);      // add an alpha 150 is good 

            beginShape(POLYGON);  
            P[i].vert(); 
            P[j].vert(); 
            P[k].vert(); 
            endShape();
          };
        };
      };
    }; // end triple loop //<>//
  };  


  //*********************************************
  // **** COMPUTE CIRCUMCENTER
  //*********************************************
  pt centerCC (pt A, pt B, pt C) {    // computes the center of a circumscirbing circle to triangle (A,B,C)

    vec AB =  A.vecTo(B);  
    float ab2 = dot(AB, AB);
    vec AC =  A.vecTo(C); 
    AC.left();  
    float ac2 = dot(AC, AC);
    float d = 2*dot(AB, AC);
    AB.left();
    AB.back(); 
    AB.mul(ac2);
    AC.mul(ab2);
    AB.add(AC);
    AB.div(d);
    pt X =  A.makeCopy();
    X.addVec(AB);
    return(X);
  }; //<>//
}