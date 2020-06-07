
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
var sq_dim = 700;
var canvasSize_w = 1920 * multiplier;  // 1080p at retina // 1920×1080 
var canvasSize_h = 1080 * multiplier;  // 1080p at retina // 1920×1080 

var DEBUG = false;  // control debug logging and diagnostic lines
let graphics;


function setup() {
  createCanvas(canvasSize_w, canvasSize_h);

  //////////
  colorMode(HSB, 360, 100, 100, 100);
  angleMode(DEGREES);

  graphics = createGraphics(width, height);
  graphics.colorMode(HSB, 360, 100, 100, 100);
  graphics.noStroke();
  for (let i = 0; i < width * height * 25 / 100; i++) {
    // let r = (1 - random(random(random()))) * sqrt(sq(width) + sq(height)) / 2;
    let r = (random(random(random()))) * sqrt(sq(width) + sq(height)) / 2;

    let angle = random(360);
    let x = width / 2 + cos(angle) * r;
    let y = height / 2 + sin(angle) * r;
    let w = random(10);
    let h = random(10);

    // Alpha controls dispersion of textural bg
    // random(100) > 50 ? graphics.fill(0, 0, 100, 25) : graphics.fill(0, 0, 0, 35);
    random(100) > 50 ? graphics.fill(0, 0, 100, 55) : graphics.fill(0, 0, 0, 65);

    graphics.ellipse(x, y, w, h);
  }

  /////////
  frameRate(0.5); // Attempt to refresh at starting FPS // 0.5

  noFill();
  if (DEBUG) {
    noLoop();
  }
}


function draw() {

  clear();               // <=== transparent background
  image(graphics, 0, 0);
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

