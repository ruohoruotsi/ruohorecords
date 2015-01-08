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

////////////////////////////////////////////////////////////////////////////////////////
// Globals
final int letterWidth = 400;
final int letterHeight = 400;

final int canvasWidth = 700;
final int canvasHeight = 700;

////////////////////////////////////////////////////////////////////////////////////////
// Shapes
RShape circle;
RShape rectangle;
RShape triangle;
RShape circumscribingCircle;
RShape diff;

int upperLeft = 0;

////////////////////////////////////////////////////////////////////////////////////////
// Control
Boolean down = true;

void setup() {
  
  smooth(8);
  // noStroke();
  strokeWeight(3);
  size(canvasWidth, canvasHeight, P2D);
  background(255);
  frameRate(15);
  
  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  
  // Circumscribing circle
  int distanceIn = 100;
  int ccircleWidth = canvasWidth - distanceIn;
  circumscribingCircle = RShape.createEllipse(ccircleWidth/2, ccircleWidth/2, ccircleWidth, ccircleWidth);
  circumscribingCircle.translate(distanceIn/2, distanceIn/2);
  // circumscribingCircle.draw();

  // Union shapes
  int circleWidth = letterWidth * 8 / 10;
  
  rectangle = RShape.createRectangle(0, 0, circleWidth/2, circleWidth); 
  //rectangle.draw();
  circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth , circleWidth);
  //circle.draw();
 
  triangle = new RShape();
  triangle.addLineTo(circleWidth, letterHeight);
  triangle.addLineTo(0, letterHeight);
  // triangle.draw();
  
  // Diff
  diff = triangle.union(circle).union(rectangle);
  // diff = rectangle.union(circle);

  // Translate to center
  int translateWidth = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
  int translateHeight = (canvasHeight - letterHeight)/2;
  diff.translate(translateWidth, translateHeight);
  
  upperLeft  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
  // fill(156, 0, 7);
  // diff.draw();   
  
  ////////////////////////////////////////////////////////////////////////////////////////
  // draw Guides
  /*
  strokeWeight(2);
  // ellipseMode(CENTER);
  // ellipse(letterWidth/2, letterHeight/2, letterWidth/4, letterHeight/4);
  
  line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  */
  // end draw Guides
  ////////////////////////////////////////////////////////////////////////////////////////
  
  
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
  
  // saveFrame("grab.png");
}


void draw() 
{
  background(255);
    fill(156, 0, 7);
 
  strokeWeight(2);
  // circumscribingCircle.draw();
  
  ////////////////////////////////////////////////////////////////////////////////////////
  // draw Guides
  
  // ellipseMode(CENTER);
  // ellipse(letterWidth/2, letterHeight/2, letterWidth/4, letterHeight/4);
  
  //line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  //line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  
  // end draw Guides
  ////////////////////////////////////////////////////////////////////////////////////////
  
  
  ////////////////////////////////////////////////////////////////////////////////////////
  // V1 variable segments/dots around the outline
  // RCommand.setSegmentLength(frameCount % 50);
  ////////////////////////////////////////////
  
  ////////////////////////////////////////////
  // V2 variable segments/dots around the outline
  int maxFrames = 60;
  int multiplier = 1;
  int seglenA = frameCount % maxFrames;
  if (seglenA == 0) down = !down;  
  if(down) {
      RCommand.setSegmentLength(seglenA * multiplier);
  } else {   
      RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
  }
    
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  System.out.println(seglenA);
  ////////////////////////////////////////////////////////////////////////////////////////

  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  RPoint[] pnts = diff.getPoints();
  ellipse(pnts[0].x, pnts[0].y, 5, 5);
  for ( int i = 1; i < pnts.length; i++ )
  {    
    line( pnts[i-1].x, pnts[i-1].y, pnts[i].x, pnts[i].y );
    ellipse(pnts[i].x, pnts[i].y, 5, 5);
  } 
 
 
  ////////////////////////////////////////////////////////////////////////////////////////
  /* IO HAVOC -- add red mesh
    RMesh mesh = diff.toMesh();
    for ( int i = 0; i < mesh.strips.length; i++ )
    {
        RPoint[] pnts = mesh.strips[i].getPoints();
            
        beginShape(TRIANGLE_STRIP);
            for ( int ii = 0; ii < pnts.length; ii++ )
            {
                vertex( pnts[ii].x, pnts[ii].y );
            }
        endShape();
    }
 */
 ////////////////////////////////////////////////////////////////////////////////////////
 
 
 ////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////
  /// Excellent starter
  RPoint[] myPoints = diff.getPoints();
  int startx = (canvasWidth)/2; 
  int starty = (canvasHeight - letterHeight)/2;
  beginShape();
  for (int i=0; i<myPoints.length; i++) {
    
    float jitter = random(0, 30);
    
    // starting point OMG!!
    // line(myPoints[i].x, myPoints[i].y, 10, 10);
    line(myPoints[i].x, myPoints[i].y, upperLeft, starty);

    
    vertex(myPoints[i].x, myPoints[i].y);//PLAY WITH ADDING OR SUBSTRACTING JITTER
    vertex(myPoints[i].x+jitter, myPoints[i].y+jitter);
    vertex(myPoints[i].x-jitter, myPoints[i].y-jitter);
    
    //line(myPoints[i].x, myPoints[i].y,30,-280);
    //line(myPoints[i].x, myPoints[i].y,20,myPoints[i].y);
    //ellipse(myPoints[i].x+10,myPoints[i].y,3,3);
  }
  endShape();
 ////////////////////////////////////////////////////////////////////////////////////////
}
