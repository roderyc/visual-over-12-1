color[] palette = {#FFFF73, #FFFF99, #FFFFBF};
PVector origin = new PVector(0, 0);
float rebound = 0.9;
float decay = 0.8;
float speed = 10;
float globalPhase = 0;

class Constellation {
  private final ArrayList<CellestialBody> bodies;
  private float phase;
  private float phaseAddition;
  private float phaseAcc;
  
  Constellation(int size, int sizeOfBodies) {
    this.bodies = new ArrayList();
    this.phase = 0;
    this.phaseAddition = 0;
    this.phaseAcc = 0;
    
    for (int i = 0; i < size; i++) {
      float x = random(-width * 1.1, width * 1.1);
      float y = random(-height * 1.1, height * 1.1);
      bodies.add(new CellestialBody(sizeOfBodies, new PVector(x, y), #1A9FF9, random(0, TWO_PI)));
    }
  }
  
  void draw() {
    pushMatrix();
    translate(width / 2, // + (sin(phase * 4) * width/8),
              height / 2); // + (cos(phase * 6) * height/8));
    rotate(phase);
    for (CellestialBody body : bodies) {
      body.draw();
    }
    popMatrix();
  }
  
  void update() {
    phase += (0.01 * (1 + phaseAcc));
    phaseAcc *= decay;
    
    for (CellestialBody body : bodies) {
      body.update();
    }
  }
  
  void contract() {
    for (CellestialBody body : bodies) {
      body.pushTo(origin);
    }
  }
  
  void expand() {
    for (CellestialBody body : bodies) {
      body.pushFrom(origin);
    }
  }
  
  void awaken(float amount) {
    for (CellestialBody body : bodies) {
      body.awaken(amount);
    }
  }
  
  void speedUp(float amount) {
    this.phaseAcc += amount;
  }
}

class CellestialBody {
  private color c;
  private int size;
  private PVector position;
  private PVector displacement;
  private PVector acc;
  private float phase;
  private float baseAwareness;
  private float wokeness;
  private float wokeacc;
  
  CellestialBody(int size, PVector position, color c, float phase) {
    this.size = size;
    this.position = position;
    this.displacement = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.c = c;
    this.phase = phase;
    this.baseAwareness = 0.2;
    this.wokeness = 0;
    this.wokeacc = 0;
  }
  
  void draw() {
    pushMatrix();
    translate(x(), y());
    noStroke();
    fill(c, map(sin(phase), -1, 1, map(woke(), 0, 1, 0, 50), map(woke(), 0, 1, 50, 255)));
    float currentSize = size();
    ellipse(0, 0, currentSize, currentSize);
    popMatrix();
  }
  
  void update() {
    phase += 0.1;
    phase = phase % TWO_PI;
    
    if (displacement.mag() < position.mag()) {
      displacement.add(acc);
    }
    displacement.mult(rebound);
    acc.mult(decay);
    
    wokeness = min(1 - baseAwareness, wokeness + (wokeacc * .5));
    wokeness *= rebound;
    wokeacc *= decay;
  }
  
  private float size() {
    return size + breathe();
  }
  
  private float x() {
    return position.x + displacement.x + (sin(phase) * 10) + (sin(phase * 10) * woke() * 2);
  }
  
  private float y() {
    return position.y + displacement.y + (sin(phase + PI/4) * 10) + (sin(phase * 10) * woke() * 2);
  }
  
  float breathe() {
    return sin(phase) * 2;
  }
  
  float woke() {
    return baseAwareness + wokeness;
  }
  
  void pushTo(PVector to) {
    acc = PVector.sub(to, position);
    acc.normalize();
    acc.mult(speed);
  }
  
  void pushFrom(PVector from) {
    acc = PVector.sub(position, from);
    acc.normalize();
    acc.mult(speed);
  }
  
  void awaken(float amount) {
    wokeacc = amount * (1 - baseAwareness);
  }
}