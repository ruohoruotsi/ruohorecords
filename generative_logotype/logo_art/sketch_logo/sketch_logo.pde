/* //<>// //<>// //<>// //<>//
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

// Control
Boolean down = true;

int pd = 1; // pixelDensity multiplier
int pdG = 2; // pgraphics pixelDensity multiplier

void setup() {

  size(700, 700, FX2D);
  pixelDensity(pd);  // fullScreen();
  smooth(8);
  frameRate(1);

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
  rrGraphics.stroke(255);       // make stroke black/white
  rrlogo.drawDelaunayTriangulation();
  rrGraphics.endDraw();

  // (2) Draw the hole (R shape) into a pgraphics (black == transparent, white == opaque)
  maskHole.beginDraw();
  maskHole.background(255);  // white
  maskHole.fill(0);          // black
  maskHole.smooth(8); 
  maskHole.noStroke();
  rrlogo.diff.draw(maskHole);  
  maskHole.endDraw();

  // (3) apply/blend the mask, draw on the border and blend in onto the rrgraphics
  rrGraphics.blend(maskHole, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, ADD);
  // drawMultiLineBorder();
  drawTriangleBorder();
  rrGraphics.blend(maskBorder, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, MULTIPLY);

  image(rrGraphics, 0, 0, width, height);
  // rrGraphics.save("highRes.tif");

  // save("rrGraphics-highRes.tif");
  // saveFrame("line-######.png");
  
  // print("frameCount: " + frameCount + " SINE: " + (1 +sin(frameCount * 0.1))); 
  
}


void drawTriangleBorder () {
  
  maskBorder.beginDraw();
  
  maskBorder.background(255);
  //maskBorder.noStroke();
  maskBorder.fill(getColorPalette());
  int borderWidth = 40;
  int cdotsize = 15;

  // top
  RShape topBorder = RShape.createRectangle(0, 0, maskBorder.width, borderWidth); 
  // left
  RShape leftBorder = RShape.createRectangle(0, 0, borderWidth, maskBorder.height);  
  // right
  RShape rightBorder = RShape.createRectangle(maskBorder.width - borderWidth, 0, maskBorder.width - borderWidth, maskBorder.height);
  // bottom 
  RShape bottomBorder = RShape.createRectangle(0, maskBorder.height - borderWidth, maskBorder.width, maskBorder.height);

  // segment into dots and draw
  int val = 80 + frameCount % 30;
  println("segmentLength == " + val);
  RCommand.setSegmentLength(val);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

  RPolygon topPolygon = topBorder.toPolygon();
  RPolygon leftPolygon = leftBorder.toPolygon();
  RPolygon rightPolygon = rightBorder.toPolygon();
  RPolygon bottomPolygon = bottomBorder.toPolygon();

  int i = 0;  
  maskBorder.beginShape();
  for ( i = leftPolygon.contours[0].points.length/2; 
        i < leftPolygon.contours[0].points.length; i++)
  {
    // left side triangles pointing right
    RPoint leftPoints = leftPolygon.contours[0].points[i];
    maskBorder.fill(getColorPalette());
    maskBorder.triangle(leftPoints.x, leftPoints.y, 
                       leftPoints.x + borderWidth, leftPoints.y + borderWidth, 
                       leftPoints.x, leftPoints.y + 2*borderWidth);
    
    // draw white center dots                   
    maskBorder.fill(255);
    maskBorder.ellipse(leftPoints.x + borderWidth/3, leftPoints.y + borderWidth, cdotsize, cdotsize);
    maskBorder.fill(getColorPalette());
  }
  //maskBorder.endShape();
  
  //maskBorder.beginShape();
  for ( i = 0; i < (topPolygon.contours[0].points.length/2); i++)
  {
    // top side triangles pointing down
    RPoint topPoints = topPolygon.contours[0].points[i];
    maskBorder.triangle(topPoints.x, topPoints.y, 
                       topPoints.x + 2*borderWidth, topPoints.y, 
                       topPoints.x + borderWidth, topPoints.y + borderWidth);
                       
    // draw white center dots                   
    maskBorder.fill(255);
    maskBorder.ellipse(topPoints.x + borderWidth, topPoints.y + borderWidth/3, cdotsize, cdotsize);
    maskBorder.fill(getColorPalette());                             
  }
  //maskBorder.endShape();
  
  //maskBorder.beginShape();
  for ( i = (rightPolygon.contours[0].points.length/2 - 1); 
        i < rightPolygon.contours[0].points.length; i++)  
 {
    // right side triangles pointing left
    RPoint rightPoints = rightPolygon.contours[0].points[i];
    maskBorder.triangle(rightPoints.x, rightPoints.y, 
                        rightPoints.x + borderWidth, rightPoints.y - borderWidth, 
                        rightPoints.x + borderWidth, rightPoints.y + borderWidth);
                        
    // draw white center dots                   
    maskBorder.fill(255);
    maskBorder.ellipse(rightPoints.x + 2*borderWidth/3, rightPoints.y, cdotsize, cdotsize);
    maskBorder.fill(getColorPalette());                        
  }
  //maskBorder.endShape();
  
  //maskBorder.beginShape();
  for ( i = 0; i < bottomPolygon.contours[0].points.length/2; i++)
  {
    RPoint bottomPoints = bottomPolygon.contours[0].points[i];
    maskBorder.triangle(bottomPoints.x, bottomPoints.y, 
                        bottomPoints.x - borderWidth, bottomPoints.y + borderWidth,
                        bottomPoints.x + borderWidth, bottomPoints.y + borderWidth);
                        
   // draw white center dots                   
   maskBorder.fill(255);
   maskBorder.ellipse(bottomPoints.x, bottomPoints.y + 2*borderWidth/3, cdotsize, cdotsize);
   maskBorder.fill(getColorPalette());                                          
  }
  
  maskBorder.endShape();
  maskBorder.endDraw();
}


void drawMultiLineBorder() {
  maskBorder.beginDraw();

  maskBorder.fill(255); // white
  int interlineDist = 10;
  for (int i = 0; i < 5; i++)
  {
    maskBorder.strokeWeight(3);
    maskBorder.stroke(getColorPalette());  // 
    maskBorder.rect(0 + i*interlineDist, 0 + i*interlineDist, 
      maskBorder.width - 2*i*interlineDist, maskBorder.height - 2*i*interlineDist);
  }

  maskBorder.endDraw();
}

color getColorPalette() {
  int anchor = 50 + int(random(-20, 50));
  color rrred = color(anchor, int(random(0, 20)), int(random(0, 20))); 
  return rrred;
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
    } else {  //<>//
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
    
    // IOHAVOC backtobasics
    float val = 210 + 80 * sin(frameCount * 0.1);  // sinusoidal, not linear
    //int val = 110 + frameCount % 30;
    println("segmentLength == " + val);
    RCommand.setSegmentLength(val);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    //<>//
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
    drawTriangles(wavePolygon.contours[0].points.length, P, g); //<>//
  } //<>//

  //*********************************************
  // **** COMPUTES AND DRAWS DELAUNAY TRIANGLES
  //********************************************* //<>//
  boolean dots = true;           // toggles display circle centers
  boolean numbers = true;        // toggles display of vertex numbers 

  void drawTriangles(int vn, pt[] P, processing.core.PGraphics g) {  //<>//

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

            //*****************************************
            // triangle circumscribing circles
            //g.stroke(rrgreen); 
            //g.ellipse(X.x,X.y,2*r,2*r); 
            //g.stroke(color(80, 0, 80)); 
            // g.ellipse(X.x, X.y, 1*r, 1*r); 
            //

            if (dots) {
              //g.strokeWeight(8);
              //g.stroke(rrblue); 
              // X.show(4, g); // little blue dots
            };

            // draw actual tiangles
            g.beginShape(); 
            g.fill(getColorPalette());      // add an alpha 150 is good 
            P[i].vert(g); 
            P[j].vert(g); 
            P[k].vert(g); 

            g.endShape();
          };
        }; //<>//
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