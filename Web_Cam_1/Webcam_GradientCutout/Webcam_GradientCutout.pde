
/*
 * This sketch uses the text drawn to an offscreen PGraphics to cut out
 * specific portions of a series of diagonal, gradient shapes
 * 
 * USAGE: 
 * - move the mouse around to change the grid dimensions
 * - use the 'g' key to toggle gradual gradient size changes
 * - use the 's' key to toggle stroke display
 */

///modified by Adrion T. Kelley 2018



import gab.opencv.*;
import processing.video.*;


Capture cam;
OpenCV opencv;


PImage img;
PImage img2;
boolean newFrame=false;



color FOREGROUND_COLOR = color(255, 0, 0);
color BACKGROUND_COLOR = color(0, 0, 255);
color PGRAPHICS_COLOR = color(0);
boolean displayStroke = false;
boolean changeGradientSize = true;
int gradientCounter = 0;

PGraphics pg;

void setup() {
  size(568, 320, P2D); // per vertex coloring requires an OpenGL renderer
  smooth(16); // for better results
  
  
  cam = new Capture(this, 40*4, 30*4, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  opencv = new OpenCV(this, 568, 320);
  
 
  
  img = new PImage(568,320);
  

  
}

void draw() {
  background(BACKGROUND_COLOR);
  
  
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
  
  
  // create and draw to PPraphics (see Getting Started > UsingPGraphics example)
  pg = createGraphics(img.width, img.height, JAVA2D);
  pg.beginDraw();
  pg.textSize(500);
  pg.textAlign(CENTER, CENTER);
  pg.fill(PGRAPHICS_COLOR);
  pg.image(img,30,30);
  pg.endDraw();
  
  // move the mouse to change the grid dimensions
  int gridVertical = (int) map(mouseY, 0, height, 10, 100);
  int gridHorizontal = (int) map(mouseX, 0, width, 10, 100);
  int margin = max(gridVertical, gridHorizontal) * 2;
  // dynamic gradient size (toggle with 'g' key)
  if (changeGradientSize) gradientCounter++;
  float gradientSize = 100 + sin(gradientCounter * 0.01) * 100;
  // create diagonal lines covering the whole screen using two while loops
  // some initial variables needed within the while loops
  int y = 0;
  boolean done = false;
  boolean insideShape = false;
  if (displayStroke) { stroke(0); } else { noStroke(); } //  toggle with 's' key
  while (!done) {
    // start somewhere left of the screen, each time a little bit further down
    y+=gridVertical;
    int vx = -margin;
    int vy = y;
    beginShape(QUAD_STRIP);
    // keep going while the right or top side hasn't been reached
    while (vx < width+margin && vy > -margin) {
      // check if point is inside text
      color c = pg.get(vx, vy);
      boolean inText = (c == PGRAPHICS_COLOR);
      if (inText) {
        if (!insideShape) {
          // end the current Shape when first entering the text
          endShape();
          insideShape = true;
        }
      } else {
        if (insideShape) {
          // start a new Shape when exiting the text
          beginShape(QUAD_STRIP);
          insideShape = false;
        }
        // when outside text, add two vertices
        fill(FOREGROUND_COLOR);
        vertex(vx, vy);
        fill(BACKGROUND_COLOR);
        vertex(vx + gradientSize, vy + gradientSize);
      }
      // move right and upwards
      vx += gridHorizontal;
      vy -= gridVertical;
      // if we are beyond the right and beyond the bottom of the screen, stop the main while loop
      if (vx > width && vy > height) done = true; // escape!
    }
    endShape();
  }
}

void keyPressed() {
  if (key == 'g') changeGradientSize = !changeGradientSize;
  if (key == 's') displayStroke = !displayStroke;
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}