/*
//////////////////////////////////////////////
--------- generative lettertypography ----------
//////////////////////////////////////////////
Title   :   sketch_letter
Date    :   12/23/2014 
Version :   v0.5

 */
//////////////////////////////////////////////
import geomerative.*;


final int letterWidth = 400;
final int letterHeight = 400;

final int canvasWidth = 700;
final int canvasHeight = 700;

RShape circle;
RShape rectangle;
RShape triangle;

RShape circumscribingCircle;


void setup() {
  
  smooth(8);
  // noStroke();
  strokeWeight(5);
  size(canvasWidth, canvasHeight, P2D);
  
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
  RShape diff = triangle.union(circle).union(rectangle);

  // Translate to center
  int translateWidth = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
  int translateHeight = (canvasHeight - letterHeight)/2;
  diff.translate(translateWidth, translateHeight);
  diff.draw();   
  
   
  ////////////////////////////////////////////
  // draw Guides
  
  strokeWeight(2);
  // ellipseMode(CENTER);
  // ellipse(letterWidth/2, letterHeight/2, letterWidth/4, letterHeight/4);
  
  line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  
  // end draw Guides
  ////////////////////////////////////////////
  
}


void draw() {
  /*

  ////////////////////////////////////////////

  for( int i = 0; i < rpoly.contours.length; i++ )
  {
      // test
      // rpoly.contours[i].draw();
     
      RPoint[] pnts = rpoly.contours[i].getPoints();
      
      int j = 1;
      strokeWeight(5);

      for ( ; j < pnts.length; j++ )
      {
          line( pnts[j-1].x, pnts[j-1].y, pnts[j].x, pnts[j].y );
      }
      line( pnts[j-1].x, pnts[j-1].y, pnts[0].x, pnts[0].y );
  }
*/
}
