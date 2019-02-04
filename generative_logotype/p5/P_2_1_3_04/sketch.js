// P_2_1_3_04
//
// Generative Gestaltung – Creative Coding im Web
// ISBN: 978-3-87439-902-9, First Edition, Hermann Schmidt, Mainz, 2018
// Benedikt Groß, Hartmut Bohnacker, Julia Laub, Claudius Lazzeroni
// with contributions by Joey Lee and Niels Poldervaart
// Copyright 2018
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * changing positions of stapled circles in a grid
 *
 * MOUSE
 * position x          : module detail
 * position y          : module parameter
 *
 * KEYS
 * 1-3                 : draw mode
 * arrow left/right    : number of tiles horizontally
 * arrow up/down       : number of tiles vertically
 * s                   : save png
 */
'use strict';

var canvasSize = 800;

var count = 0;
var tileCountX = 1;
var tileCountY = 1;

var drawMode = 1;

function setup() {
  createCanvas(windowWidth, windowHeight);
  rectMode(CENTER);
  frameRate(10);
}


function draw() {
  clear();
  background(0);
  stroke(255);
  strokeWeight(2);

  noFill();

  ellipse(canvasSize/2, canvasSize/2, canvasSize, canvasSize);

  count = mouseX / 20 + 10;
  var para = mouseY / height;

  var tileWidth = width / tileCountX;
  var tileHeight = height / tileCountY;

  for (var gridX = 0; gridX <= tileCountX; gridX++) {

      var posX = tileWidth / 2;
      var posY = tileHeight / 2;

      push();
      translate(posX, posY);

      // switch between modules
      switch (drawMode) {
      case 1:
        stroke(255);
        for (var i = 0; i < count; i++) {
          rect(0, 0, tileWidth, tileHeight);
          scale(1 - 3 / count);
          rotate(para * 0.1);
        }
        break;
      case 2:
        noStroke();
        // debug
        // print(mouseX, mouseY);
        // print(count)

        for (var i = 0; i < count; i++) {
          // IOHAVOC --> fix the gradient here
          // var gradient = lerpColor(color(0, 0), color(166, 5, 5), i / count);
          var from = color(0,0);
          var to = color(166, 5, 5);
          colorMode(RGB); // Try changing to HSB.
          // var gradient = lerpColor(from, to, 0.33);

           // IOHAVOC - gradient needs to change for Lin Interp Color to give us more visible 
           // useful colors  ... so start from not black but close to it or rather is there 
           // an expoential color interpolation?
          var gradient = lerpColor(from, to, i/count); 

          fill(gradient, i / count * 200);
          // rotate(QUARTER_PI);
          rotate(0.20);
          rect(0, 0, tileWidth, tileHeight);
          scale(1 - 3 / (count));
          rotate(para * 1.5);
          // rotate(para * 2.5);

        }
        break;
      case 3:
        noStroke();
        for (var i = 0; i < count; i++) {
          var gradient = lerpColor(color(0, 130, 164), color(255), i / count);
          fill(gradient, 170);

          push();
          translate(4 * i, 0);
          ellipse(0, 0, tileWidth / 4, tileHeight / 4);
          pop();

          push();
          translate(-4 * i, 0);
          ellipse(0, 0, tileWidth / 4, tileHeight / 4);
          pop();

          scale(1 - 1.5 / count);
          rotate(para * 1.5);
        }
        break;
      }

      pop();
  }
}

function keyReleased() {
  if (key == 's' || key == 'S') saveCanvas(gd.timestamp(), 'png');
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
  if (keyCode == DOWN_ARROW) tileCountY = max(tileCountY - 1, 1);
  if (keyCode == UP_ARROW) tileCountY += 1;
  if (keyCode == LEFT_ARROW) tileCountX = max(tileCountX - 1, 1);
  if (keyCode == RIGHT_ARROW) tileCountX += 1;
}
