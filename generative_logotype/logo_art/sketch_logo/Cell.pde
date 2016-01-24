
class Cell {

  float x, y, s, pos = 0, speed = 1.5;
  int m = 2, type; //0-empty
  boolean moving = false;

  Cell(float inx, float iny, float ins, int intp) {
    x = inx; 
    y = iny;
    s = ins;
    type = intp;
  }

  void rand() {
    type = ceil(random(2));
  }

  void display(processing.core.PGraphics g) {
    if (moving) pos += speed;

    if (pos > s) {
      pos = 0;
      moving = false;
    }

    switch(type) {
    case 0: 
      break;

    case 1: 
      g.line(x, y, x+s, y+s);
      g.line(x+s/2, y, x+s, y+s/2);
      g.line(x, y+s/2, x+s/2, y+s);
      //break;

    case 2: 
      g.line(x+s, y, x, y+s);
      g.line(x+s/2, y, x, y+s/2);
      g.line(x+s/2, y+s, x+s, y+s/2);
      break;
    }
  }
}