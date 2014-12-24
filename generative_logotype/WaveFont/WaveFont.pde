 /**
 * Fontastic
 * A font file writer for Processing.
 * http://code.andreaskoller.com/libraries/fontastic
 *
 * Example: WaveFont
 *
 * How to create characters with bezier curves.
 * The example also includes a way to preview
 * the bezier shapes before building the font.
 * 
 * @author      Andreas Koller http://andreaskoller.com
 */

import fontastic.*;
import java.util.List;
import geomerative.*;

//////////////////////////////////////////////
// Fontastic
//////////////////////////////////////////////

Fontastic f;
PFont myFont;

float charWidth = 512;
int version = 0;
boolean fontBuilt = false;

//////////////////////////////////////////////
// Geomerative
//////////////////////////////////////////////

RFont font;
String displayText = "R";

//////////////////////////////////////////////
// Constants
//////////////////////////////////////////////

final int canvasWidth = 800;
final int canvasHeight = 600;



void setup() {
 
  size(canvasWidth, canvasHeight);
  background(255);
  smooth(4);
  fill(0);
  
  RG.init(this); 
 

    
  //////////////////////////////////////////////

  randomizeFont();
  createFont();
}

void draw() {

  background(255);
  strokeWeight(2);
  textSize(25); // for small numbers at bezier lines

  int i = 0;
  pushMatrix();
  translate(width/2, height/4);
  scale(0.5);
  translate(-1*charWidth / 2 + i*charWidth, charWidth / 2);
  
  // draw outline so we can see what we're doing
  renderGlyphOutline('R', color(255,0,0), color(100)); 
  popMatrix();

  //////////////////////////////////////////////

  if(fontBuilt) {
    strokeWeight(1);
    pushMatrix();
    translate(width * 0.4, height * 0.9);

    // RFont -> RGroup -> RPoints
    
    // Make groups
    RGroup group = font.toGroup(displayText); 
    group = group.toPolygonGroup();
     
    // Get points from font/shape via the group
    RPoint[] fontPoints = group.getPoints();
  
    // Draw points as ellipses, lines, etc
    for (i=0; i < fontPoints.length; i++) {
      ellipse(fontPoints[i].x, fontPoints[i].y, 5, 5);
      // line(fontPoints[i].x, fontPoints[i].y, 10, 10);
      // line(fontPoints[i].x, fontPoints[i].y,8,-360);
      // line(fontPoints[i].x+10, fontPoints[i].y,fontPoints[i].x+9,fontPoints[i].y+130);
    }
    popMatrix();     
  } 
}

void randomizeFont() {

  version++;

  if (f != null) { f.cleanup(); }

  f = new Fontastic(this, "RuohoFont" + nf(version,4));
  f.setAuthor("Ruoho Ruotsi"); 
  f.setVersion("0.1");
  f.setAdvanceWidth(int(charWidth));

  System.out.println(Fontastic.alphabet.length);
  char c = 'R'; //Fontastic.alphabet[i];

  FPoint[] points = new FPoint[4];
  
  float rectSize = charWidth*0.5;
  float rnd = charWidth*0.2;

  points[0] = new FPoint(charWidth/2 - rectSize/2, charWidth/2 - rectSize/2);
  points[1] = new FPoint(charWidth/2 - rectSize/2, charWidth/2 + rectSize/2);
  points[2] = new FPoint(charWidth/2 + rectSize/2, charWidth/2 + rectSize/2);
  points[3] = new FPoint(charWidth/2 + rectSize/2, charWidth/2 - rectSize/2);

  points[0].setControlPoint1(points[0].x + rnd, points[0].y + random(-rnd, rnd));
  points[1].setControlPoint1(points[1].x + random(-rnd, rnd), points[1].y - rnd);
  points[2].setControlPoint1(points[2].x - rnd, points[2].y + random(-rnd, rnd));
  points[3].setControlPoint1(points[3].x - random(-rnd, rnd), points[3].y + rnd);

  points[0].setControlPoint2(points[0].x + random(-rnd, rnd), points[0].y + rnd);
  points[1].setControlPoint2(points[1].x + rnd, points[1].y + random(-rnd, rnd));
  points[2].setControlPoint2(points[2].x + random(-rnd, rnd), points[2].y - rnd);
  points[3].setControlPoint2(points[3].x - rnd, points[3].y + random(-rnd, rnd));

  f.addGlyph(c).addContour(points);
}

void renderGlyphOutline(char c, color linecolor, color handlecolor) {

    FPoint[] points = f.getGlyph(c).getContour(0).getPointsArray();

    // Draw the outline in Processing 
    for (int i=0; i < points.length; i++) {
      FPoint p1 = points[i];
      FPoint p2 = points[(i+1)%points.length];
      bezierWithHandles(i+"", p1.x, -p1.y, p1.controlPoint2.x, -p1.controlPoint2.y, p2.controlPoint1.x, -p2.controlPoint1.y, p2.x, -p2.y, linecolor, handlecolor);
    }

}

void renderGlyphSolid(char c) {
    
  FContour[] contours = f.getGlyph(c).getContoursArray();

  for (int j=0; j<contours.length; j++) {

    FPoint[] points = f.getGlyph(c).getContour(j).getPointsArray();

    if (points.length > 0) { //just to be sure    
      // Draw the solid shape in Processing
      beginShape();      
      for (int i=0; i<points.length; i++) {
        FPoint p1 = points[i];
        FPoint p2 = points[(i+1)%points.length];
        if (p1.hasControlPoint2() && p2.hasControlPoint1()) {
          if (i == 0) { 
            vertex(points[0].x, -points[0].y);
          }
          bezierVertex(p1.controlPoint2.x, -p1.controlPoint2.y, p2.controlPoint1.x, -p2.controlPoint1.y, p2.x, -p2.y);
        }
        else {
          vertex(p1.x, -p1.y);
        }
      }
      endShape();
    }
  }
}


void createFont() {

  f.buildFont();
  f.cleanup();

  myFont = createFont(f.getTTFfilename(), 200);
  font = new RFont(f.getTTFfilename(), 600, CENTER);

  fontBuilt = true;
}



void bezierWithHandles(String legend, float p1x, float p1y, float cp1x, float cp1y, float cp2x, float cp2y, float p2x, float p2y, color linecolor, color handlecolor) {

  stroke(handlecolor);
  line(p1x, p1y, cp1x, cp1y);
  line(p2x, p2y, cp2x, cp2y);

  fill(handlecolor);
  noStroke();
  float ellipseSize = 10;
  ellipse(cp1x, cp1y, ellipseSize,ellipseSize);
  ellipse(cp2x, cp2y, ellipseSize,ellipseSize);

  stroke(linecolor);
  noFill();
  bezier(p1x, p1y, cp1x, cp1y, cp2x, cp2y, p2x, p2y);

  stroke(0);
  textAlign(CENTER,CENTER);
  text(legend, p1x, p1y+25);

}

void keyPressed() {

  if (key == ' ') {
    //randomizeFont();
    //fontBuilt = false;
  }

  if (key == 's') {
    //createFont();
  }
}

