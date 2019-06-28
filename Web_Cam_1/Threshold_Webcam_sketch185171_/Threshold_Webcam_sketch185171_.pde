///modified by Adrion T. Kelley 2018


import gab.opencv.*;
import processing.video.*;



int num=8000;
//color[] palette = { #FE4365, #FC9D9A, #F9CDAD, #C8C8A9, #83AF9B};
color[] palette = { #A3A948, #EDB92E, #F85931, #CE1836, #009989};


Capture cam;
OpenCV opencv;




PImage img;
PImage img2;
boolean newFrame=false;



void setup() {
  size(568, 320);
  colorMode(HSB, 360, 100, 100);


  cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  opencv = new OpenCV(this, 568, 320);
  
  
  img = new PImage(568,320);

  
}

void draw() {
  
  
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  opencv.loadImage(img);
 
  opencv.threshold(70);
  
  img2 = opencv.getOutput();
  
  
  drawStuff();
  
  //saveFrame("output/Art_####.png");
  
}



void drawStuff() {
  background(#202020);
  
  

  for (int i=0; i<num; i++) {
    float x = random(width);
    float y = random(height);
    
    
    
    color col = img2.get(int(x), int(y));
    stroke(#FE4365, 200);
    noStroke();
    if (brightness(col)<20) {    
      for (int j=0; j<5; j++) {
        fill(palette[4-j],220);
        float sz = 40-j*7;
        ellipse(x, y, sz, sz);
      }
    }
  }
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}