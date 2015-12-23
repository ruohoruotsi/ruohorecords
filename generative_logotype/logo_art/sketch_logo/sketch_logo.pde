/* //<>// //<>//
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
RLogotype rrlogo;
pt[] P = new pt [2048]; // points to delaunay triangulate

// PGraphics layers
PGraphics rrGraphics;  
PGraphics maskHole;
PGraphics maskBorder;

// Colors
color rrred = color(120, 10, 10); 
color rrblue = color(255, 70, 50); 
color rrgreen = color(0, 150, 0); 

// Control
Boolean down = true;

int pd = 1; // pixelDensity multiplier
int pdG = 2; // pgraphics pixelDensity multiplier

void setup() {

  size(700, 700, FX2D); //<>//
  pixelDensity(pd);  // fullScreen();
  smooth(8);
  frameRate(8);

  rrGraphics = createGraphics(pdG * width, pdG * height);
  maskHole   = createGraphics(pdG * width, pdG * height);
  maskBorder = createGraphics(pdG * width, pdG * height);
  
  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  rrlogo = new RLogotype(400 * pdG, 500 * pdG, rrGraphics);
  rrlogo.setupRC();
}


void draw() 
{
  ////////////////////////////////////////////////////////////////////////////////////////
  // draw Guides
  // strokeWeight(2);
  // line(width/2, 0, width/2, height);  // vertical guide
  // line(0, height/2, width, height/2); // horizontal guide
  // end draw Guides
  ////////////////////////////////////////////////////////////////////////////////////////

  background(255);  // clear main background
  
  // (1) Main drawing to the PGraphics 
  rrGraphics.beginDraw();
  rrGraphics.background(255); // clear background on each frame redraw
  rrGraphics.strokeWeight(4*pdG);  
  rrGraphics.stroke(255);  
  rrlogo.drawDelaunayTriangulation();
  rrGraphics.endDraw();
  // rrGraphics.save("highRes.tif");
  
  //PImage img = rrGraphics.get(0, 0, rrGraphics.width, rrGraphics.height); //snap an image from the off-screen graphics  
  //println("rrrgraphics.width: " + rrGraphics.width + " height: " + rrGraphics.height);
  //println("main screen width: " + width            + " height: " + height);
  //img.resize(width, height); // resize to fit the on-screen display 
  //image(img, 0, 0); // display the resized image on screen  
  
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
  maskBorder.rect(0, 0, pdG * width, pdG * height);
  maskBorder.endDraw();

  // (3) apply/blend the mask hole to the border (to create a transparent cutout)
  // maskBorder.mask(maskHole);
  // image(maskBorder, 0, 0, pd*width, pd*height);
  // blend(maskBorder, 0, 0, pd*width, pd*height, 0, 0, pd*width, pd*height, SUBTRACT);

  //// working
  //PImage img = rrGraphics.get(0, 0, rrGraphics.width, rrGraphics.height);
  //img.resize(width, height); // resize to fit the on-screen display 
  //image(img, 0, 0); // display the resized image on screen  
  //maskBorder.mask(maskHole);
  //image(maskBorder, 0, 0, pdG*width, pdG*height);
  
  // working ALT
  rrGraphics.blend(maskHole, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, ADD);
  image(rrGraphics, 0, 0, width, height);
  // rrGraphics.save("rrGraphics-highRes.tif");

  // rrGraphics.mask(maskHole);
  // image(rrGraphics, 0, 0, pdG*width, pdG*height);
  // maskBorder.save("maskBorder-highRes.tif");

  // saveFrame("line-######.png");
}
 

class RLogotype {

  // Component Shapes
  RShape circle;
  RShape rectangle;
  RShape triangle;
  RShape diff;
  PGraphics g;

  int lowerRightX = 0;
  int lowerRightY = 0;
  int letterWidth = 0;
  int letterHeight = 0;

  // Constructor 
  RLogotype(int logoWidth, int logoHeight, PGraphics pg) {
    letterWidth = logoWidth;
    letterHeight = logoHeight;
    g = pg;
  }

  void setupRC() {

    // Union shapes
    int circleWidth = letterWidth;
    rectangle = RShape.createRectangle(0, 0, circleWidth/2, circleWidth); 
    circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth, circleWidth);

    println("circleWidth: " + circleWidth);
    println("letterWidth: " + letterWidth);

    triangle = new RShape();
    triangle.addLineTo(circleWidth, letterHeight);
    triangle.addLineTo(0, letterHeight);

    // Diff
    diff = triangle.union(circle).union(rectangle);

    // Translate to center
    int translateWidth = (letterWidth - circleWidth)/2 + (g.width - letterWidth)/2;
    int translateHeight = (g.height - letterHeight)/2;
    diff.translate(translateWidth, translateHeight);

    // Compute and store important points in the shape
    lowerRightX = circleWidth + (letterWidth - circleWidth)/2 + (g.width - letterWidth)/2;
    lowerRightY  = (letterWidth - circleWidth)/2 + (g.width - letterWidth)/2;

    println("pgraphics: " + g.width);
    println("translateWidth: " + translateWidth);
    println("translateHeight: " + translateHeight);

    System.out.println("upper left : (" + translateWidth + ", " + translateHeight + ")");
    System.out.println("lower right: (" + lowerRightX + ", " + lowerRightY + ")");
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
  } 

  void geomerativeStaticSegmentation(int segmentLength) {
    RCommand.setSegmentLength(segmentLength);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  } 


  void drawDelaunayTriangulation() {

    // geomerativeVariableSegmentation(100, 1);
    // geomerativeVariableSegmentation(60, 1);
    
     //geomerativeVariableSegmentation(60, 1);
     // geomerativeVariableSegmentation(60, 10);
    //geomerativeStaticSegmentation(98);
    
    // IOHAVOC backtobasics
    int val = 110 + frameCount % 30;
    println("segmentLength == " + val);
    RCommand.setSegmentLength(val);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots

    // add some extra points to the polygon (to anchor it)
    // wavePolygon.addPoint(new RPoint(300, 498));
    // wavePolygon.addPoint(new RPoint(450, 475)); // crux point between 

    int i = 0;
    for ( i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      // g.ellipse(curPoint.x, curPoint.y, 5, 5);  // dots that circulate the perimeter

      ///// IOHAVOC populate P[i] autrement ... same storage 
      P[i] = new pt(curPoint.x, curPoint.y);
      // println("[" + i + "]  " + curPoint.x + "  " + curPoint.y);
    }
    P[0] = new pt(300, 500);     // (300,100), (300,300), (300,200), (350, 350)
    // P[1] = new pt(450, 475);  

    // R outline
    g.fill(getColorPalette());      // add an alpha 150 is good 
    rrlogo.diff.draw(g);  
    g.noFill();

    println("wavePolygon.contours[0].points.length: " + wavePolygon.contours[0].points.length);
    drawTriangles(wavePolygon.contours[0].points.length, P, g);
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

  void drawTriangles(int vn, pt[] P, processing.core.PGraphics g) { 

    pt X = new pt(0, 0);
    float r = 1;

    for (int i = 0; i < vn-2; i++) {
      for (int j = i+1; j < vn-1; j++) {
        for (int k = j+1; k < vn; k++) {

          boolean found = false; 
          for (int m = 0; m < vn; m++) {
            X = centerCC (P[i], P[j], P[k]);  
            r = X.disTo(P[i]); //<>//
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
             g.stroke(rrgreen); g.ellipse(X.x,X.y,2*r,2*r); 
             g.stroke(color(80, 0, 80)); g.ellipse(X.x, X.y, 1*r, 1*r); 
             // */

            if (dots) {
              //g.strokeWeight(1);
              //g.stroke(rrblue); 
              //X.show(4, g); // little blue dots
            };

            // draw actual tiangles
            g.beginShape(); 
            g.fill(getColorPalette());      // add an alpha 150 is good 
            P[i].vert(g); 
            P[j].vert(g); 
            P[k].vert(g); 

            g.endShape(); 
          };
        };
      };
    }; // end triple loop
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