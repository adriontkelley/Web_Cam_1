/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/117808*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//Delaunay filter
//A classic one in my own implementation.
//Ale González, 2013


///modified by Adrion T. Kelley 2018

import java.util.List;
import java.util.LinkedList;
import processing.video.*;


Capture cam;


PImage img;
boolean newFrame=false;


int W = 568, H = 320;
int[] colors;
ArrayList<Triangle> triangles;

void setup() 
{
    size(568, 320, P3D);
    smooth();
    
    cam = new Capture(this, 40*8, 30*8, 20);
        // Comment the following line if you use Processing 1.5
        cam.start();
        

  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(568,320);
    
    frameRate(10);
}

void draw(){
    
  
  if (newFrame)
  {
    newFrame=false;
    //image(cam,-1000,-1000,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    
  }
  
    
    //Portrait of Jean-Charles de Cordes, by Rubens
    //PImage buffer = loadImage("r.jpg");

    //Extract significant points of the picture
    ArrayList<PVector> vertices = new ArrayList<PVector>();
    EdgeDetector.extractPoints(vertices, img, EdgeDetector.SOBEL, 100, 4);
    
    //Add some points in the border of the canvas to complete all space
    for (float i = 0, h = 0, v = 0; i<=1 ; i+=.05, h = W*i, v = H*i) {
        vertices.add(new PVector(h, 0));
        vertices.add(new PVector(h, H));
        vertices.add(new PVector(0, v));
        vertices.add(new PVector(W, v));
    }
 
    //Get the triangles using qhull algorithm. 
    //The algorithm is a custom refactoring of Triangulate library by Florian Jennet (a port of Paul Bourke... not surprisingly... :D) 
    triangles = new ArrayList<Triangle>();
    new Triangulator().triangulate(vertices, triangles);
    
    //Prune triangles with vertices outside of the canvas.
    Triangle t = new Triangle();
    for (int i=0; i < triangles.size(); i++) {
        t = triangles.get(i); 
        if (vertexOutside(t.p1) || vertexOutside(t.p2) || vertexOutside(t.p3)) triangles.remove(i);        
    }
    
    //Get colors from the triangle centers
    int tSize = triangles.size();
    colors = new int[tSize*3];
    PVector c = new PVector();
    for (int i = 0; i < tSize; i++) {
        c = triangles.get(i).center();
        colors[i] = img.get(int(c.x), int(c.y));
    }
    
    //And display the result
    translate(568,0);
 rotateY(-179);
    displayMesh();
}

//Util function to prune triangles with vertices out of bounds  
boolean vertexOutside(PVector v) { return v.x < 0 || v.x > width || v.y < 0 || v.y > height; }  

//Display the mesh of triangles  
void displayMesh()
{
    Triangle t = new Triangle();
    beginShape(TRIANGLES);
    for (int i = 0; i < triangles.size(); i++)
    {
        t = triangles.get(i); 
        fill(colors[i]);
        stroke(colors[i]);
        vertex(t.p1.x,t.p1.y);
        vertex(t.p2.x, t.p2.y);
        vertex(t.p3.x, t.p3.y);
    }
    endShape();
}  


void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}
  
  

  

  