
var multiplier = 1;
var cir_dim = 600 * multiplier;
var sq_dim = 450 * multiplier;
var offset = 100 * multiplier;
var canvasSize = 500 * multiplier;

function setup() {
  createCanvas(canvasSize+offset, canvasSize+offset);
  frameRate(0.5); // Attempt to refresh at starting FPS
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
  rect1_offset_from_top = random(0, rect1_lower_bound_y)
  line(0, rect1_lower_bound_y, sq_dim, rect1_lower_bound_y);
  rect1_height = rect1_lower_bound_y - rect1_offset_from_top
  fill(100);
  rect(0, rect1_offset_from_top, rect1_height, rect1_height);
  noFill();

  // rect 2 (right rect1/rect3)
  rect2_left_bound_x = random(200, sq_dim);
  rect2_height = sq_dim - rect2_left_bound_x;
  fill(100);
  rect(rect2_left_bound_x, rect1_lower_bound_y, rect2_height, 50);
  noFill();


  // rect 3 (bottom rect2)
  rect3_top_bound_y = sq_dim - 150; // random(sq_dim - 200, sq_dim);
  rect3_height = random(20,100);
  rect3_width = 60; // random(40,60);
  fill(100);
  // rect((sq_dim - rect3_width)/2, sq_dim - rect3_height, (sq_dim + rect3_width)/2, rect3_height);
  rect(200, 350, 250, 5);  // rect(x,y, w, h) ==> rect(30, 20, 55, 55);


  noFill();


}