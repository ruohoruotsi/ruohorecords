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


final int canvasWidth = 800;
final int canvasHeight = 800;
RPolygon rpoly;

void setup() {
  
  smooth();
  size(canvasWidth, canvasHeight, P2D);

  ////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);

  RShape shp2 = new RShape();

  shp2.addMoveTo( 0 , 0  );
  shp2.addLineTo( 185 , 0  );
  shp2.addLineTo( 213 , 0 );
  shp2.addLineTo( 249 , 2 );
  shp2.addBezierTo( 267 , 4 , 281 , 9 , 292 , 17);
  shp2.addBezierTo(  303 , 24 , 309 , 33 , 309 , 43);
  shp2.addBezierTo(  309 , 63 , 287 , 75 , 243 , 80);
  
  shp2.addLineTo( 300 , 130  );
  shp2.addLineTo( 337 , 152 );

  shp2.addLineTo( 191 , 152  );
  shp2.addLineTo( 0 , 152  );
  shp2.addLineTo( 0 , 0 );
  shp2.addClose();
  
  rpoly = (RPolygon)(shp2.toPolygon());
  
  colorMode( HSB );
}


void draw() {
  
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

}
