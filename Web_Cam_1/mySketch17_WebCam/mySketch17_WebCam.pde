///modified by Adrion T. Kelley 2018


import processing.video.*;


Capture cam;


PImage img;
boolean newFrame=false;


//PImage img;
  
int vSpace = 20;
int hSpace = 20;

float amplitudeHeight = vSpace/2;
float precision = hSpace/15;

void setup() {
  size(1080, 720,P3D); 
  smooth();
  
  cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
        

  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(1080,720);
  
  //img = loadImage("1.jpeg");
  
  noFill();
  stroke(255);
} 

void draw() {
  background(0);  
  translate(1080,0);
 rotateY(-179.07);
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  
  
  float frequency = -frameCount;
  for (int y = vSpace; y < height-vSpace*2; y+=vSpace) {
    beginShape();
    int x = 0;
    float prevAmplitude = 0;
    while (x < width) {
      float colorIntensity = img.get(int(x), int(y)) >> 16 & 0xFF;
      float amplitude = map(colorIntensity, 0, 255 , 1, 0);
      for(int i=0; i<hSpace; i+=precision){
        float curAmpitude = lerp(prevAmplitude, amplitude, i/hSpace);
        x+=precision;
        frequency += curAmpitude;
      	vertex(x, y+sin(frequency)*curAmpitude*amplitudeHeight);
      }
      prevAmplitude = amplitude;
    }
    endShape();
  }
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}