///modified by Adrion T. Kelley 2018

import processing.video.*;


Capture cam;

PImage img;
boolean newFrame=false;


// parameters to play with
float W = 10; // stroke length multiplier
float CW = 2; // minimum stroke length
float C = 0.450; // chance of making a stroke, depending on absolute gradient value (0..1)
float B = 0.00; // constant chance of making a stroke (0..1)
float T = 4.0; // stroke width multiplier

int D = 1; // distance for color gradient calculation

float dstContrast = 500.0;

int picNumber = 1;

// colors!
color RED_CHALK = color(170, 87, 87);
color GREEN_CHALK = color(134, 140, 90);
color BLUE_CHALK = color(103, 120, 138);

int progress = 0;

void setup() {
  size(558, 320, P3D);
  smooth();
  frameRate(10);
  
   cam = new Capture(this, 40*8, 30*8, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
        

  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(558,320);
  
}

void draw() {
  
  
  if (newFrame)
  {
    newFrame=false;
    
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
  
  translate(568,0);
 rotateY(-179);
  
  tweakContrast();
   int i, j;
   for(j=0; j<568; j++)
     for(i=0; i<width; i++) {
       scan(i, progress + j); 
     }
   progress += 0;
}




// this is where the magic happens
void scan(int i, int j) {
  
  float drx, dry, dgx, dgy, dbx, dby, drl, dgl, dbl, l;
  color a, b;
    
   a = img.get(i-D, j);
   b = img.get(i+D, j);
   
   // calculate horizontal difference for each channel
   drx = (red(b) - red(a)) / 2;
   dgx = (green(b) - green(a)) / 2;
   dbx = (blue(b) - blue(a)) / 2;
   
   a = img.get(i, j-D);
   b = img.get(i, j+D);
   
   // calculate vertical difference for each channel
   dry = (red(b) - red(a)) / 2;
   dgy = (green(b) - green(a)) / 2;
   dby = (blue(b) - blue(a)) / 2;
   
   // normalize differences
   drl = sqrt(drx*drx + dry*dry) + 0.00001;
   drx /= drl;
   dry /= drl;
   drl /= 360.0;
   
   dgl = sqrt(dgx*dgx + dgy*dgy) + 0.00001;
   dgx /= dgl;
   dgy /= dgl;
   dgl /= 360.0;
   
   dbl = sqrt(dbx*dbx + dby*dby) + 0.00001;
   dbx /= dbl;
   dby /= dbl;
   dbl /= 360.0;
   
   makeStroke(i, j, drx, dry, drl, RED_CHALK);
   makeStroke(i, j, dgx, dgy, dgl, GREEN_CHALK);
   makeStroke(i, j, dbx, dby, dbl, BLUE_CHALK);
}

void makeStroke(int x, int y, float dx, float dy, float l, color chalk) {
  float sl = l * W + CW; // stroke length
  strokeWeight(l * T);
  stroke(chalk);
  if(random(1) < B + l * C) {
    line(x + dy * sl, y - dx * sl, x - dy * sl, y + dx * sl);
  }  
}

void tweakContrast() {
  int i, j;
  float mr, mg, mb, dr, dg, db;
  float r, g, b;
  color a;
  float f = 2;
  
  mr = 0;
  mg = 0;
  mb = 0;
  for(i=0; i<img.width / f; i++) {
    for(j=0; j<img.height / f; j++) {
      a = img.get(int(i*f), int(j*f));
      mr += red(a);
      mg += green(a);
      mb += blue(a);
    } 
  }
  
  float f2 = img.width * img.height / (f * f);
  mr /= f2;
  mg /= f2;
  mb /= f2;
  
  
  fill(0);
  rect(0, 0, width, height);
    
  dr = 0;
  dg = 0;
  db = 0;
  for(i=0; i<img.width / f; i++) {
    for(j=0; j<img.height / f; j++) {
      a = img.get(int(i*f), int(j*f));
      dr += sq(red(a) - mr);
      dg += sq(green(a) - mg);
      db += sq(blue(a) - mb);
    } 
  }
  dr = dstContrast / sqrt(dr / f2);
  dg = dstContrast / sqrt(dg / f2);
  db = dstContrast / sqrt(db / f2);
  
  for(i=0; i<img.width; i++) {
   for(j=0; j<img.height; j++) {
    a = img.get(i, j);
    r = constrain(mr + (red(a) - mr) * dr, 0, 255);
    g = constrain(mg + (green(a) - mg) * dg, 0, 255);
    b = constrain(mb + (blue(a) - mb) * db, 0, 255);
    a = color(r, g, b);
    img.set(i, j, a);
   }    
  }
}


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}