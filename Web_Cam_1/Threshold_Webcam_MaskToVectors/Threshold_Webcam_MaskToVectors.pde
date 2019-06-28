///This sketch was modified by undergrad Adrion T. Kelley for University of Oregon Art & Technology (UOAT) 2017
///adrionk@uoregon.edu


////This sketch requires the opencv_processing and video Processing libraries


import java.util.Collections;
import java.util.Random;
import dawesometoolkit.*;
import gab.opencv.*;
import processing.video.*;


Capture cam;
OpenCV opencv;

PImage img;
boolean newFrame=false;

ArrayList<PVector> vectors;
DawesomeToolkit dawesome;
ArrayList<Integer> colors;

int count  = 0;

void setup() {
   size(568, 320);
  
  cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  opencv = new OpenCV(this, 568, 320);
  
   img = new PImage(568,320);
   
   dawesome = new DawesomeToolkit(this);
    colors = dawesome.colorSpectrum(160, 100, 50);
  

  
}

void draw() {
  background(0);
  //frameRate(4);
  
 
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  opencv.loadImage(img);
 
  opencv.threshold(70);
  //image(opencv.getOutput(), 0, 0);
  
  vectors = dawesome.maskToVectors(opencv.getOutput());
  
  
  //long seed = System.nanoTime();
  Collections.shuffle(vectors, new Random(count));
  smooth();
        
         
    
       
   int count = 0;
  for (PVector p: vectors){
    if (count%4==0){
                        noStroke();
      fill(colors.get(count%colors.size()));
      float dotSize = count%30;
      if (count%4==0){
        //rect(p.x, p.y, dotSize, dotSize);
      //} else {
        ellipse(p.x, p.y, dotSize, dotSize);
      }
    }
    count++;
  }
  
  
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}