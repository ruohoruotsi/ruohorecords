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
var bg_color;

var DEBUG = false;  // control debug logging and diagnostic lines

// -----------------------------------------------------------------
let url = "https://coolors.co/app/ffcd38-f2816a-71dcdd-2d557f-f7ede2";
let pallete;

let boardRadius = 10; //radius of hex grid
let size;             //size of hexes
let graphics;


function setup() {

  createCanvas(canvasSize_w, canvasSize_h);
  colorMode(HSB, 360, 100, 100, 100);
  angleMode(DEGREES);
  pallete = createPallete(url);

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
    // random(100) > 50 ? graphics.fill(0, 0, 100, 25) : graphics.fill(0, 0, 0, 35);
    random(100) > 50 ? graphics.fill(0, 0, 100, 20) : graphics.fill(0, 0, 0, 5);
    graphics.ellipse(x, y, w, h);
  }

    // graphics = createGraphics(width, height);
    // graphics.stroke(255, 8 / 100 * 255);
    // for (let i = 0; i < width * height * 10 / 100; i++) {
    //   graphics.strokeWeight(random(3));
    //   graphics.point(random(width),
    //     random(height));
    // }
  }


function draw() {
  background(0, 0, 95);
  image(graphics, 0, 0);


  draw_quad_colors()

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
  text("SNGLS", (canvasSize_w - middleSize)/2 + 15, 0, middleSize, 100);

  stroke(0);

  // noLoop();
}



function draw_quad_colors() {
  blendMode(BLEND);
  bg_color = color(random(360), 5, 95);
  // background(random(360), 5, 95);
  background(bg_color);
  blendMode(BURN);

  for (let k = 0; k < 5; k++) {
    let offset, margin, cells, d;

    offset = width / 15;
    margin = 0
    cells = int(random(3, 3));
    d = (width - offset * 2 - margin * (cells - 1)) / cells;

    for (let j = 0; j < cells; j++) {
      if (j == 0) continue;
      // if (j == 1) continue; 

      for (let i = 0; i < cells; i++) {
        let x = offset + i * (d + margin);
        let y = offset + j * (d + margin);

        push();
        translate(x + d / 2, y + d / 2);
        rotate(int(random(4)) * 360 / 4);
        noStroke();

        let gradient = drawingContext.createRadialGradient(-d / 2, -d / 2, 0, -d / 2, -d / 2, d * 2);

        let c1 = random(pallete);
        let c2 = random(pallete);
        let c3 = random(pallete);
        while (c1 == c2 || c2 == c3 || c3 == c1) {
          c1 = random(pallete);
          c2 = random(pallete);
          c3 = random(pallete);
        }
        gradient.addColorStop(0, c1);
        gradient.addColorStop(0.5, c2);
        gradient.addColorStop(1, c3);

        drawingContext.shadowColor = random(pallete);
        drawingContext.shadowBlur = width / 40;

        drawingContext.fillStyle = gradient;
        if (random(100) > 33) {
          if (random(100) > 50) {
            if (random(100) > 50) {
              quad(-d / 2, -d / 2, 0, -d / 2, d / 2, d / 2, 0, d / 2);
            } else {
              quad(d / 2, -d / 2, 0, -d / 2, -d / 2, d / 2, 0, d / 2);
            }
          } else {
            triangle(-d / 2, -d / 2, d / 2, -d / 2, d / 2, d / 2);
          }
        }
        pop();
      }
    }
  }
  blendMode(BLEND);
  image(graphics, 0, 0);
  frameRate(0.5);
}

function ligneAvec(strokeWeight_thickness, color_in_hex) {
  strokeWeight(strokeWeight_thickness);
  stroke(color(color_in_hex));
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
