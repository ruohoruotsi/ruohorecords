let bg;
let pallete;
// original
// let url = "https://coolors.co/app/ffcd38-f2816a-71dcdd-2d557f-f7ede2";
let url = "https://coolors.co/generate/f5b800-ec7e09-bc2d10-755c58-2d8a9f-203c5b-f7ede2";

let cells, cols, rows;
let offset, margin;
let cellW, cellH;

// -----------------------------------------------------------------
var multiplier = 1;
var canvasSize_w = 1500;  // 1080p at retina // 1920×1080 
var canvasSize_h = 1500 * multiplier;  // 1080p at retina // 1920×1080 
var bg_color;


function setup() {

  createCanvas(canvasSize_w, canvasSize_h);
  angleMode(DEGREES);
  pallete = createPallete(url);

  bg = createGraphics(width, height);
  bg.colorMode(HSB, 360, 100, 100, 100);
  bg.fill(0, 0, 100, 5);
  bg.noStroke();
  for (let i = 0; i < width * height * 20 / 100; i++) {
    let x = random(width);
    let y = random(height);
    let w = random(8);
    let h = random(8);
    bg.noStroke();
    bg.ellipse(x, y, w, h);
  }
}


function draw() {
  background(0, 0, 95);
  image(bg, 0, 0);

  draw_quad_colors_bezier();

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
  text("Ruoho", 150, -100, canvasSize_w, 300);
  text("Ruotsi", 927, -100, canvasSize_w, 300);


  // //-------------------------------------------------------
  // // middle text box
  let middleColour = random(pallete);

  // 
  let middleStrokeColour = random(pallete);

  fill(middleColour);
  stroke(bg_color);
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
  text("RSHPS", (canvasSize_w - middleSize)/2 + 15, 0, middleSize, 100);

  stroke(0);
  // noLoop();
}



function draw_quad_colors_bezier() {

  blendMode(BLEND);
  bg_color = color(random(10), 0, 45);
  background(bg_color);

  cells = int(random(5, 6));
  cols = cells;
  rows = cells;
  offset = width / 10;
  margin = 50; // offset / 5;

  cellW = (width - offset * 2 - margin * (cols - 1)) / cols;
  cellH = (height - offset * 2 - margin * (rows - 1)) / rows;

  for (let j = 0; j < rows; j++) {
    for (let i = 0; i < cols; i++) {
      if (j == 0) continue;

      let x = offset + i * (cellW + margin);
      let y = offset + j * (cellH + margin);
      let cx = x + cellW / 2;
      let cy = y + cellH / 2;
      let repeat = int(random(1, 4));
      for (let m = 0; m < repeat; m++) {
        push();
        translate(cx, cy);
        rotate(int(random(4)) * 360 / 4);
        let r = cellW * 1 / 2;
        int(random(3, 10)) / 9;
        drawBezier(-cellW / 2, -cellH / 2, cellW / 2, cellH / 2, r);
        pop();
      }
    }
  }

  blendMode(BLEND);
  image(bg,0,0);
  // noLoop();
  frameRate(0.5);

}

function keyPressed() {
  if (key == 's' || key == 'S') 
    saveCanvas(Math.round(new Date().getTime() / 1000).toString(), 'png');
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

function drawBezier(x1, y1, x4, y4, r) {
  let x2 = x1 + cos(0) * r;
  let y2 = y1 + sin(0) * r;
  let x3 = x4 + cos(180 + 0) * r;
  let y3 = y4 + sin(180 + 0) * r;
  let c = random(pallete);
  noStroke();
  fill(c);
  //bezier(x1,y1,x2,y2,x3,y3,x4,y4);
  beginShape();
  vertex(x1, y1);
  bezierVertex(x2, y2, x3, y3, x4, y4);
  vertex(x4, y1);
  endShape(CLOSE);
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