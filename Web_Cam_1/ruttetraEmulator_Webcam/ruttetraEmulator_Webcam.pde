//Christian Attard
//2015 @ introwerks 


///modified by Adrion T. Kelley 2018

import processing.video.*;


Capture cam;


PImage img;
boolean newFrame=false;
//String name = "maria"; //file name 
//String type = "jpg"; //file type
//int count2 = int(random(666));
color col;
int c;


int space =5; // space between lines
float weight = 1; // line weight
float depth = 0.9; // z depth
int zoom = 100; // zoom image

void setup() {
  size(568, 320, P3D);
  
  cam = new Capture(this, 40*8, 30*8, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
 
  
  img = new PImage(568, 320);
  
  //size(img.width, img.height, P3D);
  //println("christian attard, 2015 @ introwerks");
  
}

void draw() {
  background(0);
  
  if (newFrame)
  {
    newFrame=false;
    image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
translate(568,0);
 rotateY(-179);
  for (int i = 0; i < img.width; i+=space) {
    beginShape();
    for (int j = 0; j < img.height; j+=space) {
      c = i+(j*img.width);
      col = img.pixels[c];
      stroke(red(col), green(col), blue(col), 255);
      strokeWeight(weight);
      noFill();
      vertex (i, j, (depth * brightness(col))-zoom);
    }
    endShape();
  }
  
  
  //saveFrame("output/Art_####.png");
  
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}
  