/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/161029*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ArrayList<Particle> particles;
int[] list;
PVector axis;

int distance;
PFont font;

int count = 0;
int max = 600;

char typedKey = 'R';

void setup() {
  colorMode(RGB,255,255,255);
  size(600,800);
  background(255, 250, 245);
  strokeCap(SQUARE);
  
  frameRate(30);
  stroke(9);
  strokeWeight(0.1);
  distance = 13;
  particles = new ArrayList<Particle>();

  
  font = createFont("FreeSansBold.ttf", 370);
  textFont(font);
  fill(0);
  
  textAlign(CENTER, CENTER);
  text(typedKey, width/2, height/2-60);
  list = new int[width*height];
  
  loadPixels();
  for(int y = 0; y <= height-1; y++) {
    
    for(int x = 0; x <= width-1; x++) {
    
      color pb = pixels[y*width + x];
      //System.out.println("pb = :" + pb + " " + red(pb));
      
      // create a MASK of 0s and 1s
      if(red(pb) < 5) {  // Foreground
        list[y*width+x] = 0;  
        //System.out.println("list index == 0" + " " + y + " " + x + " " + red(pb));

    } else {  
        list[y*width+x] = 1;  // Background red(pb) == 255, as in background(255,250,245);
        //System.out.println("list index == 1" + " " + y + " " + x + " " + red(pb));
      }
    }
  }
  
  updatePixels();
}

void draw() {
  
  if(count < max){
    int i = 0;
    
    while(i < 3) {  
      axis = new PVector(int(random(100, width-100)),int(random(100, height-100)));
      
      // list[index] == 0 means that it was in the "mask"
      if(list[int(axis.y*width + axis.x)] == 0 && 
         list[int(axis.y*width + axis.x+1)] == 0 && 
         list[int(axis.y*width + axis.x-1)] == 0 && 
         list[int((axis.y+1)*width + axis.x)] == 0 && 
         list[int((axis.y+1)*width + axis.x)] == 0) {
           
          particles.add(new Particle(axis.x,axis.y));
          i++;
          count++;
     }
    }
  }
  
  background(#FFFAF5);
    
  for (int i = 0; i < particles.size(); i++) {
    Particle p=particles.get(i);
    p.update();
    for(int j=i+1;j<particles.size();j++){
      Particle pp=particles.get(j);
      if (dist(p.location.x , p.location.y , pp.location.x , pp.location.y) < distance) {
        line(p.location.x , p.location.y , pp.location.x , pp.location.y);
      }
    }
  } 
}

void keyReleased(){
      if (key != CODED && key != ' ' && key != TAB && key != ENTER && key != RETURN) {
      background(#FFFFFF);
      typedKey = key;
      setup();
    }
}

class Particle {
  PVector location;
  PVector velocity;
  //PVector plocation;

  Particle(float x, float y) {
    location = new PVector(x,y);
    velocity = new PVector(random(1),1);
  }
  
  void update() {
    location.add(velocity);
    if ((list[int(location.y)*width+int(location.x+velocity.x)]==1)   ||   (list[int(location.y)*width+int(location.x-velocity.x)]==1)) {  velocity.x *= -1;  }
    if ((list[int(location.y+velocity.y)*width+int(location.x)]==1) || (list[int(location.y-velocity.y)*width+int(location.x)]==1)) {  velocity.y *= -1;  }
  }
}

