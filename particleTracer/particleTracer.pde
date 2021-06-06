import processing.video.*;
import Blobscanner.*;

Movie movie;
Detector bd;

//tracer threshold for particle tracking
int tracerThreshold = 0;

color boundingBoxCol = color(255, 0, 0);
int boundingBoxThickness = 1;

void setup()
{
  //set size an background
  size(640, 360);
  background(0);
  //load and play the video in a loop
  movie = new Movie(this, "particles.mov");
  movie.loop();
  movie.frameRate(5);
  
  bd = new Detector( this, 0, 0, width, height, 255 );
}

void movieEvent(Movie m) {
  m.read();
}

void draw()
{
  //set the threshold for the tracer to mouse position
  tracerThreshold = mouseX;
  
  //draw the original video image
  image(movie, 0, 0, width, height);
  
  //load the pixels from the video
  movie.loadPixels();
  loadPixels();
  
  //loop through all pixels to find the particles
  for(int x=0; x<width; x++)
  {
    for(int y=0; y<height; y++)
    {
      //set the current location
      int loc = x + y*width;
      
      //read the color value at the location
      color c = movie.pixels[loc];
      
      //set the color to red if there is a particle
      if(brightness(c) > tracerThreshold)
      {
        pixels[loc] = color(255,0,0);
      }
    }
  }
  
  //update the pixels
  updatePixels();
  
  bd.findBlobs(pixels, width, height);
  bd.loadBlobsFeatures();// to call always before to use a method returning or processing a blob feature
  bd.weightBlobs(true);
  
  //bd.drawBox(boundingBoxCol, boundingBoxThickness);
  noFill();
  stroke(255);
  
  for(int i = 0; i < bd.getBlobsNumber(); i++) 
  {
    int blobWeight = bd.getBlobWeight(i)*2;
    rect(bd.getBoxCentX(i)-blobWeight/2, bd.getBoxCentY(i)-blobWeight/2, blobWeight, blobWeight);
    text(i,bd.getBoxCentX(i)-blobWeight/2, bd.getBoxCentY(i)-blobWeight/2);
  }
}