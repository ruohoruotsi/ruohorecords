/* //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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

enum colourPalette
{
  BACKGROUND, FOREGROUND
};

enum colourStyle
{
  BURGUNDY, GREEN // make gifs into animated gifs: convert -delay 200 -loop 0 *.gif animation.gif
};


int pd = 1;  // pixelDensity multiplier
int pdG = 2; // pgraphics pixelDensity multiplier

// strokeweight settings 
// original
//int outlineStroke  = 8;
//int internalDotStoke = 2;
//int innerlineStroke = 4;

// v1.0.1  - vimeo, github
//int outlineStroke  = 16;
//int internalDotStoke = 4;
//int innerlineStroke = 10;

// v1.0.2 - thicker twitter
int outlineStroke  = 30;  // IOHAVOC -- transparent mod
int internalDotStoke = 4;
int innerlineStroke = 16;  // IOHAVOC -- transparent mod


// Background cells
int celln = 5;
Cell[][] cells = new Cell[celln][celln];


void setup() {

  size(700, 700, FX2D);
  pixelDensity(pd);  // fullScreen();
  smooth(8);
  frameRate(2);

  rrGraphics = createGraphics(pdG * width, pdG * height);
  maskHole   = createGraphics(pdG * width, pdG * height);
  maskBorder = createGraphics(pdG * width, pdG * height);
  
  // BURGUNDY
  // colorPaletteImage = loadImage("paulklee-a-young-ladys-adventure-1921.jpg");
  // colorPaletteImage = loadImage("paulklee-at-the-core-1935.jpg");
  // colorPaletteImage = loadImage("paulklee-castle-sun-1928.jpg");

  // GREEN for RUOHO REVIEWS
  colorPaletteImage = loadImage("paulklee-europa-1933.jpg");
  // colorPaletteImage = loadImage("paulklee-the-angler-1921.jpg");
  // colorPaletteImage = loadImage("paulklee-monument-1929.jpg");


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
  rrGraphics.clear();
  rrGraphics.smooth(8);
  // rrGraphics.background(color(255, 0));     // clear background on each frame redraw
  rrGraphics.strokeWeight(outlineStroke*pdG);  // IOHAVOC - stroke weight for rrlogo outline
  
  color strokeColor = getRedColorPalette(colourPalette.BACKGROUND, colourStyle.GREEN);
  rrGraphics.stroke(255);    // 255 - to make stroke white
  
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
  // drawBorderBackground(); // IOHAVOC -- transparent commentout
  drawBlackBorder();
  // drawTriangleBorder();  // IOHAVOC -- transparent commentout
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

  // For removing the background
   rrGraphics.loadPixels();
   for(int n = 0; n < rrGraphics.pixels.length; n++) {
   //println("pixel vals " + rrGraphics.pixels[n]);
   rrGraphics.pixels[n] = rrGraphics.pixels[n] == color(0) ? 0x00000000 : rrGraphics.pixels[n] | 0xff000000;
   if(red(rrGraphics.pixels[n]) == green(rrGraphics.pixels[n]) && 
   red(rrGraphics.pixels[n]) == blue(rrGraphics.pixels[n])) {
   
   if(red(rrGraphics.pixels[n]) < 220)
   rrGraphics.pixels[n] = 0x00000000;
   }
   }
   rrGraphics.updatePixels();
   

  // rrGraphics.save("frames/" + frameCount + ".tif");
  rrGraphics.save("frames/" + frameCount + ".png");  // IOHAVOC -- transparent commentout
  // saveFrame("line-######.png");
}


////////////////////////////////////////////////////////////////////////////////////////
// drawBorderBackground: draws the main background for onto a PGraphics
////////////////////////////////////////////////////////////////////////////////////////

void drawBorderBackground () {

  maskBorder.beginDraw();
  maskBorder.background(getRedColorPalette(colourPalette.BACKGROUND, colourStyle.GREEN));
  //maskBorder.background(color(48,57,61));
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


void drawTriangleBorder () {

  maskBorder.beginDraw();
  color trianglePalette = getRedColorPalette(colourPalette.FOREGROUND, colourStyle.GREEN); //color(88, 38, 33); //color(255, 255, 255); 
  maskBorder.fill(trianglePalette);
  maskBorder.stroke(255);
  // maskBorder.stroke(trianglePalette);

  int borderWidth = 25;
  int blackBorderWidth = 0;

  int pgWidth = maskBorder.width - blackBorderWidth;
  int pgHeight = maskBorder.height - blackBorderWidth;
  int pgStartWidth = blackBorderWidth;
  int pgStartHeight = blackBorderWidth;

  // top 
  RShape topBorder = RShape.createRectangle(pgStartWidth, pgStartHeight, pgWidth, borderWidth); 
  // left
  RShape leftBorder = RShape.createRectangle(pgStartWidth, pgStartHeight, borderWidth, pgHeight);  
  // right
  RShape rightBorder = RShape.createRectangle(pgWidth - borderWidth, 0, borderWidth, pgHeight);
  // bottom 
  RShape bottomBorder = RShape.createRectangle(pgStartWidth, pgHeight - borderWidth, pgWidth, borderWidth);

  // segment into dots and draw
  // int val = int(100 + 50 * sin(frameCount * 0.1));  // good
  int val = int(55 + 10 * sin(frameCount * 0.1));  // sinusoidal, not linear

  println("segmentLength == " + val);
  RCommand.setSegmentLength(val);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

  // top 
  RPolygon topPolygon = topBorder.toPolygon();

  // left
  RPolygon leftPolygon = leftBorder.toPolygon();

  // right
  RPolygon rightPolygon = rightBorder.toPolygon();

  // bottom
  RPolygon bottomPolygon = bottomBorder.toPolygon();

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
  }
  //////////////////////////////////////////////////////////////////////////

  maskBorder.endShape();
  maskBorder.endDraw();
}



void drawBlackBorder() {

  maskBorder.beginDraw();
  maskBorder.fill(0);
  maskBorder.beginShape();

  int blackBorderWidth = 40;
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
    maskBorder.stroke(getRedColorPalette(colourPalette.FOREGROUND, colourStyle.GREEN));  // 
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
    maskBorder.stroke(getRedColorPalette(colourPalette.FOREGROUND, colourStyle.GREEN));  // 
    maskBorder.rect(0 + i*interlineDist, 0 + i*interlineDist, 
      maskBorder.width - 2*i*interlineDist, maskBorder.height - 2*i*interlineDist);
  }
  maskBorder.endDraw();
}

////////////////////////////////////////////////////////////////////////////////////////
// Color utils
////////////////////////////////////////////////////////////////////////////////////////
color getPhotoColorPalette() {
  colorPaletteImage.loadPixels(); 
  int y = int(random(colorPaletteImage.height));
  int x = int(random(colorPaletteImage.width));
  int loc = x + y*colorPaletteImage.width;

  // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
  float r = red(colorPaletteImage.pixels[loc]);
  float g = green(colorPaletteImage.pixels[loc]);
  float b = blue(colorPaletteImage.pixels[loc]);

  // Set the display pixel to the image pixel
  return color(r, g, b);
}

color getRedColorPalette(colourPalette pallette, colourStyle style) {
  // fg
  color fgc =  getPhotoColorPalette();

  // bg
  int val = int(noise(frameCount * 0.01) * 60);
  int anchor = 50 + (val - 30);

  // green
  color bgc = color(int(noise(frameCount * 0.01) * 20), anchor, int(noise(frameCount * 0.01) * 20));
  if (style == colourStyle.BURGUNDY) {
    // burgundy red
    bgc = color(anchor, int(noise(frameCount * 0.01) * 20), int(noise(frameCount * 0.01) * 20));
  }

  if (pallette == colourPalette.FOREGROUND && brightness(fgc) > brightness(bgc)) return fgc;
  else if (pallette == colourPalette.FOREGROUND && brightness(fgc) <= brightness(bgc)) return bgc;
  else if (pallette == colourPalette.BACKGROUND && brightness(fgc) > brightness(bgc)) return bgc;
  else return fgc;
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
    g.fill(getRedColorPalette(colourPalette.BACKGROUND, colourStyle.GREEN));      // add an alpha 150 is good 
    rrlogo.diff.draw(g);  
    // g.noFill();

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
               //X.show(4, g); // little blue dots
            };

            // draw actual tiangles
            g.beginShape(); 
            g.fill(getRedColorPalette(colourPalette.BACKGROUND, colourStyle.GREEN));      // add an alpha 150 is good 
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
            g.stroke(getRedColorPalette(colourPalette.FOREGROUND, colourStyle.BURGUNDY), 255);
            g.strokeWeight(internalDotStoke*pdG);  // IOHAVOC - stroke weight for delaunay triangles INSIDE stroke SHAPES

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
            // IOHAVOC g.stroke(getRedColorPalette(colourPalette.FOREGROUND, colourStyle.BURGUNDY), 255);
            g.strokeWeight(innerlineStroke*pdG);   // IOHAVOC - stroke weight for delaunay triangles inside LINES
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