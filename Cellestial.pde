import ddf.minim.analysis.*;
import ddf.minim.*;

Constellation cons;

Minim minim;
AudioPlayer bassWave;


void settings() {
  size(700, 700, P3D);
  smooth(4);
  randomSeed(0);
}

void setup() {
  cons = new Constellation(floor(width * .7), 10);
}

void draw() {
  background(255);
  cons.update();
  
  if (keyPressed) {
    keyPressed();
  }
  
  cons.draw();
}

void keyPressed() {
  if (key == 'w') {
    cons.awaken(0.2);
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      cons.expand();
    }
    
    if (keyCode == DOWN) {
      cons.contract();
    }
    
    if (keyCode == RIGHT) {
      cons.speedUp(1);
    }
  }
}