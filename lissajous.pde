class Lissajous {
  private final int resolution;
  private PVector position;
  private float size;
  private float voice;
  private float rapture;
  private float phase;
  
  Lissajous(int resolution, PVector position, float size) {
    this.resolution = resolution;
    this.position = position;
    this.size = size;
  }
  
  void draw() {
    float breath = breath();
    float scaledVoice = voice * 2;
    float yfreq = 8 + (breath * (1 + scaledVoice));
    float xfreq = 12 + (breath * (1 + scaledVoice));
    pushMatrix();
    noFill();
    stroke(246, 232, 44, 200);
    //stroke(30, 30, 120, 50);
    strokeWeight(1);
    translate(position.x, position.y);
    rotate(map(sin(phase), -1, 1, -PI/30, PI/30) * (1 + scaledVoice));
    beginShape();
    
    for (int i=0; i<=(resolution); i++) {
      float angle = map(i, 0, resolution, 0, TWO_PI);
      float y = sin(angle * yfreq) * size + rapture();
      float x = cos(angle * xfreq) * size;
      vertex(x, y);
    }
    
    endShape();
    popMatrix();
  }
  
  void update() {
    phase += 0.1;
    phase = phase % TWO_PI;
  }
  
  void voice(float voice) {
    this.voice  = voice;
  }
  
  float breath() {
    return (cos(phase * 3) * .05);
  }
  
  void rapture(float rapture) {
    this.rapture = rapture;
  }
  
  float rapture() {
    return (sin(phase * 100) * rapture * 2);
  }
}