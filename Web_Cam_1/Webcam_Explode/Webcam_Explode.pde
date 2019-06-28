/**
 * Explode 
 * by Daniel Shiffman. 
 * 
 * Mouse horizontal location controls breaking apart of image and 
 * Maps pixels from a 2D image into 3D space. Pixel brightness controls 
 * translation along z axis. 
 */
 
 
 ///modified by Adrion T. Kelley 2018
 
import processing.video.*;

PImage img;       // The source image
boolean newFrame=false;

int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system

Capture cam;

void setup() {
  size(1000, 600, P3D); 
  
  
  
  
 cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  
 
  
  img = new PImage(568,320);
  
  columns = img.width / cellsize;  // Calculate # of columns
  rows = img.height / cellsize;  // Calculate # of rows
}

void draw() {
  background(0);
  
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  // Begin loop for columns
  for ( int i = 0; i < columns; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      int x = i*cellsize + cellsize/2;  // x position
      int y = j*cellsize + cellsize/2;  // y position
      int loc = x + y*img.width;  // Pixel array location
      color c = img.pixels[loc];  // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX / float(width)) * brightness(img.pixels[loc]) - 20.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x + 200, y + 100, z);
      fill(c, 204);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();
    }
  }
  
  //saveFrame("output/Art_####.png");
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}