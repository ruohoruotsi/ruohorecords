
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
  noLoop() 
}


function draw() {

  background(255);
  stroke(0);
  strokeWeight(16);
    
  // rect(0, 0, cir_dim, cir_dim); // outer, circumscribing rect
  // ellipse((canvasSize+offset)/2, (canvasSize+offset)/2, canvasSize+offset, canvasSize+offset);

  translate(offset*(sq_dim/cir_dim), offset*(sq_dim/cir_dim));
  print("mouseX: " + mouseX, mouseY)
    
  // rect(cir_dim/18, cir_dim/18, sq_dim - 2*cir_dim/18, sq_dim - 2*cir_dim/18); // inner rect - complique
  // fill(100);
  rect(0, 0, sq_dim, sq_dim); // better rect


  //////////////////////////////////////////////////////////////////////////////////
  // rect 3 (bottom rect2)
  rect3_top_bound_y = sq_dim - 150; // random(sq_dim - 200, sq_dim);
  rect3_height = random(20,100);
  rect3_width = random(60,200);
  // fill(200);
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
  // fill(170);
  rect(random(0,100), rect1_offset_from_top, rect1_width, rect1_height);

  noFill();
  console.log(rect1_lower_bound_y, rect1_offset_from_top, rect1_height);


  //////////////////////////////////////////////////////////////////////////////////
  // rect 2 (right rect1/rect3) # 200 needs to be anchored to whatever rect1 is doing
  var gap = 40
  rect2_left_bound_x = random((sq_dim - rect3_width)/2 + gap, sq_dim - gap);
  rect2_left_bound_y = random(rect1_lower_bound_y + gap, sq_dim - rect3_height - gap);
  rect2_height = random(gap, sq_dim - rect3_height - rect2_left_bound_y);
  
  // fills out the rest of the x dimension (sq_dim), anchoring rect2 to right side
  rect2_width = sq_dim - rect2_left_bound_x;  
  
  // fill(220);
  rect(rect2_left_bound_x, rect2_left_bound_y, rect2_width, rect2_height);
  noFill();

  console.log(rect3_height, rect2_height, sq_dim - rect3_height - rect2_left_bound_y - gap);

  stroke(200)



}


function mousePressed() {
  loop();
}

function mouseReleased() {
  noLoop();
}

function keyPressed() {
  if (key == 's' || key == 'S') saveCanvas(gd.timestamp(), 'png');
}
