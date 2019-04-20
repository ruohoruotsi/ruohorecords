// P_2_2_2_02
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
 * draw the path of an intelligent agent
 *
 * MOUSE
 * position x          : composition speed of the picture
 *
 * KEYS
 * 1-3                 : draw mode
 * DEL/BACKSPACE       : clear display
 * s                   : save png
 */
'use strict';

var NORTH = 0;
var EAST = 1;
var SOUTH = 2;
var WEST = 3;
var direction = SOUTH;

var stepSize = 3;
var minLength = 10;
var diameter = 1;
var angleCount = 7;
var angle;
var reachedBorder = false;

var posX;
var posY;
var posXcross;
var posYcross;

var dWeight = 50;
var dStroke = 4;

var drawMode = 1;

// Background cells
var celln = 24;
var cells = [];


function setup() {
  createCanvas(600, 600);
  colorMode(HSB, 360, 100, 100, 100);
  background(360);
  frameRate(5); // Attempt to refresh at starting FPS

  angle = getRandomAngle(direction);
  posX = floor(random(width));
  posY = 5;
  posXcross = posX;
  posYcross = posY;

  // setup cells
  // for (var i = 0; i < celln; i++){
  //   for (var j = 0; j < celln; j++) {
  //     cells[i][j] = new Cell(i*(width/celln), j*(width/celln), width/celln, 0);
  //       cells[i][j].rand();
  //     }
  // }

  for (var i = 0; i < celln; i++) {
      cells[i] = [];
      for (var j = 0; j < celln; j++) {
          cells[i][j] = new Cell(i*(width/celln), j*(width/celln), width/celln, 0);
          cells[i][j].rand();
      }
  }

}

var minY = 150;
var minX = 150; 


function draw() {

  background(255);
  translate(100, 100);

  for (var i = 0; i < celln; i++)
    for (var j = 0; j < celln; j++){
      cells[i][j].rand();
      cells[i][j].display();
    }


/*
  var speed = int(map(mouseX, 0, width, 0, 20));
  for (var i = 0; i <= speed; i++) {

    // ------ draw dot at current position ------
    strokeWeight(1);
    stroke(180, 0, 0);
    // point(posX, posY);

    // ------ make step ------
    posX += cos(radians(angle)) * stepSize;
    posY += sin(radians(angle)) * stepSize;

    // ------ check if agent is near one of the display borders ------
    reachedBorder = false;

    if (posY <= minY) {
      direction = SOUTH;
      reachedBorder = true;
    } else if (posX >= width - minX) {
      direction = WEST;
      reachedBorder = true;
    } else if (posY >= height - minY) {
      direction = NORTH;
      reachedBorder = true;
    } else if (posX <= minX) {
      direction = EAST;
      reachedBorder = true;
    }

    // ------ if agent is crossing his path or border was reached ------
    loadPixels();
    var currentPixel = get(floor(posX), floor(posY));
    if (
      reachedBorder ||
      (currentPixel[0] != 255 && currentPixel[1] != 255 && currentPixel[2] != 255)
    ) {
      angle = getRandomAngle(direction);

      var distance = dist(posX, posY, posXcross, posYcross);
      if (distance >= minLength) {
        strokeWeight(distance / dWeight);
        if (drawMode == 1) stroke(0);
        if (drawMode == 2) stroke(52, 100, distance / dStroke);
        if (drawMode == 3) stroke(192, 100, 64, distance / dStroke);
        line(posX, posY, posXcross, posYcross);
      }

      posXcross = posX;
      posYcross = posY;
    }
  }
  */
}

function keyReleased() {
  if (key == 's' || key == 'S') saveCanvas(gd.timestamp(), 'png');
  if (keyCode == DELETE || keyCode == BACKSPACE) background(360);
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
}

function getRandomAngle(currentDirection) {
  var a = (floor(random(-angleCount, angleCount)) + 0.5) * 90 / angleCount;
  if (currentDirection == NORTH) return a - 90;
  if (currentDirection == EAST) return a;
  if (currentDirection == SOUTH) return a + 90;
  if (currentDirection == WEST) return a + 180;
  return 0;
}


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

  display() {
    if (this.moving) this.pos += this.speed;

    if (this.pos > this.s) {
      this.pos = 0;
      this.moving = false;
    }

    switch(this.type) {
    case 0: 
      break;

    case 1: 
      line(this.x, this.y, this.x+this.s, this.y+this.s);
      line(this.x+this.s/2, this.y, this.x+this.s, this.y+this.s/2);
      line(this.x, this.y+this.s/2, this.x+this.s/2, this.y+this.s);
      //break;

    case 2: 
      line(this.x+this.s, this.y, this.x, this.y+this.s);
      line(this.x+this.s/2, this.y, this.x, this.y+this.s/2);
      line(this.x+this.s/2, this.y+this.s, this.x+this.s, this.y+this.s/2);
      break;
    }
  }
}
