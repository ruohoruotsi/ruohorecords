/*
//////////////////////////////////////////////
--------- generative logotypography ----------
//////////////////////////////////////////////
Title   :   sketch_letter
Date    :   12/23/2014 
Version :   v0.5

//////////////////////////////////////////////
*/

import geomerative.*;

////////////////////////////////////////////
// Globals
final int letterWidth = 400;
final int letterHeight = 400;

final int canvasWidth = 700;
final int canvasHeight = 700;

////////////////////////////////////////////
// Shapes
RShape circle;
RShape rectangle;
RShape triangle;
RShape circumscribingCircle;
RShape diff;

void setup() {
  
  smooth(8);
  // noStroke();
  strokeWeight(5);
  size(canvasWidth, canvasHeight, P2D);
  
  frameRate(10);
  
  ////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  
  // Circumscribing circle
  int distanceIn = 100;
  int ccircleWidth = canvasWidth - distanceIn;
  circumscribingCircle = RShape.createEllipse(ccircleWidth/2, ccircleWidth/2, ccircleWidth, ccircleWidth);
  circumscribingCircle.translate(distanceIn/2, distanceIn/2);
  circumscribingCircle.draw();

  // Union shapes
  int circleWidth = letterWidth * 8/10;
  
  rectangle = RShape.createRectangle(0, 0, circleWidth/2, letterHeight); 
  //rectangle.draw();
  circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth , circleWidth);
  //circle.draw();
 
  triangle = new RShape();
  triangle.addLineTo(circleWidth, letterHeight);
  triangle.addLineTo(0, letterHeight);
  // triangle.draw();
  
  // Diff
  diff = triangle.union(circle).union(rectangle);

  // Translate to center
  int translateWidth = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
  int translateHeight = (canvasHeight - letterHeight)/2;
  diff.translate(translateWidth, translateHeight);
  
  // fill(156, 0, 7);
  // diff.draw();   
  
  ////////////////////////////////////////////
  // draw Guides
  
  strokeWeight(2);
  // ellipseMode(CENTER);
  // ellipse(letterWidth/2, letterHeight/2, letterWidth/4, letterHeight/4);
  
  line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  
  // end draw Guides
  ////////////////////////////////////////////
  
  
  /*
  // tell geomerative how to convert the outline
  RCommand.setSegmentLength(25);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  
  // turn the RShape into an RPolygon
  RPolygon wavePolygon = diff.toPolygon();

  // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
  // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
  for(int i = 0; i < wavePolygon.contours[0].points.length; i++)
  {
    RPoint curPoint = wavePolygon.contours[0].points[i];
    ellipse(curPoint.x, curPoint.y, 5, 5);
  }
  */
  
  saveFrame("grab.png");
}


void draw() {

  ////////////////////////////////////////////

  background(255);
  // translate(width/2,height/2);

  //RCommand.setSegmentStep(random(0,3));
  //RCommand.setSegmentator(RCommand.UNIFORMSTEP);
    
  RCommand.setSegmentLength(frameCount % 50);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    
  //RCommand.setSegmentAngle(random(0,HALF_PI));
  //RCommand.setSegmentator(RCommand.ADAPTATIVE);

  RPoint[] pnts = diff.getPoints();
  
  ellipse(pnts[0].x, pnts[0].y, 15, 15);
  for ( int i = 1; i < pnts.length; i++ )
  {    
    line( pnts[i-1].x, pnts[i-1].y, pnts[i].x, pnts[i].y );
    ellipse(pnts[i].x, pnts[i].y, 15, 15);
 }
}
