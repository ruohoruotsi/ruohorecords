
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
var sq_dim = 450;
var canvasSize_w = 600 * multiplier;  // 1080p at retina // 1920×1080 
var canvasSize_h = 600 * multiplier;  // 1080p at retina // 1920×1080 

var celln1 = 16;
var cells1 = [];

// var celln2 = 13;
// var cells2 = [];

var DEBUG = false;  // control debug logging and diagnostic lines
var margin = 40;

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

  // // setup cell grid2
  // for (var i = 0; i < celln2; i++) {
  //     cells2[i] = [];
  //     for (var j = 0; j < celln2; j++) {
  //         cells2[i][j] = new Cell(i*(sq_dim/celln2), j*(sq_dim/celln2), sq_dim/celln2, 0);
  //         cells2[i][j].rand();
  //     }
  // }

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
  drawOne(cells1, celln1, pos1_w, pos_h);   // coordinates are offsets for R
  // drawOne(cells2, celln2, pos2_w, pos_h);    

  // console.log(rect2_y_start + rect2_height , sq_dim - rect3_height)
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
  

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 3 (bottom rect)
  rect3_height = random(35, 100);
  rect3_width = random(45, sq_dim - (2*margin));  // max is sq_dim - some margin

  ligneAvec(14, 0, 0, 0);
  rect((sq_dim - rect3_width)/2, sq_dim - rect3_height, rect3_width, rect3_height);
  if (DEBUG) {
    console.log("rect3_width: " + rect3_width);
    console.log("rect3_height: " + rect3_height);
  }

  rect1_low_range = 80;
  rect1_high_range = sq_dim - rect3_height - margin;
  // Randomly select a bounding RED line for rect1
  // Use rect3's top + a margin as the range to select in
  // rect1_lower_bound_y = random(80, sq_dim - rect3_height - margin);
  rect1_lower_bound_y = random(rect1_low_range, rect1_high_range);

  if (DEBUG) {
    tmp = sq_dim - rect3_height; 
    console.log("rect1_lower_bound_y: " + rect1_lower_bound_y);
    console.log("sq_dim - rect3_height: " + tmp);

    ligneAvec(10, 155, 0, 0);
    line(0, rect1_lower_bound_y, sq_dim, rect1_lower_bound_y); // RED horizontal line
    
    ligneAvec(10, 155, 60, 60);
    line(0, rect1_low_range, sq_dim, rect1_low_range);    // Pink horizontal line
    ligneAvec(10, 55, 60, 60);
    line(0, rect1_high_range, sq_dim, rect1_high_range);  // Grey horizontal line
  }
  
  // Vertical line connecting R lines
  ligneAvec(14, 0, 0, 0);
  line((sq_dim - rect3_width)/2, sq_dim, (sq_dim - rect3_width)/2, rect1_lower_bound_y);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 1 (left top/rect2)
  rect1_yoffset_from_top = 0;
  do {
    rect1_yoffset_from_top = random(margin, rect1_lower_bound_y);
  } while (rect1_lower_bound_y - rect1_yoffset_from_top < margin);

  rect1_width = random((sq_dim - rect3_width)/2, sq_dim - (2*margin));

  if (DEBUG) {
    console.log("[INFO] rect1_yoffset_from_top: " + rect1_yoffset_from_top);
    console.log("[INFO] rect1_lower_bound_y: " + rect1_lower_bound_y);
    console.log("[INFO] rect1_width: " + rect1_width);
  }

  rect1_height = rect1_lower_bound_y - rect1_yoffset_from_top
  rect1_x_start = 0;
  do {
    rect1_x_start = random(margin, (sq_dim - rect3_width)/2);
    sum = rect1_width + rect1_x_start;

    // console.log("==> adjusted rect1_x_start: " + rect1_x_start);
    // console.log("==> rect1_width + rect1_x_start: " + rect1_width + " " + rect1_x_start);
    // console.log("===> rect1_width + rect1_x_start: " + sum )
  } while (sum + margin > sq_dim);

  console.log("rect1_height: " + rect1_height);

  ligneAvec(14, 0, 0, 0);
  rect(rect1_x_start, rect1_yoffset_from_top, rect1_width, rect1_height);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 2 (right rect1/rect3) # 200 needs to be anchored to whatever rect1 is doing
  rect2_x_start = random((sq_dim - rect3_width)/2 + margin, sq_dim - margin);
  // rect2_y_start = random(rect1_lower_bound_y, sq_dim - rect3_height);
  rect2_y_start = rect1_lower_bound_y + margin;

  if (DEBUG) {
    console.log("[INFO] rect2_x_start: " + rect2_x_start );
    console.log("[INFO] rect2_y_start: " + rect2_y_start );

    ligneAvec(10, 55, 60, 120);
    line(rect2_x_start, sq_dim, rect2_x_start, 0);  // Blue vertical line

    ligneAvec(10, 15, 6, 180);
    line(0, rect2_y_start, sq_dim, rect2_y_start);  // Blue horizontal line
  }

  // fills out the rest of the x dimension (sq_dim), anchoring rect2 to right side
  rect2_width = sq_dim - rect2_x_start;  
  // rect2_height = random(sq_dim - rect1_lower_bound_y, sq_dim - rect1_high_range);
  rect2_height = rect1_high_range - rect1_lower_bound_y - margin;

  if (DEBUG) {
    console.log("[INFO] rect2_width: " + rect2_width);
    console.log("[INFO] rect2_height: " + rect2_height);
  }


  if (rect2_height < margin){
    console.log("[SIZE ERROR] heads up broken");
    console.log(rect2_y_start + rect2_height + margin);
    console.log(rect1_high_range);

  } else {

  ligneAvec(14, 0, 0, 0);
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