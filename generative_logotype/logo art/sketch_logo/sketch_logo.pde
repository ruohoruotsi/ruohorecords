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
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.processing.*;

// Globals
final int canvasWidth = 700;
final int canvasHeight = 700;

RShape circumscribingCircle;
RLogotype rrlogo;

// Control
Boolean down = true;

// frame params
int[] list;
int count = 0;
int distance;
ArrayList<Particle> particles;
PVector axis;
int[] strokeRGBA;

// toxiclibs voronoi params
// radius of the root triangle which encompasses (MUST) all other points
float DSIZE = 10000;
// a Voronoi diagram relies on a Delaunay triangulation behind the scenes
// we simply use this as a front end
Voronoi voronoi;
ToxiclibsSupport gfx;
// render switch
boolean doIgnoreRoot = true;
pt[] P = new pt [2048];

void setup() {
  
  // size(canvasWidth, canvasHeight, P2D);
  size(700, 700, P2D);

  smooth(8);
  frameRate(3);

  ////////////////////////////////////////////////////////////////////////////////////////
  // initialize the Geomerative library
  RG.init(this);

  rrlogo = new RLogotype(400, 500);

  //rrlogo.setupShortFatR();
  rrlogo.setupRC();
  
  // uncomment, for frame example
  // rrlogo.setupFrame();

  // saveFrame("grab.png");
  
  
  // Voronoi
  voronoi = new Voronoi(DSIZE);
  gfx = new ToxiclibsSupport(this);

  // rrlogo.drawDelaunayTriangulation();
  // rrlogo.drawToxiclibsVoronoi();
}


void draw() 
{
 // background(255);
 //fill(196, 0, 7);

 ////////////////////////////////////////////////////////////////////////////////////////
 // draw Guid es
 //strokeWeight(2);
 //line(canvasWidth/2, 0, canvasWidth/2, canvasHeight);  // vertical guide
 //line(0, canvasHeight/2, canvasWidth, canvasHeight/2); // horizontal guide
 // end draw Guides
 ////////////////////////////////////////////////////////////////////////////////////////

 // rrlogo.draw();
 // rrlogo.drawBlackLines();
 // rrlogo.drawRedMesh();
 // rrlogo.drawDottedOutline();
 
 rrlogo.drawDelaunayTriangulation();
 // rrlogo.drawToxiclibsVoronoi();

 // rrlogo.drawFrame();
}



class RLogotype {

  // Component Shapes
  RShape circle;
  RShape rectangle;
  RShape triangle;
  RShape diff;

  int upperLeftX = 0;
  int lowerRight = 0;  
  int letterWidth = 0;
  int letterHeight = 0;

  // Constructor 
  RLogotype(int width, int height) {
    letterWidth = width;
    letterHeight = height;
  }

  void setupShortFatR() {

    // Union shapes
    int circleWidth = letterWidth * 7 / 10;
    int rectangleWidth = letterWidth * 5 / 10;

    rectangle = RShape.createRectangle(0, 0, rectangleWidth, rectangleWidth); 
    circle = RShape.createEllipse(rectangleWidth, circleWidth/2, circleWidth, circleWidth);

    triangle = new RShape();
    int triangleDim = circleWidth + 50;
    triangle.addLineTo(triangleDim / 2, 0);
    triangle.addLineTo(triangleDim, triangleDim);
    triangle.addLineTo(0, triangleDim);

    // Diff
    diff = triangle.union(circle).union(rectangle);
    //diff = rectangle.union(circle);
    //diff = triangle.union(rectangle);  
    //diff = triangle;
    //  diff = circle;
    
    int translateWidth = letterWidth / 2;
    int translateHeight =  letterWidth / 2; 

    diff.translate(translateWidth, translateHeight);

    // Compute and store important points in the shape
    upperLeftX  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    lowerRight = circleWidth + (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    
    // System.out.println("UR:" + lowerRight);
  }

  void setupRC() {

    // Union shapes
    int circleWidth = letterWidth;
    rectangle = RShape.createRectangle(0, 0, circleWidth/2, circleWidth); 
    circle = RShape.createEllipse(circleWidth/2, circleWidth/2, circleWidth , circleWidth);
   
    triangle = new RShape();
    triangle.addLineTo(circleWidth, letterHeight);
    triangle.addLineTo(0, letterHeight);
    
    // Diff
    diff = triangle.union(circle).union(rectangle);
  
    // Translate to center
    int translateWidth = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    int translateHeight = (canvasHeight - letterHeight)/2;
    diff.translate(translateWidth, translateHeight);
    
    // Compute and store important points in the shape
    upperLeftX  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    lowerRight = circleWidth + (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;
    //lowerLeftY  = (letterWidth - circleWidth)/2 + (canvasWidth - letterWidth)/2;

    System.out.println("UR:" + lowerRight);
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  void geomerativeStaticSegmentation(int segLen) {

    // tell geomerative how to convert the outline
    RCommand.setSegmentLength(segLen);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  }

  void geomerativeVariableSegmentation(int maxFrames, int multiplier) {

    // tell geomerative how to convert the outline

    // V1 variable segments/dots around the outline
    // RCommand.setSegmentLength(frameCount % 50);

    // V2 variable segments/dots around the outline
    int seglenA = frameCount % maxFrames;
    if (seglenA == 0) down = !down;  
    if (down) {
      RCommand.setSegmentLength(seglenA * multiplier);
    } else {   
      RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
    }

    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    System.out.println(seglenA);
  }  


  void drawPointCircles() {
    RPoint[] pnts = diff.getPoints();
    ellipse(pnts[0].x, pnts[0].y, 5, 5);
    for ( int i = 1; i < pnts.length; i++ )
    {    
      line( pnts[i-1].x, pnts[i-1].y, pnts[i].x, pnts[i].y );
      ellipse(pnts[i].x, pnts[i].y, 5, 5);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  void testNewSegmentation(int maxFrames, int multiplier) {

    // V1 variable segments/dots around the outline
    // RCommand.setSegmentLength(frameCount % 50);

    // V2 variable segments/dots around the outline
    int seglenA = frameCount % maxFrames;
    print("seglenA: " + seglenA);
    
    if (seglenA == 0) down = !down;  
    if (down) {
      print("   down: " + down);
      RCommand.setSegmentLength(seglenA * multiplier);
    } else { 
      print(" not down: " + !down);
      RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
    }

    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    println("");
  }  

  void draw(){
    
    background(255);
    testNewSegmentation(10, 50);

    fill(222, 222, 222);
    rrlogo.diff.draw();  

    // Draw individual circles at each segment break

    RPoint[] pnts = diff.getPoints();
    ellipse(pnts[0].x, pnts[0].y, 5, 5);
    int k = 1;
    for ( int i = k; i < pnts.length; i++ )
    {    
      line( pnts[i-k].x, pnts[i-k].y, pnts[i].x, pnts[i].y );
      ellipse(pnts[i].x, pnts[i].y, 5, 5);
    } 

    /// Excellent starter
    RPoint[] myPoints = diff.getPoints();
    int startx = (canvasWidth)/2; 
    int upperLeftY = (canvasHeight - letterHeight)/2;
    
    beginShape();
    for (int i = 0; i < myPoints.length; i++) {

      float jitter = random(0, 30);

      // starting point OMG!!
      //line(myPoints[i].x, myPoints[i].y, 10, 10);
      if (myPoints[i].x == lowerRight) {
        fill(156, 0, 7);
        ellipse(myPoints[i].x, myPoints[i].y, 3, 3);
      }
      line(myPoints[i].x, myPoints[i].y, upperLeftX, upperLeftY);
      line(myPoints[i].x, myPoints[i].y, upperLeftX, upperLeftY);

      //vertex(myPoints[i].x, myPoints[i].y); // Play with adding or subtracting jitter
      //vertex(myPoints[i].x+jitter, myPoints[i].y+jitter);
      //vertex(myPoints[i].x-jitter, myPoints[i].y-jitter);

      //line(myPoints[i].x, myPoints[i].y,30,-280);
      //line(myPoints[i].x, myPoints[i].y,20,myPoints[i].y);
      //ellipse(myPoints[i].x + 10, myPoints[i].y, 3, 3);
    }
    endShape();
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  void drawBlackLines() {

    // geomerativeVariableSegmentation(60, 1);
    geomerativeStaticSegmentation(25); // iohavoc temporary debugging
    drawPointCircles();

    /// Excellent starter
    RPoint[] myPoints = diff.getPoints();
    int startx = (canvasWidth)/2; 
    int starty = (canvasHeight - letterHeight)/2;
    beginShape();
    for (int i = 0; i < myPoints.length; i++) {

      float jitter = random(0, 30);

      /* io havoc debugging
       // starting point OMG!! <-- focus of shadows and innerlines
       // line(myPoints[i].x, myPoints[i].y, 10, 10);
       if(myPoints[i].x == lowerRight) {
       // fill(156, 0, 7);
       ellipse(myPoints[i].x, myPoints[i].y,2,2);
       }
       line(myPoints[i].x, myPoints[i].y, upperLeft, starty);
       */

      vertex(myPoints[i].x, myPoints[i].y);//PLAY WITH ADDING OR SUBSTRACTING JITTER
      vertex(myPoints[i].x+jitter, myPoints[i].y+jitter);
      vertex(myPoints[i].x-jitter, myPoints[i].y-jitter);

      //      line(myPoints[i].x, myPoints[i].y,30,-280);
      //      line(myPoints[i].x, myPoints[i].y,20,myPoints[i].y);
      //      ellipse(myPoints[i].x+10,myPoints[i].y,3,3);
    }
    endShape();
  }

  void drawRedMesh() {

    geomerativeVariableSegmentation(60, 1);

    /* IO HAVOC -- add red mesh */
    RMesh mesh = diff.toMesh();
    for ( int i = 0; i < mesh.strips.length; i++ ) {
      RPoint[] pnts = mesh.strips[i].getPoints();

      beginShape(TRIANGLE_STRIP);
      for ( int ii = 0; ii < pnts.length; ii++ ) {
        vertex( pnts[ii].x, pnts[ii].y );
      }
      endShape();
    }
  }

  void drawDottedOutline() {

    geomerativeStaticSegmentation(25);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  
  void drawToxiclibsVoronoi() {

    geomerativeStaticSegmentation(20);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
      
      // add points from around the logo
      //voronoi.addPoint(new Vec2D(curPoint.x, curPoint.y));
    }
    
      background(255);
      
      fill(222, 222, 222);
      rrlogo.diff.draw();  
     

      stroke(0);
      noFill();
      stroke(0, 0, 255, 50);
    
      beginShape(TRIANGLES);
      // get the delaunay triangles
      for (Triangle2D t : voronoi.getTriangles()) {
        // ignore any triangles which share a vertex with the initial root triangle
        if (!doIgnoreRoot || (abs(t.a.x)!=DSIZE && abs(t.a.y)!=DSIZE)) {
          gfx.triangle(t, false);
        }
      }
      endShape();
    
      fill(255, 0, 255);
      noStroke();
      for (Vec2D c : voronoi.getSites()) {
        ellipse(c.x, c.y, 5, 5);
      }
           

  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////
   void testDelaunaySegmentation(int maxFrames, int multiplier) {

    // V1 variable segments/dots around the outline
    // RCommand.setSegmentLength(frameCount % 50);

    // V2 variable segments/dots around the outline
    int seglenA = 12 + (frameCount % maxFrames);
    print("seglenA: " + seglenA);
    
    if (seglenA == 13) down = !down;  
    if (down) {
     print("   down: " + down);
     RCommand.setSegmentLength(seglenA * multiplier);
    } else { 
     print(" not down: " + !down);
     RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
    }

    //RCommand.setSegmentLength(seglenA);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    println(" ");
  } 
  
  void drawDelaunayTriangulation() {

    background(255);
    testDelaunaySegmentation(30, 10);

    // turn the RShape into an RPolygon
    RPolygon wavePolygon = rrlogo.diff.toPolygon();

    // we have just 1 RContour in the RPolygon because we had one RPath in the RShape
    // otherwise you need to loop through the polygon contours like shown in typography/font_to_points_dots
    //pt[] P = new pt [wavePolygon.contours[0].points.length];
    for (int i = 0; i < wavePolygon.contours[0].points.length; i++)
    {
      RPoint curPoint = wavePolygon.contours[0].points[i];
      ellipse(curPoint.x, curPoint.y, 5, 5);
      
      
      ///// IOHAVOC populate P[i] autrement ...same storage 
      P[i] = new pt(curPoint.x, curPoint.y);
    }
    
      fill(255);
      rrlogo.diff.draw();  
      noFill();
    
      println("wavePolygon.contours[0].points.length: " + wavePolygon.contours[0].points.length);

      drawTriangles(wavePolygon.contours[0].points.length, P);
  }
  
  //*********************************************
  // **** COMPUTES AND DRAWS DELAUNAY TRIANGLES
  //*********************************************
  color red = color(200, 10, 10); color blue = color(10, 10, 200); color green = color(0, 150, 0); 
  boolean dots = true;           // toggles display circle centers
  boolean numbers = true;         // toggles display of vertex numbers 

  void drawTriangles(int vn, pt[] P) { 
     
    pt X = new pt(0,0);
    float r = 1;
     
    for (int i = 0; i < vn-2; i++) {
      for (int j = i+1; j < vn-1; j++) {
        for (int k = j+1; k < vn; k++) {
          boolean found = false; 
       
          for (int m=0; m<vn; m++) {
             X = centerCC (P[i], P[j], P[k]);  
             r = X.disTo(P[i]);
             if ((m!=i) && (m!=j) && (m!=k) && (X.disTo(P[m])<=r)) {
             found = true;
           }
         };
         
       if (!found) {
           strokeWeight(1); 
           
           if(X.x > 500) {
             //stroke(red); ellipse(X.x, X.y, 2*r, 2*r); 
             continue;
           } else {
             stroke(green); ellipse(X.x, X.y, 2*r, 2*r); 
           }
           
           
           if(rrlogo.diff.contains(X.x, X.y)){
            
             //print("Contains");
           }
           else {
              //println("Xxxxxxxxxxxxxxx");
              //println("( " + X.x + "," + X.y + ")");
              continue;
           }
           
           if (dots) {
            stroke(blue); X.show(2); 
           };
           strokeWeight(2); stroke(red); 
           
           beginShape(POLYGON);  
           P[i].vert(); P[j].vert(); P[k].vert(); 
           endShape(); 
         };
        }; }; }; // end triple loop
     };  
     
     
  //*********************************************
  // **** COMPUTE CIRCUMCENTER
  //*********************************************
  pt centerCC (pt A, pt B, pt C) {    // computes the center of a circumscirbing circle to triangle (A,B,C)
    vec AB =  A.vecTo(B);  float ab2 = dot(AB,AB);
    vec AC =  A.vecTo(C); AC.left();  float ac2 = dot(AC,AC);
    float d = 2*dot(AB,AC);
    AB.left();
    AB.back(); AB.mul(ac2);
    AC.mul(ab2);
    AB.add(AC);
    AB.div(d);
    pt X =  A.makeCopy();
    X.addVec(AB);
    return(X);
    };
  
  ////////////////////////////////////////////////////////////////////////////////////////
  
  void setupFrame() {
   
    rrlogo.diff.setFill(0);
    rrlogo.diff.draw();
    
    distance = 10;
    particles = new ArrayList<Particle>();
    list = new int[width*height];
  
    loadPixels();
    for(int y = 0; y <= height-1; y++) {
    
      for(int x = 0; x <= width-1; x++) {
    
        color pb = pixels[y*width + x];
        //System.out.println("pb = :" + pb + " " + red(pb));
      
        // create a MASK of 0s and 1s
        if(red(pb) < 5) {  // Foreground
          list[y*width+x] = 0;  
          //System.out.println("list index == 0" + " " + y + " " + x + " " + red(pb));

      } else {  
          list[y*width+x] = 1;  // Background red(pb) == 255, as in background(255,250,245);
          //System.out.println("list index == 1" + " " + y + " " + x + " " + red(pb));
        }
      }
    }
  }
  
  void drawFrame() {
    
    // constants
    int max = 3000;
    int randVal = 100;
    
    if(count < max){
      int i = 0;
      
      while(i < 3) {  
        axis = new PVector(int(random(randVal, width-randVal)),int(random(randVal, height-randVal)));
        
        // list[index] == 0 means that it was in the "mask"
        if(list[int(axis.y*width + axis.x)] == 0 && 
           list[int(axis.y*width + axis.x+1)] == 0 && 
           list[int(axis.y*width + axis.x-1)] == 0 && 
           list[int((axis.y+1)*width + axis.x)] == 0 && 
           list[int((axis.y+1)*width + axis.x)] == 0) {
             
            particles.add(new Particle(axis.x,axis.y));
            i++;
            count++;
       }
      }
    }
          
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.update();
      
      for(int j = i+1; j < particles.size(); j++){
        Particle pp = particles.get(j);
        
        if (dist(p.location.x , p.location.y , pp.location.x , pp.location.y) < distance) {
          // stroke colour ROJO
          //stroke(int(random(150, 255)), int(random(0, 50)), int(random(0, 50)));
          line(p.location.x , p.location.y , pp.location.x , pp.location.y);
        }
      }
    } 
    
  }
  
 ////////////////////////////////////////////////////////////////////////////////////////
 
 
}

void mousePressed() {
  voronoi.addPoint(new Vec2D(mouseX, mouseY));
}

class Particle {
  
  PVector location;
  PVector velocity;

  Particle(float x, float y) {
    location = new PVector(x,y);
    velocity = new PVector(random(1),1);
  }
  
  void update() {
    location.add(velocity);
    if ((list[int(location.y)*width+int(location.x+velocity.x)]==1)   ||   (list[int(location.y)*width+int(location.x-velocity.x)]==1)) {  velocity.x *= -1;  }
    if ((list[int(location.y+velocity.y)*width+int(location.x)]==1) || (list[int(location.y-velocity.y)*width+int(location.x)]==1)) {  velocity.y *= -1;  }
  }
}