
var multiplier = 1;
var cir_dim = 600 * multiplier;
var sq_dim = 450 * multiplier;
var offset = 100 * multiplier;
var canvasSize = 500 * multiplier;

function setup() {
  createCanvas(canvasSize+offset, canvasSize+offset);
  frameRate(2); // Attempt to refresh at starting FPS
  stroke(255);
  noFill();    
}

function draw() {

  background(255);
  stroke(0);
  strokeWeight(4);
    
  ellipse((canvasSize+offset)/2, (canvasSize+offset)/2, canvasSize+offset, canvasSize+offset);
  rect(0, 0, cir_dim, cir_dim); // better rect

  translate(offset*(sq_dim/cir_dim), offset*(sq_dim/cir_dim));
  print(mouseX, mouseY)
    
  // rect(cir_dim/18, cir_dim/18, sq_dim - 2*cir_dim/18, sq_dim - 2*cir_dim/18); // bigger rect - complique
  // rect(0, 0, (sq_dim/cir_dim)*sq_dim, (sq_dim/cir_dim)*sq_dim); // better rect
  rect(0, 0, sq_dim, sq_dim); // better rect
}