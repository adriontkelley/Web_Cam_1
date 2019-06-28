/**
* Display of Character Like Electronic Signboard
*
* @author aa_debdeb
* @date 2015/11/14
*/

///modified by Adrion T. Kelley 2018

import gab.opencv.*;
import processing.video.*;

Capture cam;
OpenCV opencv;


PImage img;
PImage img2;
boolean newFrame=false;



void setup(){
  size(568, 320);
  smooth();
  background(0);
  

  cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  opencv = new OpenCV(this, 568, 320);
  
  
  img = new PImage(568,320);
  
  
}

void draw(){
  
  background(0);
  fill(255);
  
  
  
  if (newFrame)
  {
    newFrame=false;
   
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  opencv.loadImage(img);
 
  opencv.threshold(70);
  
  img2 = opencv.getOutput();
 
  
  
  boolean[][] dots = new boolean[56][32];
  
  //images[count].loadPixels();
  for(int x = 0; x < 56; x++){
    for(int y = 0; y < 32; y++){
     
      color c = img2.pixels[y * 10 * width + x * 10];
      dots[x][y] = red(c) > 127 ? true: false;
    }
  }
  //images[count].updatePixels();
  background(0);
  stroke(0);
  for(int x = 0; x < 56; x++){
    for(int y = 0; y < 32; y++){
      if(dots[x][y]){
        fill(0);  
      } else {
        fill(255, 140, 0);
      }
      ellipse(x * 10, y* 10, 10, 10);        
    }
  }
  
//saveFrame("output/Art_####.png");
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}