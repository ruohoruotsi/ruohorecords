/**
 * sketch.js
 *
 * p5.js: http://p5js.org/reference
 *
 * @author : ruoho ruotsi
 */

// -----------------------------------------------------------------
// setup RR
// -----------------------------------------------------------------

var multiplier = 1;
// var sq_dim = 30; // 20-60?
var canvasSize_w = 1500;  // 1080p at retina // 1920×1080 
var canvasSize_h = 1500 * multiplier;  // 1080p at retina // 1920×1080 


var DEBUG = false;  // control debug logging and diagnostic lines

// -----------------------------------------------------------------
// let url = "https://coolors.co/ffffff-e8e8e8-e2e8e8-d7d9d9-bfbfc0";  // lighter
let url = "https://coolors.co/app/9e9e9e-adadad-bebebe-d1d1d1-e8e8e8"; // darker

let pallete;

let boardRadius = 10; //radius of hex grid
let size;             //size of hexes
let originHex;        // very center of the board
let hexes = [];
let mainLayout;
let graphics;


function setup() {

  createCanvas(canvasSize_w, canvasSize_h);
  colorMode(HSB, 360, 100, 100, 100);
  angleMode(DEGREES);
  size = Point(20, 20);
  mainLayout = hexLayout(pointyOrient, size);
  hexGenerateBoard(boardRadius, hexes, Hex(0, 0, 0));

  graphics = createGraphics(width, height);
  graphics.colorMode(HSB, 360, 100, 100, 100);
  graphics.noStroke();
  for (let i = 0; i < width * height * 25 / 100; i++) {
    let r = (1 - random(random(random()))) * sqrt(sq(width) + sq(height)) / 2;
    let angle = random(360);
    let x = width / 2 + cos(angle) * r;
    let y = height / 2 + sin(angle) * r;
    let w = random(3);
    let h = random(3);

    // Alpha controls dispersion of textural bg
    random(100) > 50 ? graphics.fill(0, 0, 100, 25) : graphics.fill(0, 0, 0, 35);
    graphics.ellipse(x, y, w, h);
  }

  // IOHAVOC
  pallete = createPallete(url);

  // fontItalic = loadFont('assets/Vokersololetras.ttf');
  // fontItalic = loadFont('assets/typeone.ttf');
  // fontItalic = loadFont('assets/Megafont.ttf');
  // fontItalic = loadFont('assets/Jangotype.ttf');
  // fontItalic = loadFont('assets/duro.ttf');
}


function draw() {
  background(0, 0, 95);
  image(graphics, 0, 0);


  //-------------------------------------------------------
  // border 
  let borderColour = color("#10060c");
  noFill();
  stroke(borderColour);
  strokeWeight(30);
  rect(0, 0, canvasSize_w, canvasSize_h); // sq_dim x sq_dim

  // top border
  fill(borderColour);
  stroke(borderColour);
  strokeWeight(1);
  rect(0, 0, canvasSize_w, 100); // sq_dim x sq_dim

  //-------------------------------------------------------
  // text
  // textFont(fontItalic);
  let ruohoTextColour = color("#e8e8e8");

  fill(ruohoTextColour);
  textSize(100);
  stroke(ruohoTextColour);
  textAlign(LEFT);
  textFont('Megafont');
  // text("Ruoho Ruotsi A-G V.1", 0, 0, 1500, 300);
  text("Ruoho", 150, 0, canvasSize_w, 300);
  text("Ruotsi", 927, 0, canvasSize_w, 300);

  //-------------------------------------------------------
  // middle text box
  let middleColour = color("#f0a202");        // yellowish?
  // let middleColour = color("#d5a021");        // yellowish?

  // 
  let middleStrokeColour = color("#f2f2f2"); // background light grey

  fill(middleColour);
  stroke(middleStrokeColour, 255);
  strokeWeight(10);

  var middleSize = 300;
  rect((canvasSize_w - middleSize)/2, 0, middleSize, 100);

  //-------------------------------------------------------
  // album text
  let albumTextColour = color("#302923"); // dark brown
  strokeWeight(1);

  stroke(albumTextColour);
  fill(albumTextColour);
  textAlign(CENTER, CENTER);
  textSize(60);
  text("A-G V.1", (canvasSize_w - middleSize)/2 + 15, 0, middleSize, 100);

  stroke(0);

  push();
  translate(width / 2, height / 2);

  // noStroke();
  let i = 0;
  drawingContext.shadowColor = color(0, 0, 0, 35);
  drawingContext.shadowBlur = width / 50;

  for (let h of hexes) {
    print(h);
    let points = hexGetCorners(mainLayout, h);
    let center = createVector(0, 0);
    for (let p of points) {
      center.add(createVector(p.x, p.y));
    }
    center.div(points.length);

    for (let p of points) {
      p.x -= center.x;
      p.y -= center.y;
    }
    let distance = dist(points[0].x, points[0].y, center.x, center.y);


    push();
    translate(center.x - 150, center.y + 50);  // IOHAVOC shift down from center
    // translate(center.x - 100, center.y + 150);  // IOHAVOC shift down from center

    // rotate(random(360));
    let n = int(random(points.length));
    let nn = int(random(1, 10));
    let isCircle = random(100) > 50 ? true : false;
    console.log("nn: " + nn);
    console.log("n: " + n);

    for (let m = nn; m > 0; m--) {
      let r = map(sqrt(sq(h.q) + sq(h.s) + sq(h.r)), 0, 8, 5, 0);
      let q = r;
      let p1 = createVector(points[n].x, points[n].y).mult(q);
      let p2 = createVector(points[(n + 1) % points.length].x, points[(n + 1) % points.length].y).mult(q);
      let p3 = createVector(points[(n + 3) % points.length].x, points[(n + 3) % points.length].y).mult(q);
      let p4 = createVector(points[(n + 4) % points.length].x, points[(n + 4) % points.length].y).mult(q);
      
      if (isCircle) {
      // arc(0, 0, distance / 3 * m / nn, distance / 3 * m / nn, 0, 90, PIE);

      drawOne(random(20,30), random(0,200), random(0,200));   // coordinates are offsets for R
      // drawOne(random(20,30), random(0,300), random(0,300));   // coordinates are offsets for R
      } 
      else {
        if (n % 2 == 0) {
          drawOne(random(20, 40), random(0, 200), random(0, 200));   // coordinates are offsets for R
          // drawOne(random(20, 40), random(0, 300), random(0, 300));   // coordinates are offsets for R
        } else {
          
          drawOne(random(30, 60), random(0, 100), random(0, 100));   // coordinates are offsets for R
          // drawOne(random(30, 60), random(0, 200), random(0, 200));   // coordinates are offsets for R          
        }
      }
    }

    beginShape();

    endShape(CLOSE);
    pop();

    // stroke(0, 0, 10);
    // ellipse(center.x, center.y, 10, 10);
    i++;
  }
  pop();
  noLoop();
}


function ligneAvec(strokeWeight_thickness, color_in_hex) {
  strokeWeight(strokeWeight_thickness);
  stroke(color(color_in_hex));
}

function drawOne(square_dim, translateX, translateY){

  var celln = 6;
  if (square_dim < 20) {
    celln = 4;
  }
  else if (square_dim < 40 ) {
    celln = 6;
  }
  else {
    celln = 10;
  }

  // var celln = 10;
  var cells = [];
  var margin = square_dim/18;

  // setup cell grid1
  for (var i = 0; i < celln; i++) {
      cells[i] = [];
      for (var j = 0; j < celln; j++) {
          cells[i][j] = new Cell(i*(square_dim/celln), j*(square_dim/celln), square_dim/celln, 0);
          cells[i][j].rand();
      }
  }

  push(); // Start a new drawing state

  translate(translateX, translateY);  
  ligneAvec(1, "#141414"); // for letter background set stroke style

  let c1 = random(pallete)
  // Draw circumscribing-square
  fill(255);
  rect(0, 0, square_dim, square_dim); // sq_dim x sq_dim
  
  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display();
    }

  fill(c1); // white

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 3 (bottom rect)
  rect3_height = random(square_dim/15, (square_dim/10)*3);
  rect3_width = random(square_dim/10, square_dim - (2*margin));  // max is sq_dim - some margin

  ligneAvec(1, "#141414");
  rect((square_dim - rect3_width)/2, square_dim - rect3_height, rect3_width, rect3_height);

  rect1_low_range = 10;
  rect1_high_range = square_dim - rect3_height - margin;
  // Randomly select a bounding RED line for rect1
  // Use rect3's top + a margin as the range to select in
  // rect1_lower_bound_y = random(80, sq_dim - rect3_height - margin);
  rect1_lower_bound_y = random(rect1_low_range, rect1_high_range);
  
  // Vertical line connecting R lines
  ligneAvec(1, "#141414");
  line((square_dim - rect3_width)/2, square_dim, (square_dim - rect3_width)/2, rect1_lower_bound_y);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 1 (left top/rect2)
  rect1_yoffset_from_top = 0;
  do {
    rect1_yoffset_from_top = random(margin, rect1_lower_bound_y);
  } while (rect1_lower_bound_y - rect1_yoffset_from_top < margin);

  rect1_width = random((square_dim - rect3_width)/2, square_dim - (2*margin));

  rect1_height = rect1_lower_bound_y - rect1_yoffset_from_top
  rect1_x_start = 0;
  do {
    rect1_x_start = random(margin, (square_dim - rect3_width)/2);
    sum = rect1_width + rect1_x_start;
  } while (sum + margin > square_dim);

  console.log("rect1_height: " + rect1_height);

  ligneAvec(1, "#141414");
  rect(rect1_x_start, rect1_yoffset_from_top, rect1_width, rect1_height);


  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // rect 2 (right rect1/rect3) # 200 needs to be anchored to whatever rect1 is doing
  rect2_x_start = random((square_dim - rect3_width)/2 + margin, square_dim - margin);
  // rect2_y_start = random(rect1_lower_bound_y, sq_dim - rect3_height);
  rect2_y_start = rect1_lower_bound_y + margin;

  // fills out the rest of the x dimension (sq_dim), anchoring rect2 to right side
  rect2_width = square_dim - rect2_x_start;  
  // rect2_height = random(sq_dim - rect1_lower_bound_y, sq_dim - rect1_high_range);
  rect2_height = rect1_high_range - rect1_lower_bound_y - margin;

  if (rect2_height < margin){
    console.log("[SIZE ERROR] heads up broken");
    // console.log(rect2_y_start + rect2_height + margin);
    console.log(rect1_high_range);
    console.log(rect2_height);

  } else {

  ligneAvec(1, "#141414");
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

function createPallete(_url) {
  let slash_index = _url.lastIndexOf('/');
  let pallate_str = _url.slice(slash_index + 1);
  let arr = pallate_str.split('-');
  for (let i = 0; i < arr.length; i++) {
    arr[i] = '#' + arr[i];
  }
  return arr;
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