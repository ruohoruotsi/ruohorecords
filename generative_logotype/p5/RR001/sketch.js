
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
var sq_dim = 60; // 20-60?
var canvasSize_w = 800 * multiplier;  // 1080p at retina // 1920×1080 
var canvasSize_h = 800 * multiplier;  // 1080p at retina // 1920×1080 

var celln1 = 4;
var cells1 = [];

var DEBUG = false;  // control debug logging and diagnostic lines
var margin = sq_dim/18;

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

  noFill();
  if (DEBUG) {
    noLoop();
  }
}


function draw() {

  // clear background on each frame
  background(255, 255, 255);      // <=== white background
  clear();                        // <=== transparent background

  // draw one here
  pos1_w = (canvasSize_w - sq_dim) / 2 ;
  pos_h = (canvasSize_h - sq_dim) / 2;
  // drawOne(cells1, celln1, 0, 0);   // coordinates are offsets for R

  drawOne(cells1, celln1, random(0,100), random(0,100));   // coordinates are offsets for R
  drawOne(cells1, celln1, random(100,200), random(100,200));   // coordinates are offsets for R
}

function ligneAvec(strokeWeight_thickness, lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b ) {
  strokeWeight(strokeWeight_thickness);
  stroke(lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b);
}

function drawOne(cells, celln, translateX, translateY){

  push(); // Start a new drawing state

  translate(translateX, translateY);  
  ligneAvec(1, 0, 0, 0); // for letter background set stroke style

  // Draw circumscribing-square
  fill(255);
  rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  
  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display();
    }

  fill(255); // white

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 3 (bottom rect)
  rect3_height = random(sq_dim/15, (sq_dim/10)*3);
  rect3_width = random(sq_dim/10, sq_dim - (2*margin));  // max is sq_dim - some margin

  ligneAvec(1, 0, 0, 0);
  rect((sq_dim - rect3_width)/2, sq_dim - rect3_height, rect3_width, rect3_height);

  rect1_low_range = 10;
  rect1_high_range = sq_dim - rect3_height - margin;
  // Randomly select a bounding RED line for rect1
  // Use rect3's top + a margin as the range to select in
  // rect1_lower_bound_y = random(80, sq_dim - rect3_height - margin);
  rect1_lower_bound_y = random(rect1_low_range, rect1_high_range);
  
  // Vertical line connecting R lines
  ligneAvec(1, 0, 0, 0);
  line((sq_dim - rect3_width)/2, sq_dim, (sq_dim - rect3_width)/2, rect1_lower_bound_y);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 1 (left top/rect2)
  rect1_yoffset_from_top = 0;
  do {
    rect1_yoffset_from_top = random(margin, rect1_lower_bound_y);
  } while (rect1_lower_bound_y - rect1_yoffset_from_top < margin);

  rect1_width = random((sq_dim - rect3_width)/2, sq_dim - (2*margin));

  rect1_height = rect1_lower_bound_y - rect1_yoffset_from_top
  rect1_x_start = 0;
  do {
    rect1_x_start = random(margin, (sq_dim - rect3_width)/2);
    sum = rect1_width + rect1_x_start;
  } while (sum + margin > sq_dim);

  console.log("rect1_height: " + rect1_height);

  ligneAvec(1, 0, 0, 0);
  rect(rect1_x_start, rect1_yoffset_from_top, rect1_width, rect1_height);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 2 (right rect1/rect3) # 200 needs to be anchored to whatever rect1 is doing
  rect2_x_start = random((sq_dim - rect3_width)/2 + margin, sq_dim - margin);
  // rect2_y_start = random(rect1_lower_bound_y, sq_dim - rect3_height);
  rect2_y_start = rect1_lower_bound_y + margin;

  // fills out the rest of the x dimension (sq_dim), anchoring rect2 to right side
  rect2_width = sq_dim - rect2_x_start;  
  // rect2_height = random(sq_dim - rect1_lower_bound_y, sq_dim - rect1_high_range);
  rect2_height = rect1_high_range - rect1_lower_bound_y - margin;

  if (rect2_height < margin){
    console.log("[SIZE ERROR] heads up broken");
    // console.log(rect2_y_start + rect2_height + margin);
    console.log(rect1_high_range);
    console.log(rect2_height);

  } else {

  ligneAvec(1, 0, 0, 0);
  rect(rect2_x_start, rect2_y_start, rect2_width, rect2_height);
  noFill();
  }

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