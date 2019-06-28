///modified by Adrion T. Kelley 2018

import processing.video.*;
import gab.opencv.*;


int drawMode = 0;
int drawSpeed = 6000; 
color bgcolor = color(255);
color pgcolor = color(0);

PImage img;
boolean newFrame=false;

PImage img2;

Capture cam;
OpenCV opencv;

void setup() {
  size(568, 320);
  background(bgcolor); 
  colorMode(HSB, 360, 100, 100); 
  rectMode(CENTER);
  
  
  
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
  
  
  
  switch (drawMode) {
  case 0:
  for (int i=0; i<drawSpeed; i++) {

    int x = (int) random(width);
    int y = (int) random(height);
    
    boolean insideText = (img2.get(x, y) == pgcolor);
 
    if (insideText) {      
      pushMatrix();
      translate(x, y);
        float er = random(5,9);
        color ec = color(random(70, 130), 90, 95);
        stroke(0, 170);
        fill(ec);
        ellipse(0, 0, er, er);
       popMatrix();
    } else{
      pushMatrix();
      translate(x, y);
      float er = random(5, 7);
      color ec = color(random(40, 45), 30, 60);
      stroke(0, 170);
      fill(ec);
      ellipse(0, 0, er, er); 
      popMatrix();
    }    
  }
  break;
  case 1:
  for (int i=0; i<drawSpeed; i++) {

    int x = (int) random(width);
    int y = (int) random(height);
    
    boolean insideText2 = (img2.get(x, y) == pgcolor);
 
    if (insideText2) {      
      pushMatrix();
      translate(x, y);
        float td = random(5, 7);
        float tr = random(TWO_PI);
        color tc = color(random(180, 200), random(0,13), 100);
        stroke(0,170);
        fill(tc);
        rotate(tr);
        triangle(0, -td, -td, td, td, td);
       popMatrix();
    } else{
      pushMatrix();
      translate(x, y);
      float td = random(4, 6);
      float tr = random(TWO_PI);
      color tc = color(random(170, 210), random(50,100), 100);
      stroke(0,170);
      fill(tc);
      rotate(tr);
      triangle(0, -td, -td, td, td, td);
      popMatrix();
    }    
  }
  break;
  
  
}

//saveFrame("output/Art_####.png");
}
void mousePressed() {
  background(bgcolor); 
  drawMode = ++drawMode%2; 
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}