
var d = 600;
var dim = 450
var offset = 100
var canvasSize = 500

function setup() {
  createCanvas(canvasSize+offset, canvasSize+offset);
  frameRate(2); // Attempt to refresh at starting FPS
  stroke(255);
  noFill();    
}

function draw() {

    background(255);
    stroke(0);
    strokeWeight(1);
    
    ellipse((canvasSize+offset)/2, (canvasSize+offset)/2, canvasSize+offset, canvasSize+offset);
    
    translate(offset*(3/4), offset*(3/4));
    // print(mouseX, mouseY);
    ribbonWidth = map(mouseY, 0, height, 1, 200);

    for (var i = 0; i < dim - dim *(3/7) - dim/20; i += dim/20) {
        // bezier(dim - dim/4, dim/3 + dim/8,                  // x1, y1 - anchor point
        //        dim + d/8, 0,                                // x2, y2 - control point
        //        0, 0,                                        // x3, y3 - second control point
        //        (dim - dim/6) - (4/3)*i, dim - d/9);         // x4, y4 - second anchor point

        var x1 = dim - dim/4;
        var y1 = dim/3 + dim/8;
        var x2 = dim + d/8;
        var y2 = 0;
        var x3 = 0;
        var y3 = 0;
        var x4 = (dim - dim/6) - (4/3)*i;
        var y4 = dim - d/9;

      beginShape();

        var posx = posy = 0;
        var nextPosx = nextPosy = 0;
        print(ribbonWidth);
        var steps = 100;
        for (var j = 0; j <= steps; j++) {
          // var t = j / steps;
          var t = j / ribbonWidth;

          var x = bezierPoint(x1, x2, x3, x4, t);
          var y = bezierPoint(y1, y2, y3, y4, t);

          posx = x;
          posy = y;
          if (nextPosx && nextPosy && posx && posy) {

            var p0 = createVector(posx, posy);
            var p1 = createVector(nextPosx, nextPosy);
            var v = p5.Vector.sub(p1, p0);
            v.normalize();
            v.rotate(HALF_PI);
            v.mult(t);
            var pneu = p5.Vector.add(p0, v);
            curveVertex(pneu.x, pneu.y);
            // vertex(pneu.x, pneu.y);
          }
          nextPosx = posx;
          nextPosy = posy;
          ellipse(x, y, 5, 5);
        }
      
      endShape(CLOSE);
    }
    
  rect(d/9, d/9, dim - 2*d/9, dim - 2*d/9);     // little rect
  rect(d/18, d/18, dim - 2*d/18, dim - 2*d/18); // bigger rect

}
