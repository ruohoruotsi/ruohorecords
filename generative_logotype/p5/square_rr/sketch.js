
/**
 * sketch.js
 *
 * p5.js: http://p5js.org/reference
 *
 * @author : ruoho ruotsi
 */


// -----------------------------------------------------------------
// setup
// -----------------------------------------------------------------
var multiplier = 1;
var cir_dim = 600 * multiplier;
var sq_dim = 450 * multiplier;
var offset = 100 * multiplier;
// var canvasSize = 500 * multiplier;
var canvasSize = 600 * multiplier;  // for twitter

var celln = 6;
var cells = [];

function setup() {
  createCanvas(canvasSize+offset, canvasSize+offset);
  frameRate(0.5); // Attempt to refresh at starting FPS
  stroke(255);

  // setup cell grid
  for (var i = 0; i < celln; i++) {
      cells[i] = [];
      for (var j = 0; j < celln; j++) {
          cells[i][j] = new Cell(i*(sq_dim/celln), j*(sq_dim/celln), sq_dim/celln, 0);
          cells[i][j].rand();
      }
  }

  noFill();
  noLoop() 
}


function draw() {

  // clear background on each frame
  background(255);

  // bg cell grid color
  stroke(99,40,37);
  strokeWeight(7);

  // guide rects, circles
  // rect(0, 0, cir_dim, cir_dim); // outer, circumscribing rect
  // ellipse((canvasSize+offset)/2, (canvasSize+offset)/2, canvasSize+offset, canvasSize+offset);

  // offset to middle of canvas
  // translate(offset*(sq_dim/cir_dim), offset*(sq_dim/cir_dim));
  translate(125, 125);  // twitter

  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display();
    }


  print("mouseX: " + mouseX, mouseY)
  
  // main shape stroke color & weight
  stroke(0);
  strokeWeight(24);
  rect(0, 0, sq_dim, sq_dim); // better rect


  //////////////////////////////////////////////////////////////////////////////////
  // rect 3 (bottom rect2)
  rect3_top_bound_y = sq_dim - 150; // random(sq_dim - 200, sq_dim);
  rect3_height = random(20,100);
  rect3_width = random(60,300);
  fill(255);
  rect((sq_dim - rect3_width)/2, sq_dim - rect3_height, rect3_width, rect3_height);


  //////////////////////////////////////////////////////////////////////////////////
  // rect 1 (left top/rect2)
  // randomly select a bounding line for rect1
  rect1_lower_bound_y = random(80, 300)
  rect1_offset_from_top = random(0, rect1_lower_bound_y - 40);
  // line(0, rect1_lower_bound_y, sq_dim, rect1_lower_bound_y); // horizontal line
  line((sq_dim - rect3_width)/2, sq_dim, (sq_dim - rect3_width)/2, rect1_lower_bound_y);
  
  rect1_width = random((sq_dim - rect3_width)/2, sq_dim/2 + rect3_width);
  rect1_height = rect1_lower_bound_y - rect1_offset_from_top
  rect1_x_start = random(0,100);
  if (rect1_width + rect1_x_start > sq_dim){
      rect1_width = sq_dim - rect1_x_start;
  }
  rect(rect1_x_start, rect1_offset_from_top, rect1_width, rect1_height);
  // noFill();


  //////////////////////////////////////////////////////////////////////////////////
  // rect 2 (right rect1/rect3) # 200 needs to be anchored to whatever rect1 is doing
  var gap = 40
  rect2_x_start = random((sq_dim - rect3_width)/2 + gap, sq_dim - gap);
  rect2_y_start = random(rect1_lower_bound_y + gap/2, sq_dim - rect3_height - gap/2);
  
  // fills out the rest of the x dimension (sq_dim), anchoring rect2 to right side
  rect2_width = sq_dim - rect2_x_start;  
  rect2_height = random(gap, sq_dim - rect3_height - rect2_y_start - gap);

  if (rect2_y_start + rect2_height + 15 > sq_dim - rect3_height){
    console.log("headup")
    console.log(rect2_y_start + rect2_height, sq_dim - rect3_height);
    rect2_height = random(gap/2, sq_dim - rect3_height - rect2_y_start - gap);

  }

  rect(rect2_x_start, rect2_y_start, rect2_width, rect2_height);
  noFill();

  console.log(rect2_y_start + rect2_height , sq_dim - rect3_height)
}


function mousePressed() {
  loop();
}

function mouseReleased() {
  noLoop();
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