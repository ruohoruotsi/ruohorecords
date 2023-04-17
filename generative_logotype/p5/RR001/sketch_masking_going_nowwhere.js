
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

var celln1 = 40;
var cells1 = [];

var celln2 = 30;
var cells2 = [];

var DEBUG = false;  // control debug logging and diagnostic lines
var margin = 40;

let pg_bg;
let pg_bg_img;

let pg_text;
let pg_text_img;

let pg_text_hole;
let pg_text_img_hole;

let pg_bg_solo;
let pg_bg_solo_img;

  // var pg = createGraphics(canvasSize_w, canvasSize_h);
  // //do stuff inside pg
  // var img = createImage(pg.width, pg.height);
  // // img.copy(pg, 0, 0, pg.width, pg.height, 0, 0, pg.width, pg.height);

function preload() {
  // font = loadFont('assets/Jangotype.ttf');
  font = loadFont('assets/bombfact.ttf');
  pg_text = createGraphics(canvasSize_w, canvasSize_h);
  pg_text_hole = createGraphics(canvasSize_w, canvasSize_h);

  pg_bg = createGraphics(canvasSize_w, canvasSize_h);
  pg_bg_solo = createGraphics(canvasSize_w, canvasSize_h);
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

  for (var i = 0; i < celln2; i++) {
      cells2[i] = [];
      for (var j = 0; j < celln2; j++) {
          cells2[i][j] = new Cell(i*(sq_dim/celln2), j*(sq_dim/celln2), sq_dim/celln2, 0);
          cells2[i][j].rand();
      }
  }

  pg_text.textFont(font);
  pg_text.textSize(420);
  pg_text.textLeading(250);
  pg_text.textAlign(CENTER, CENTER);

  pg_text_hole.textFont(font);
  pg_text_hole.textSize(420);
  pg_text_hole.textLeading(250);
  pg_text_hole.textAlign(CENTER, CENTER);


  pg_bg_img = createImage(canvasSize_w, canvasSize_h);
  pg_text_img = createImage(canvasSize_w, canvasSize_h);
  pg_text_img_hole = createImage(canvasSize_w, canvasSize_h);

  pg_bg_solo_img = createImage(canvasSize_w, canvasSize_h);

  noFill();
  if (DEBUG) {
    noLoop();
  }
}


function draw() {

  // clear background on each frame
  pg_bg.clear();                        // <=== transparent background
  pg_bg.background(255, 255, 255);      // <=== white background

  pg_bg_solo.clear();                        // <=== transparent background
  pg_bg_solo.background(255, 255, 255);      // <=== white background

  // bg cell grid color
  // pg_bg.stroke(99, 40, 37);

  // draw one here
  pos1_w = (canvasSize_w - sq_dim) / 2 ;
  pos_h = (canvasSize_h - sq_dim) / 2;

  drawOne(pg_bg, cells1, celln1, 0, 0);   // coordinates are offsets for R
  drawBG(pg_bg_solo, cells2, celln2, 0, 0);  // coordinates are offsets for R

  pg_text.text('AG\nV.1', (canvasSize_w/2), (canvasSize_h/2) );


  // white on black bg
  // pg_text_hole.background(255, 255, 255);      // <=== white background
  // pg_text_hole.stroke(255, 255, 255);
  // pg_text_hole.fill(255, 255, 255);

  pg_text_hole.stroke(0, 0, 0);
  pg_text_hole.fill(0, 0, 0);

  // black on white bg
  // pg_text_hole.stroke(0);
  // pg_text_hole.fill(0);

  pg_text_hole.text('AG\nV.1', (canvasSize_w/2), (canvasSize_h/2) );

  // Set text
  // text('AMUSE \nGUEULES \nVOL. 1', canvasSize_w/2, canvasSize_h/2);
  // text('Amuse \nGueules \nVol One', canvasSize_w/2, canvasSize_h/2);

  // copy over stuff from pgraphics to. imgs
  pg_text_img.copy(pg_text, 0, 0, pg_text.width, pg_text.height, 0, 0, pg_text.width, pg_text.height);
  pg_text_img_hole.copy(pg_text_hole, 0, 0, pg_text_hole.width, pg_text_hole.height, 0, 0, pg_text_hole.width, pg_text_hole.height);

  pg_bg_img.copy(pg_bg, 0, 0, pg_bg.width, pg_bg.height, 0, 0, pg_bg.width, pg_bg.height);
  pg_bg_solo_img.copy(pg_bg_solo, 0, 0, pg_bg_solo.width, pg_bg_solo.height, 0, 0, pg_bg_solo.width, pg_bg_solo.height);

  // Mask
  pg_bg_img.mask(pg_text_img);
  pg_bg_solo_img.mask(pg_text_img_hole);



  // DRAW  mage onto current graphics context
  // pg_bg_img.blend(pg_bg_solo_img, 0, 0, pg_bg.width, pg_bg.height, 0, 0, pg_bg.width, pg_bg.height, BLEND);
  image(pg_bg_img, 0, 0);  // textured font

  // image(pg_bg_solo_img, 0, 0);   // only bg
  // image(pg_text_img_hole, 0, 0);    // white on transparent mask img
  // image(pg_text_img, 0, 0);      // black on transparent mask img

  
}

function ligneAvec(pg_bg, strokeWeight_thickness, lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b ) {
  pg_bg.strokeWeight(strokeWeight_thickness);
  pg_bg.stroke(lineStrokeColor_r, lineStrokeColor_g, lineStrokeColor_b);
}

function drawOne(pg_bg, cells, celln, translateX, translateY){

  pg_bg.push(); // Start a new drawing state

  pg_bg.translate(translateX, translateY);

  // draw the main shape first so the background for the grid isn't drawing transparent
  // main shape stroke color & weight
  // ligneAvec(pg_bg, 18, 0, 0, 0);

  // Draw circumscribing-square
  // pg_bg.fill(0);                  // BACKGROUND COLOR HERE
  pg_bg.rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  pg_bg.noFill();


  // for letter background set stroke style
  // ligneAvec(pg_bg, 7, 99, 40, 37);
  // ligneAvec(pg_bg, 3, 59, 59, 59);  // grey

  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display(pg_bg);
    }

  // // redraw rect shape, so the background lines don't show. Ugh
  ligneAvec(pg_bg, 18, 0, 0, 0);

  // Draw circumscribing-square
  pg_bg.rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  pg_bg.fill(255);                  // white

  print("mouseX: " + mouseX, mouseY)
  
  pg_bg.pop(); // Restore original state
}



function drawBG(pg_bg, cells, celln, translateX, translateY){

  pg_bg.push(); // Start a new drawing state

  pg_bg.translate(translateX, translateY);

  // Draw circumscribing-square
  pg_bg.fill(250);                  // BACKGROUND COLOR HERE
  pg_bg.rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  pg_bg.noFill();

  // draw bg cell grid
  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display(pg_bg);
    }

  // // redraw rect shape, so the background lines don't show. Ugh
  ligneAvec(pg_bg, 18, 0, 0, 0);

  // Draw circumscribing-square
  pg_bg.rect(0, 0, sq_dim, sq_dim); // sq_dim x sq_dim
  pg_bg.fill(255);                  // white
  
  pg_bg.pop(); // Restore original state
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

  display(pg_bg) {

    let dice = random(0, 30)
    if (Math.round(dice) == 1){
      let r = random(150,255)
      let g = random(0,50)
      let b = random(0, 50)
      ligneAvec(pg_bg, 4, r, g, b);  // reddish
    }
    else {
      let color = random(0,70)
      ligneAvec(pg_bg, 4, color, color, color);  // grey
      // ligneAvec(pg_bg, 7, random(0,50), random(0,50), random(0,50));  // grey
    }

    if (this.moving) this.pos += this.speed;

    if (this.pos > this.s) {
      this.pos = 0;
      this.moving = false;
    }

    switch(this.type) {
    case 0: 
      break;

    case 1: 
      pg_bg.line(this.x, this.y, this.x+this.s, this.y+this.s);
      pg_bg.line(this.x+this.s/2, this.y, this.x+this.s, this.y+this.s/2);
      pg_bg.line(this.x, this.y+this.s/2, this.x+this.s/2, this.y+this.s);
      //break;

    case 2: 
      pg_bg.line(this.x+this.s, this.y, this.x, this.y+this.s);
      pg_bg.line(this.x+this.s/2, this.y, this.x, this.y+this.s/2);
      pg_bg.line(this.x+this.s/2, this.y+this.s, this.x+this.s, this.y+this.s/2);
      break;
    }
  }
}