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


let boardRadius = 10; //radius of hex grid
let size;             //size of hexes
let originHex;        // very center of the board
let hexes = [];
let mainLayout;
let graphics;


let mj_img; // Declare variable 'mj_img'.


function setup() {
  createCanvas(canvasSize_w, canvasSize_h);
  mj_img = loadImage('midjourney_images/AGV3.png'); // Load the image
}


function draw() {
  // image(mj_img, 0, 0);
  image(mj_img, 0, 0, canvasSize_w, canvasSize_h,
    0, 0, 6656, 6656);


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
  text("Ruoho", 150, 0, canvasSize_w, 300);
  text("Ruotsi", 927, 0, canvasSize_w, 300);

  //-------------------------------------------------------
  // middle text box
  let middleColour = color("#dc2f02");        // reddish

  fill(middleColour);
  strokeWeight(0);

  var middleSize = 300;
  rect((canvasSize_w - middleSize)/2, 10, middleSize, 80); // offset 10px on borders above text

  //-------------------------------------------------------
  // album text
  let albumTextColour = color("#302923"); // dark brown
  strokeWeight(1);

  stroke(albumTextColour);
  fill(albumTextColour);
  textSize(60);
  text("A-G V.3", (canvasSize_w - middleSize)/2 + 17, 20, middleSize, 100);
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
