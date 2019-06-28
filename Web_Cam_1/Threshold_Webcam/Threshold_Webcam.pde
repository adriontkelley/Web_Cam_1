///This sketch was modified by undergrad Adrion T. Kelley for University of Oregon Art & Technology (UOAT) 2017
///adrionk@uoregon.edu


////This sketch requires the opencv_processing and video Processing libraries



import gab.opencv.*;
import processing.video.*;


Capture cam;
OpenCV opencv;

PImage img;
boolean newFrame=false;



void setup() {
   size(568, 320);
  
  cam = new Capture(this, 40*4, 30*4, 4);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  opencv = new OpenCV(this, 568, 320);
  
   img = new PImage(568,320);
  

  
}

void draw() {
  frameRate(10);
  
  
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  opencv.loadImage(img);
 
  opencv.threshold(70);
  image(opencv.getOutput(), 0, 0);
  
  
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}

