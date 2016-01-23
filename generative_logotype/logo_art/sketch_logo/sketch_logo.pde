/* //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
 //////////////////////////////////////////////
 --------- generative logotypography ----------
 //////////////////////////////////////////////
 Title   :   sketch_logo
 Date    :   12/23/2014 
 Version :   v0.5
 
 //////////////////////////////////////////////
 */

import geomerative.*;

// Globals
RLogotype rrlogo;
pt[] P = new pt [2048]; // points to delaunay triangulate

// PGraphics layers
PGraphics rrGraphics;  
PGraphics maskHole;
PGraphics maskBorder;
PImage colorPaletteImage;

// Colors
color rrred = color(120, 10, 10); 

// Control
Boolean down = true;

int pd = 1; // pixelDensity multiplier
int pdG = 2; // pgraphics pixelDensity multiplier

// Background
int celln = 11;
Cell[][] cells = new Cell[celln][celln];


void setup() {

  size(700, 700, FX2D);
  pixelDensity(pd);  // fullScreen();
  smooth(8);
  frameRate(2);

  rrGraphics = createGraphics(pdG * width, pdG * height);
  maskHole   = createGraphics(pdG * width, pdG * height);
  maskBorder = createGraphics(pdG * width, pdG * height);
  colorPaletteImage = loadImage("paulklee-castle-sun-1928.jpg");

  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  rrlogo = new RLogotype(400 * pdG, 500 * pdG, rrGraphics);
  rrlogo.setupRC();

  ////////////////////////////////////////////////////////////////////////////////////////
  // bg 
  for (int i = 0; i < celln; i++)
    for (int j = 0; j < celln; j++) {
      cells[i][j] = new Cell(i*(maskBorder.width/celln), 
        j*(maskBorder.width/celln), 
        maskBorder.width/celln, 0);
      cells[i][j].rand();
    }
}

void draw() {

  background(value);
  drawLogo();
}

int value = 0;
void mousePressed() {

  drawLogo();
  if (value == 0) {
    value = 255;
  } else {
    value = 0;
  }
}


////////////////////////////////////////////////////////////////////////////////////////
// drawLogo: callable from a mouse handle event or the main draw loop
////////////////////////////////////////////////////////////////////////////////////////
void drawLogo() 
{
  background(255);  // clear main background

  // (1) Main R drawing to the rrGraphics PGraphics 
  rrGraphics.beginDraw();
  rrGraphics.background(255); // clear background on each frame redraw
  rrGraphics.strokeWeight(8*pdG);  
  rrGraphics.stroke(255);    // make stroke white
  rrlogo.drawDelaunayTriangulation();
  rrGraphics.endDraw();

  // (2) Draw the hole (R shape) into a masking pgraphics 
  // (black == transparent, white == opaque)
  maskHole.beginDraw();
  maskHole.background(255);  // white
  maskHole.fill(0);          // black
  maskHole.smooth(8); 
  maskHole.noStroke();
  rrlogo.diff.draw(maskHole);  
  maskHole.endDraw();

  // (3) Draw backgrounds on maskBorder PGraphics - then apply/blend the mask 
  drawBorderBackground();
  // drawTriangleBorder();
  drawBlackBorder();
  rrGraphics.blend(maskHole, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, ADD);

  // (4) Draw the hole (R shape) inverted (white on black) into the border pgraphics
  maskHole.beginDraw();
  maskHole.background(0);  // black
  maskHole.fill(255);      // white 
  maskHole.noStroke();
  rrlogo.diff.draw(maskHole);  
  maskHole.endDraw();
  maskBorder.blend(maskHole, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, ADD);

  // (5) Blend border & R PGraphics
  rrGraphics.blend(maskBorder, 0, 0, pdG*width, pdG*height, 0, 0, pdG*width, pdG*height, MULTIPLY);
  image(rrGraphics, 0, 0, width, height);


  // rrGraphics.save("frames/" + frameCount + ".tif");
  // saveFrame("line-######.png");
}


////////////////////////////////////////////////////////////////////////////////////////
// drawBorderBackground: draws the main background for onto a PGraphics
////////////////////////////////////////////////////////////////////////////////////////

void drawBorderBackground () {

  //for (int i = 0; i < celln; i++)
  //  for (int j = 0; j < celln; j++)
  //    cells[i][j].rand();

  maskBorder.beginDraw();
  maskBorder.background(getRedColorPalette());
  //maskBorder.fill(getColorPalette());
  maskBorder.strokeWeight(4);
  maskBorder.stroke(255);

  maskBorder.translate((maskBorder.width % celln)/2, (maskBorder.width % celln)/2);
  for (int i = 0; i < celln; i++)
    for (int j = 0; j < celln; j++)
      cells[i][j].display(maskBorder);

  // reset
  maskBorder.resetMatrix();
  maskBorder.endDraw();
}

/*
void drawRandomSplashBorderBackground () {
 
 // http://www.openprocessing.org/sketch/15068
 maskBorder.beginDraw();
 
 maskBorder.background(getColorPalette());
 maskBorder.strokeWeight(2.0);
 maskBorder.stroke(255, 100);
 
 for ( int x=0; x <= maskBorder.width; x = x+1) {
 maskBorder.line(0, x, maskBorder.width, random(maskBorder.width));
 maskBorder.line(x, 0, random(maskBorder.width), maskBorder.width);
 }
 
 maskBorder.endDraw();
 }
 
 
 void drawBorderBackground () {
 
 maskBorder.beginDraw();
 maskBorder.background(255);
 maskBorder.noStroke();
 
 for (float i = 1; i <= 300; i +=5)
 for (int x = 0; x <= maskBorder.width; x += 5) {
 
 // 1
 float y = offset + (sin(angle) * scaleVal);
 maskBorder.fill(getColorPalette(), 5);
 maskBorder.ellipse(x, y, 24, 40);
 maskBorder.point(x, y);
 
 // 2
 y = offset + (cos(angle) * scaleVal);
 maskBorder.fill(getRedColorPalette(), 5);
 maskBorder.rect(x, y, 30, 13);
 
 // 3
 y = (sin(angle) * scaleVal);
 maskBorder.fill(getColorPalette(), 5);
 maskBorder.rect(x, y, 5, 15);
 angle += angleInc;
 }
 
 maskBorder.endDraw();
 } */


////////////////////////////////////////////////////////////////////////////////////////
// drawTriangleBorder: draws rotating triangle border 
////////////////////////////////////////////////////////////////////////////////////////
void drawTriangleBorder () {

  maskBorder.beginDraw();
  maskBorder.fill(0);
  // maskBorder.fill(getColorPalette());

  int borderWidth = 40;
  int blackBorderWidth = 10;
  int cdotsize = 15;

  int pgWidth = maskBorder.width - blackBorderWidth;
  int pgHeight = maskBorder.height - blackBorderWidth;
  int pgStartWidth = blackBorderWidth;
  int pgStartHeight = blackBorderWidth;

  // top 
  RShape topBorder = RShape.createRectangle(pgStartWidth, pgStartHeight, pgWidth, borderWidth); 
  RShape topBorder2 = RShape.createRectangle(pgStartWidth, pgStartHeight+ borderWidth, pgWidth, borderWidth);

  // left
  RShape leftBorder = RShape.createRectangle(pgStartWidth, pgStartHeight, borderWidth, pgHeight);  
  RShape leftBorder2 = RShape.createRectangle(pgStartWidth + borderWidth, 0, borderWidth, pgHeight);

  // right
  RShape rightBorder = RShape.createRectangle(pgWidth - borderWidth, 0, borderWidth, pgHeight);
  RShape rightBorder2 = RShape.createRectangle(pgWidth - 2*borderWidth, 0, borderWidth, pgHeight);

  // bottom 
  RShape bottomBorder = RShape.createRectangle(pgStartWidth, pgHeight - borderWidth, pgWidth, borderWidth);
  RShape bottomBorder2 = RShape.createRectangle(pgStartWidth, pgHeight - 2*borderWidth, pgWidth, borderWidth);

  // segment into dots and draw
  // int val = int(100 + 50 * sin(frameCount * 0.1));  // good
  int val = int(130 + 20 * sin(frameCount * 0.1));  // sinusoidal, not linear

  println("segmentLength == " + val);
  RCommand.setSegmentLength(val);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

  // top 
  RPolygon topPolygon = topBorder.toPolygon();
  RPolygon topPolygon2 = topBorder2.toPolygon();

  // left
  RPolygon leftPolygon = leftBorder.toPolygon();
  RPolygon leftPolygon2 = leftBorder2.toPolygon();

  // right
  RPolygon rightPolygon = rightBorder.toPolygon();
  RPolygon rightPolygon2 = rightBorder2.toPolygon();

  // bottom
  RPolygon bottomPolygon = bottomBorder.toPolygon();
  RPolygon bottomPolygon2 = bottomBorder2.toPolygon();

  int i = 0;  
  maskBorder.beginShape();

  //////////////////////////////////////////////////////////////////////////
  // TOP 1
  for ( i = 0; i < topPolygon.contours[0].points.length / 2; i++)
  {
    // top side triangles pointing down
    RPoint topPoints = topPolygon.contours[0].points[i];
    maskBorder.triangle(topPoints.x, topPoints.y, 
      topPoints.x + 2*borderWidth, topPoints.y, 
      topPoints.x + borderWidth, topPoints.y + borderWidth);

    // draw white center dots
    maskBorder.fill(255); 
    maskBorder.stroke(255);
    maskBorder.ellipse(topPoints.x + borderWidth, topPoints.y + borderWidth/3, cdotsize, cdotsize);
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c);
  }

  // TOP 2
  for ( i = 1; i < topPolygon2.contours[0].points.length / 2 -1; i++)
  {
    RPoint topPoints2 = topPolygon2.contours[0].points[i];
    maskBorder.triangle(topPoints2.x, topPoints2.y, 
      topPoints2.x - borderWidth, topPoints2.y + borderWidth, 
      topPoints2.x + borderWidth, topPoints2.y + borderWidth);

    //maskBorder.fill(color(0, 255, 255));
    //maskBorder.ellipse(topPoints2.x, topPoints2.y, 5, 5);

    // draw white center dots                   
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c); 
    maskBorder.ellipse(topPoints2.x, topPoints2.y + 2*borderWidth/3, cdotsize, cdotsize);
  }
  //////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////////////////////
  // LEFT 1
  for ( i = leftPolygon.contours[0].points.length/2; // bottom
    i < leftPolygon.contours[0].points.length - 1; i++)  // top
  {
    // left side triangles pointing right
    RPoint leftPoints = leftPolygon.contours[0].points[i];
    maskBorder.triangle(leftPoints.x, leftPoints.y, 
      leftPoints.x + borderWidth, leftPoints.y + borderWidth, 
      leftPoints.x, leftPoints.y + 2*borderWidth);

    // draw white center dots                   
    maskBorder.fill(255); 
    maskBorder.stroke(255);
    maskBorder.ellipse(leftPoints.x + borderWidth/3, leftPoints.y + borderWidth, cdotsize, cdotsize);
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c);
  }

  // LEFT 2
  for ( i = leftPolygon2.contours[0].points.length/2 + 1; // bottom
    i < leftPolygon2.contours[0].points.length - 2; i++) // top
  {
    // right side triangles pointing left
    RPoint leftPoints2 = leftPolygon2.contours[0].points[i];
    maskBorder.triangle(leftPoints2.x, leftPoints2.y, 
      leftPoints2.x + borderWidth, leftPoints2.y - borderWidth, 
      leftPoints2.x + borderWidth, leftPoints2.y + borderWidth);

    // draw white center dots                   
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c); 
    maskBorder.ellipse(leftPoints2.x + 2*borderWidth/3, leftPoints2.y, cdotsize, cdotsize);
  }
  //////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////////////////////
  // RIGHT 1
  for ( i = 1; i < rightPolygon.contours[0].points.length / 2; i++)  
  {
    // right side triangles pointing left
    RPoint rightPoints = rightPolygon.contours[0].points[i];
    maskBorder.triangle(rightPoints.x, rightPoints.y, 
      rightPoints.x - borderWidth, rightPoints.y + borderWidth, 
      rightPoints.x, rightPoints.y + 2*borderWidth);

    //// draw white center dots                   
    maskBorder.fill(255); 
    maskBorder.stroke(255);
    maskBorder.ellipse(rightPoints.x - borderWidth/3, rightPoints.y + borderWidth, cdotsize, cdotsize);
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c);
  }

  // RIGHT 2
  for ( i = 2; i < rightPolygon2.contours[0].points.length / 2 - 1; i++)
  {
    // left side triangles pointing right
    RPoint rightPoints2 = rightPolygon2.contours[0].points[i];
    maskBorder.triangle(rightPoints2.x, rightPoints2.y, 
      rightPoints2.x - borderWidth, rightPoints2.y - borderWidth, 
      rightPoints2.x - borderWidth, rightPoints2.y + borderWidth);

    //    maskBorder.fill(color(255, 0, 0));
    //    maskBorder.ellipse(rightPoints2.x, rightPoints2.y, 15, 15);

    // draw white center dots                   
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c); 
    maskBorder.ellipse(rightPoints2.x - 2*borderWidth/3, rightPoints2.y, cdotsize, cdotsize);
  }

  //////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////////////////////
  // BOTTOM
  for ( i = 1; i < bottomPolygon.contours[0].points.length/2; i++)
  {
    RPoint bottomPoints = bottomPolygon.contours[0].points[i];
    maskBorder.triangle(bottomPoints.x, bottomPoints.y, 
      bottomPoints.x - borderWidth, bottomPoints.y + borderWidth, 
      bottomPoints.x + borderWidth, bottomPoints.y + borderWidth);

    // draw white center dots                   
    maskBorder.fill(255); 
    maskBorder.stroke(255);
    maskBorder.ellipse(bottomPoints.x, bottomPoints.y + 2*borderWidth/3, cdotsize, cdotsize);
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c);
  }

  // BOTTOM 2
  for ( i = 2; i < bottomPolygon2.contours[0].points.length / 2 - 1; i++)
  {
    // bottom triangles pointing down
    RPoint bottomPoints2 = bottomPolygon2.contours[0].points[i];
    maskBorder.triangle(bottomPoints2.x, bottomPoints2.y, 
      bottomPoints2.x - 2*borderWidth, bottomPoints2.y, 
      bottomPoints2.x - borderWidth, bottomPoints2.y + borderWidth);

    // draw white center dots                   
    int c = getColorPalette(); 
    maskBorder.fill(c);  
    maskBorder.stroke(c); 
    maskBorder.ellipse(bottomPoints2.x - borderWidth, bottomPoints2.y + borderWidth/3, cdotsize, cdotsize);
  }

  //////////////////////////////////////////////////////////////////////////

  /*
  maskBorder.fill(0);
   maskBorder.stroke(0);  
   maskBorder.rect(0, 0, maskBorder.width, blackBorderWidth);  //top
   maskBorder.rect(0, 0, blackBorderWidth, maskBorder.height); // left
   maskBorder.rect(pgWidth, 0, blackBorderWidth, maskBorder.height);  // right
   maskBorder.rect(0, pgHeight, maskBorder.width, blackBorderWidth);  // bottom
   
   
   //////////////////////////////////////////////////////////////////////////
   // double lines 
   //////////////////////////////////////////////////////////////////////////
   
   int halfBorderWidth = blackBorderWidth /2 - 5;
   
   // outside
   maskBorder.fill(0);
   maskBorder.rect(0, 0, maskBorder.width, halfBorderWidth);  //top
   maskBorder.rect(0, 0, halfBorderWidth, maskBorder.height); // left
   maskBorder.rect(maskBorder.width - halfBorderWidth, 0, halfBorderWidth, maskBorder.height);  // right
   maskBorder.rect(0, maskBorder.height - halfBorderWidth, maskBorder.width, halfBorderWidth);  // bottom
   
   // inside 
   maskBorder.rect(halfBorderWidth, 3*halfBorderWidth, maskBorder.width, halfBorderWidth);  //top
   maskBorder.rect(3*halfBorderWidth, 0, halfBorderWidth, maskBorder.height); // left
   maskBorder.rect(pgWidth, 0, halfBorderWidth, maskBorder.height);  // right
   maskBorder.rect(0, pgHeight, maskBorder.width, halfBorderWidth);  // bottom
   
   //////////////////////////////////////////////////////////////////////////
   */

  maskBorder.endShape();
  maskBorder.endDraw();
}

void drawBlackBorder() {

  maskBorder.beginDraw();
  maskBorder.fill(0);
  maskBorder.beginShape();

  int blackBorderWidth = 20;
  int pgWidth = maskBorder.width - blackBorderWidth;
  int pgHeight = maskBorder.height - blackBorderWidth;

  //////////////////////////////////////////////////////////////////////////

  maskBorder.fill(0);
  maskBorder.stroke(0);  
  maskBorder.rect(0, 0, maskBorder.width, blackBorderWidth);  //top
  maskBorder.rect(0, 0, blackBorderWidth, maskBorder.height); // left
  maskBorder.rect(pgWidth, 0, blackBorderWidth, maskBorder.height);  // right
  maskBorder.rect(0, pgHeight, maskBorder.width, blackBorderWidth);  // bottom

  /*
  //////////////////////////////////////////////////////////////////////////
   // double lines 
   //////////////////////////////////////////////////////////////////////////
   
   int halfBorderWidth = blackBorderWidth /2 - 5;
   
   // outside
   maskBorder.fill(0);
   maskBorder.rect(0, 0, maskBorder.width, halfBorderWidth);  //top
   maskBorder.rect(0, 0, halfBorderWidth, maskBorder.height); // left
   maskBorder.rect(maskBorder.width - halfBorderWidth, 0, halfBorderWidth, maskBorder.height);  // right
   maskBorder.rect(0, maskBorder.height - halfBorderWidth, maskBorder.width, halfBorderWidth);  // bottom
   
   // inside 
   maskBorder.rect(halfBorderWidth, 3*halfBorderWidth, maskBorder.width, halfBorderWidth);  //top
   maskBorder.rect(3*halfBorderWidth, 0, halfBorderWidth, maskBorder.height); // left
   maskBorder.rect(pgWidth, 0, halfBorderWidth, maskBorder.height);  // right
   maskBorder.rect(0, pgHeight, maskBorder.width, halfBorderWidth);  // bottom
   
   //////////////////////////////////////////////////////////////////////////
   */

  maskBorder.endShape();
  maskBorder.endDraw();
}



////////////////////////////////////////////////////////////////////////////////////////
// drawMultiLineBorder_*: just a sketch drawing mutiple lines for a border 
////////////////////////////////////////////////////////////////////////////////////////
void drawMultiLineBorder_multicolore() {
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

void drawMultiLineBorder_thick() {
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

////////////////////////////////////////////////////////////////////////////////////////
// Color utils
////////////////////////////////////////////////////////////////////////////////////////
color getColorPalette() {
  colorPaletteImage.loadPixels(); 
  int y = int(random(height));
  int x = int(random(width));
  int loc = x + y*width;

  // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
  float r = red(colorPaletteImage.pixels[loc]);
  float g = green(colorPaletteImage.pixels[loc]);
  float b = blue(colorPaletteImage.pixels[loc]);

  // Set the display pixel to the image pixel
  return color(r, g, b);
}

color getRedColorPalette() {
  int anchor = 50 + int(random(-20, 50));
  color rr = color(anchor, int(random(0, 20)), int(random(0, 20))); 
  return rr;
}


////////////////////////////////////////////////////////////////////////////////////////
// Utils for inner R triangle patterns:
////////////////////////////////////////////////////////////////////////////////////////

PVector CrossProduct(PVector p1, PVector p2) {
  return p1.cross(p2);
}
float DotProduct(PVector p1, PVector p2) {
  return p1.dot(p2);
}

//are p1, p2 on same side of a,b?
boolean SameSide(PVector p1, PVector p2, PVector a, PVector b) {
  //http://www.blackpawn.com/texts/pointinpoly/default.html
  PVector cp1 = CrossProduct(PVector.sub(b, a), PVector.sub(p1, a));
  PVector cp2 = CrossProduct(PVector.sub(b, a), PVector.sub(p2, a));
  return (DotProduct(cp1, cp2)>=0);
}

//is p in triangle(a,b,c)?
boolean PointInTriangle(PVector p, PVector a, PVector b, PVector c) {
  //http://www.blackpawn.com/texts/pointinpoly/default.html
  return (SameSide(p, a, b, c) & SameSide(p, b, a, c) & SameSide(p, c, a, b));
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

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in 
    // typography/font_to_points_dots

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
    g.fill(getRedColorPalette());      // add an alpha 150 is good 
    rrlogo.diff.draw(g);  
    g.noFill();

    println("wavePolygon.contours[0].points.length: " + wavePolygon.contours[0].points.length);
    drawTriangles(wavePolygon.contours[0].points.length, P, g);
  }

  //*********************************************
  // **** COMPUTES AND DRAWS DELAUNAY TRIANGLES
  //*********************************************
  boolean dots = true;           // toggles display circle centers
  boolean numbers = true;        // toggles display of vertex numbers 

  void drawTriangles(int vn, pt[] P, processing.core.PGraphics g) { 

    pt X = new pt(0, 0);
    float r = 1;

    PVector p, a, b, c;

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
            //strokeWeight(2); 

            if (rrlogo.diff.contains(X.x, X.y)) {
              //print("Contains");
              // stroke(color(80, 80, 80)); ellipse(X.x, X.y, 1*r, 1*r);
            } else {
              //println("Xxxxxxxxxxxxxxx");
              //println("( " + X.x + "," + X.y + ")");
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
            g.fill(getRedColorPalette());      // add an alpha 150 is good 
            P[i].vert(g); 
            P[j].vert(g); 
            P[k].vert(g); 
            g.endShape();

            /*
            println();
             print("(" + P[i].x + ", " + P[i].y + "),  (" + 
             P[j].x + ", " + P[j].y + "),  (" +
             P[k].x + ", " + P[k].y + ")," ); */

            a = new PVector(P[i].x, P[i].y);
            b = new PVector(P[j].x, P[j].y);
            c = new PVector(P[k].x, P[k].y);

            int ii = int(random(5, 50));
            int jj = int(random(5, 50));

            // println("ii: " + ii + " jj: " + jj);
            g.stroke(getColorPalette(), 255);
            //g.strokeWeight(2*pdG);  

            int shape = int(random(3));
            int sz = int(random(3));

            int imin = (int) min(a.x, min(b.x, c.x));
            int imax = (int) max(a.x, max(b.x, c.x));
            int jmin = (int) min(a.y, min(b.y, c.y));
            int jmax = (int) max(a.y, max(b.y, c.y));

            for (int m = imin; m <= imax; m = m+ii) { 
              for (int n = jmin; n<= jmax; n = n+jj) { 

                p = new PVector(m, n);
                if (PointInTriangle(p, a, b, c)) { // blend in   
                  g.blendMode(SCREEN);
                  if (shape == 0)  g.point(m, n);
                  else if (shape == 1) g.rect(m, n, sz, sz);
                  else g.ellipse(m, n, sz, sz);
                }
              }
            } 

            println(); 
            println();
            g.stroke(255);
            g.strokeWeight(4*pdG);
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
  };
}

class Cell {
  float x, y, s, pos = 0, speed = 1.5;
  int m = 2, type; //0-empty
  boolean moving = false;

  Cell(float inx, float iny, float ins, int intp) {
    x = inx; 
    y = iny;
    s = ins;
    type = intp;
  }

  void change(int t) {
    if (t == 0) { 
      pos = type = 0;
      moving = false;
    } else
      if (t != type) {
        this.swap();
      }
  }

  void swap() {
    if (!moving) {
      int ptype = type;
      type = type % m+1;
      if ((ptype != type) && (ptype != 0)) moving = true;
    }
  }

  void rand() {
    if (type == 0)
      type = ceil(random(2));
    else 
    if (floor(random(2)) == 0) 
      this.swap();
  }

  boolean pressed() {
    return ((mouseX>x) && (mouseX<=x+s) && (mouseY>y) && (mouseY<=y+s));
  }

  void display(processing.core.PGraphics g) {
    if (moving) pos += speed;

    if (pos>s) {
      pos = 0;
      moving = false;
    }

    switch(type) {
    case 0: 
      break;

    case 1: 
      if (moving) {
        g.line(x, y+s-pos, x+s, y+pos);
        if (pos<s/2) {
          g.line(x+s, y+s/2+pos, x+s/2-pos, y+s);
          g.line(x+s/2+pos, y, x, y+s/2-pos);
        } else { 
          g.line(x-s/2+pos, y, x+s, y-s/2+pos);
          g.line(x, y+s*3/2-pos, x+s*3/2-pos, y+s);
        }
      } else {
        g.line(x, y, x+s, y+s);
        g.line(x+s/2, y, x+s, y+s/2);
        g.line(x, y+s/2, x+s/2, y+s);
      }
      break;

    case 2: 
      if (moving) {

        g.line(x+pos, y, x+s-pos, y+s);
        if (pos<s/2) {
          g.line(x+s/2+pos, y, x+s, y+s/2+pos);
          g.line(x, y+s/2-pos, x+s/2-pos, y+s);
        } else {
          g.line(x+s, y-s/2+pos, x+s*3/2-pos, y+s);
          g.line(x, y+s*3/2-pos, x-s/2+pos, y);
        }
      } else {
        g.line(x+s, y, x, y+s);
        g.line(x+s/2, y, x, y+s/2);
        g.line(x+s/2, y+s, x+s, y+s/2);
      }
      break;
    }
  }
}