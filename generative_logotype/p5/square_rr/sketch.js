
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
    
  rect(0, 0, cir_dim, cir_dim); // outer, circumscribing rect
  ellipse((canvasSize+offset)/2, (canvasSize+offset)/2, canvasSize+offset, canvasSize+offset);

  translate(offset*(sq_dim/cir_dim), offset*(sq_dim/cir_dim));
  print(mouseX, mouseY)
    
  // rect(cir_dim/18, cir_dim/18, sq_dim - 2*cir_dim/18, sq_dim - 2*cir_dim/18); // inner rect - complique
  rect(0, 0, sq_dim, sq_dim); // better rect

  // rect 1 (left top/rect2

  // randomly select a bounding line for rect1
  rect1_lower_bound_y = random(50, 300)
  rect1_offset_from_top = random(0,rect1_lower_bound_y)
  line(0, rect1_lower_bound_y, sq_dim, rect1_lower_bound_y);
  rect1_height = rect1_lower_bound_y - rect1_offset_from_top
  rect(0, rect1_offset_from_top, rect1_height, rect1_height);

  // rect 2 (right rect1/rect3)
  // rect 3 (bottom rect2)

}