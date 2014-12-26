/*
//////////////////////////////////////////////
--------- generative logotypography ----------
//////////////////////////////////////////////
Title   :   sketch_logo
Date    :   12/23/2014 
Version :   v0.5

 */
//////////////////////////////////////////////
import geomerative.*;


final int canvasWidth = 600;
final int canvasHeight = 600;

RShape circle;
RShape rectangle;
RShape triangle;

void setup() {
  
  smooth(8);
  //size(800, 800, P2D);
  size(canvasWidth, canvasHeight, P2D);

  ellipseMode(CENTER);
  ellipse(width/2, height/2, width, height);
  


  ////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);
  
  // noStroke();
  // strokeWeight(2);

  int circleWidth = canvasWidth * 8/10;
  
  rectangle = RShape.createRectangle(0, 0, circleWidth/2, canvasHeight);
  //rectangle.draw();

  circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth , circleWidth);
  //circle.draw();
 
  triangle = new RShape();
  triangle.addLineTo(circleWidth, canvasHeight);
  triangle.addLineTo(0, canvasHeight);
  // triangle.draw();
  
  // 
  strokeWeight(5);
  RShape diff = circle.union(rectangle).union(triangle);
  //fill();
  diff.translate(60, 0);
  diff.draw();   
  
  
  System.out.println(circleWidth);
  
  ////////////////////////////////////////////
  // draw Guides
  
  strokeWeight(2);
  // ellipseMode(CENTER);
  // ellipse(canvasWidth/2, canvasHeight/2, canvasWidth/4, canvasHeight/4);
  
  line(width/2, 0, width/2, height);  // vertical guide
  line(0, height/2, width, height/2); // horizontal guide
  
  // end draw Guides
  ////////////////////////////////////////////
  
}


void draw() {
  /*
  // draw Guides
  strokeWeight(1);
  ellipseMode(CENTER);
  ellipse(canvasWidth/2, canvasHeight/2, canvasWidth/4, canvasHeight/4);
  
  line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
  line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
  // end draw Guides

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
