import ddf.minim.analysis.*;
import ddf.minim.*;

Constellation cons;
Lissajous lis;
Spirit spirit;

Minim minim;
AudioPlayer bassWave;
AudioPlayer wave;
AudioPlayer kick;
AudioPlayer snarz;
AudioPlayer hatz;
AudioPlayer voice;
AudioPlayer mallets;
FFT fft;

SmoothSignal bassSig = new SmoothSignal(0, 0.25);
SmoothSignal waveSig = new SmoothSignal(0, 0.25);
SmoothSignal kickSig = new SmoothSignal(0, 0.25);
SmoothSignal snarzSig = new SmoothSignal(0, 0.25);
SmoothSignal hatzSig = new SmoothSignal(0, 0.25);
SmoothSignal voiceSig = new SmoothSignal(0, 0.25);
SmoothSignal malletsSig = new SmoothSignal(0, 0.25);

void settings() {
  size(700, 700, P3D);
  smooth(4);
  randomSeed(0);
  minim = new Minim(this);
  bassWave = minim.loadFile("basswave.wav", 1024);
  wave = minim.loadFile("wave.wav", 1024);
  kick = minim.loadFile("kik.wav", 1024);
  snarz = minim.loadFile("snarz.wav", 1024);
  hatz = minim.loadFile("hats.wav", 1024);
  voice = minim.loadFile("voice.wav", 1024);
  mallets = minim.loadFile("mallets.wav", 1024);
  fft = new FFT(1024, bassWave.sampleRate());
  voice.loop();
  mallets.loop();
  bassWave.loop();
  wave.loop();
  kick.loop();
  snarz.loop();
  hatz.loop();
}

void setup() {
  cons = new Constellation(floor(width * .7), 5);
  lis = new Lissajous(width * 2, new PVector(width/2, height/2), width/3);
  spirit = new Spirit(new PVector(width/2, height/2), .5);
}

void draw() {
  background(255);
  updateSignals();

  cons.awaken(bassSig.value() * .1);
  lis.rapture(bassSig.value());
  
  if (kickSig.value() > 0.5) {
    cons.expand();
  }
    
  if (snarzSig.value() > 0.5) {
    cons.contract();
  }
  
  cons.speedUp(hatzSig.value());
  lis.voice(voiceSig.value());
  
  println(waveSig.value());
  
  if (waveSig.value() > .8) {
    spirit.expand();
  }
  
  spirit.update();
  cons.update();
  lis.update();
  
  if (keyPressed) {
    keyPressed();
  }
  
  spirit.draw();
  cons.draw();
  lis.draw();
}

void updateSignals() {
  updateSignal(bassWave, bassSig);
  updateSignal(wave, waveSig);
  updateSignal(kick, kickSig);
  updateSignal(snarz, snarzSig);
  updateSignal(hatz, hatzSig);
  updateSignal(voice, voiceSig);
  updateSignal(mallets, malletsSig);
}

void updateSignal(AudioPlayer player, SmoothSignal signal) {
  fft.forward(player.mix);
  signal.update(fft.calcAvg(20, 44100));
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

class SmoothSignal {
  private float value;
  private final float smoothFactor;
  
  SmoothSignal(float value, float smoothFactor) {
    this.value = value;
    this.smoothFactor = smoothFactor;
  }
  
  public float update(float newValue) {
    value += (newValue - value) * smoothFactor;
    return value;
  }
  
  public float value() {
    return value;
  }
}

class Spirit {
  PVector position;
  float expansionAcc;
  boolean expanding;
  float expansionVelocity;
  float expansion;
  
  Spirit(PVector position, float expansionAcc) {
    this.position = position;
    this.expansionAcc = expansionAcc;
    this.expanding = false;
    this.expansionVelocity = 0;
    this.expansion = 0;
  }
  
  void update() {
    if (expanding) {
      expansionVelocity += expansionAcc;
      expansion += expansionVelocity;
      
      if (expansion > width * 2) {
        expanding = false;
        expansionVelocity = 0;
        expansion = 0;
      }
    }
  }
  
  void expand() {
    if (!expanding) {
      expanding = true;
    }
  }
  
  void draw() {
    if (expanding) {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();    
    fill(246, 232, 44, map(expansion, 0, width * 2, 50, 0));
    ellipse(0, 0, expansion, expansion);    
    popMatrix();
    }
  }
}