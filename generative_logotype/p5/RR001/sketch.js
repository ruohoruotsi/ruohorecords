
/**
 * sketch.js
 *
 * p5.js: http://p5js.org/reference
 *
 * @author : ruoho ruotsi RR001
 */


// -----------------------------------------------------------------
// setup
// -----------------------------------------------------------------
var multiplier = 1;
var sq_dim = 800;
var canvasSize_w = 800 * multiplier;  // 1080p at retina // 1920×1080 
var canvasSize_h = 800 * multiplier;  // 1080p at retina // 1920×1080 

var celln1 = 20;
var cells1 = [];

// var celln2 = 13;
// var cells2 = [];

var DEBUG = false;  // control debug logging and diagnostic lines
var margin = 40;


function preload() {
  // font = loadFont('assets/Jangotype.ttf');
  font = loadFont('assets/bombfact.ttf');

}

function setup() {
  createCanvas(canvasSize_w, canvasSize_h);
  frameRate(1); // Attempt to refresh at starting FPS // 0.5

  // setup cell grid1
  for (var i = 0; i < celln1; i++) {
      cells1[i] = [];
      for (var j = 0; j < celln1; j++) {
          cells1[i][j] = new Cell(i*(sq_dim/celln1), j*(sq_dim/celln1), sq_dim/celln1, 0);
          cells1[i][j].rand();
      }
  }

  textFont(font);
  textSize(80);
  textAlign(CENTER, CENTER);

  noFill();
  if (DEBUG) {
    noLoop();
  }
}


function draw() {

  // clear background on each frame
  background(255, 255, 255);      // <=== white background
  clear();                        // <=== transparent background

  // bg cell grid color
  stroke(99, 40, 37);

  // draw one here
  pos1_w = (canvasSize_w - sq_dim) / 2 ;
  pos_h = (canvasSize_h - sq_dim) / 2;
  drawOne(cells1, celln1, 0, 0);   // coordinates are offsets for R

  stroke(0);
  fill(255);
  strokeWeight(20);
  // text('A-G \nVOL. 1', canvasSize_w/2, canvasSize_h/2);
  // text('AMUSE \nGUEULES \nVOL. 1', canvasSize_w/2, canvasSize_h/2);
  text('Amuse \nGueules \nVol. 1', canvasSize_w/2, canvasSize_h/2);

  // stroke(255);
  // fill(0);
  // strokeWeight(5);
  // text('A-G \nVOL. 1', canvasSize_w/2, canvasSize_h/2);

}

function ligneAvec(strokeWeight_thickness, lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b ) {
  strokeWeight(strokeWeight_thickness);
  stroke(lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b);
}

function drawOne(cells, celln, translateX, translateY){

  push(); // Start a new drawing state

  translate(translateX, translateY);

  // draw the main shape first so the background for the grid isn't drawing transparent
  // main shape stroke color & weight
  ligneAvec(18, 0, 0, 0);

  // Draw circumscribing-square
  fill(255);                  // white
  rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  noFill();


  // for letter background set stroke style
  // ligneAvec(7, 99, 40, 37);
  ligneAvec(7, 0, 0, 0);

  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display();
    }

  // // redraw rect shape, so the background lines don't show. Ugh
  ligneAvec(18, 0, 0, 0);

  // Draw circumscribing-square
  rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  fill(255);                  // white

  print("mouseX: " + mouseX, mouseY)
  

  pop(); // Restore original state
}


function mousePressed() {
  if (DEBUG) {
    loop();
  }
}

function mouseReleased() {
  if (DEBUG) {
    noLoop();
  }
}

function keyPressed() {
  if (key == 's' || key == 'S') 
    saveCanvas(Math.round(new Date().getTime() / 1000).toString(), 'png');
}


// -----------------------------------------------------------------
// Cell class for background patterning
// -----------------------------------------------------------------

class Cell {

  // float x, y, s, pos = 0, speed = 1.5;
  // int m = 2, type; // 0-empty
  // boolean moving = false;

  constructor(inx, iny, ins, intp) {
    this.x = inx; 
    this.y = iny;
    this.s = ins;
    this.type = intp;
    this.moving = false;
    this.m = 2;
    this.pos = 0;
    this.speed = 1.5;
  }

  rand() {
    this.type = ceil(random(2));
  }

  display() {
    if (this.moving) this.pos += this.speed;

    if (this.pos > this.s) {
      this.pos = 0;
      this.moving = false;
    }

    switch(this.type) {
    case 0: 
      break;

    case 1: 
      line(this.x, this.y, this.x+this.s, this.y+this.s);
      line(this.x+this.s/2, this.y, this.x+this.s, this.y+this.s/2);
      line(this.x, this.y+this.s/2, this.x+this.s/2, this.y+this.s);
      //break;

    case 2: 
      line(this.x+this.s, this.y, this.x, this.y+this.s);
      line(this.x+this.s/2, this.y, this.x, this.y+this.s/2);
      line(this.x+this.s/2, this.y+this.s, this.x+this.s, this.y+this.s/2);
      break;
    }
  }
}