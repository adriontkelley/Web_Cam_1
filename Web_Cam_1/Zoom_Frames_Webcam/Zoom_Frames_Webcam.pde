/**
 * Zoom. 
 * 
 * Move the cursor over the image to alter its position. Click and press
 * the mouse to zoom. This program displays a series of lines with their 
 * heights corresponding to a color value read from an image. 
 */
 
 ///modified by Adrion T. Kelley 2018
 
 
 import processing.video.*;

Capture cam;

 
 

PImage img;
boolean newFrame=false;
int[][] imgPixels;
float sval = 1.0;
float nmx, nmy;
int res = 5;

void setup() {
  size(1000, 700, P3D);
  
  smooth();
    
  noFill();
  stroke(255);
 cam = new Capture(this, 40*8, 30*8, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
  
  
  img = new PImage(568,320);
  
  
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
  
  
  imgPixels = new int[img.width][img.height];
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      imgPixels[j][i] = img.get(j, i);
    }
  }
  
  

  nmx += (mouseX-nmx)/20; 
  nmy += (mouseY-nmy)/20; 

  if(mousePressed) { 
    sval += 0.005; 
  } 
  else {
    sval -= 0.01; 
  }

  sval = constrain(sval, 1.0, 2.0);

  translate(width/2 + nmx * sval-100, height/2 + nmy*sval - 100, -50);
  scale(sval);
  rotateZ(PI/2 - sval + 1.0);
  rotateX(map(mouseX, 0, width, -PI, PI));
  //rotateY(sval/8 - 0.125);

  translate(-width/2, -height/2, 0);

  for (int i = 0; i < img.height; i += res) {
    for (int j = 0; j < img.width; j += res) {
      float rr = red(imgPixels[j][i]); 
      float gg = green(imgPixels[j][i]);
      float bb = blue(imgPixels[j][i]);
      float tt = rr+gg+bb;
      stroke(rr, gg, gg);
      line(i, j, tt/10-20, i, j, tt/10 );
    }
  }
  
  //saveFrame("output/Art_####.png");
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}
  