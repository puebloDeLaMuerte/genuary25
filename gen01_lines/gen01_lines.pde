import java.io.File;
import processing.video.*;

Capture cam;

String[] imageFiles;
int imageFilePointer = 0;

PImage sourceImage;
ArrayList<Tile> tiles;

boolean drawLineRepresentation = false;


void setup() {

  String[] cameras = Capture.list();
  println("Available cameras:");
  for (String c : cameras) {
    println(c);
  }

  cam = new Capture(this, 2*640, 2*480);
  cam.start();

  //size(800,600);
  fullScreen();

  //String directoryPath = "/Users/pt/Documents/Processing/_sourceImages/scenes B/";
  //String directoryPath = "/Users/pt/Documents/Processing/_sourceImages/nackt/";
  String directoryPath = "/Users/pt/Documents/Processing/_sourceImages/oldimages/";
  imageFiles = getImageFiles(directoryPath);
}


void draw() {

  background(0);

  if (cam.available() == true) {
    cam.read();
    sourceImage = cam;
    tiles = createTiles(sourceImage, 21, 21);
  }

  if ( sourceImage != null ) {
    //image(sourceImage,0,0,width,height);
  }

  if ( tiles != null ) {
    for ( Tile t : tiles ) {

      if ( drawLineRepresentation ) {
        t.drawLineRepresentation(1, color(0), color(255));
      } else {
        t.draw(1);
      }
    }
  }



  // Draw the webcam frame on the canvas
  //image(cam, 0, 0, width, height);
}


void keyPressed() {

  int pointerdelta = 0;
  if ( key == CODED ) {
    if ( keyCode== RIGHT ) {
      println("RIGHT");
      pointerdelta = 1;
    }
    if ( keyCode == LEFT ) {
      println("LEFT");
      pointerdelta = -1;
    }
  }


  imageFilePointer = (imageFilePointer + pointerdelta + imageFiles.length) % imageFiles.length;

  if ( pointerdelta != 0 ) {
    sourceImage = loadImage(imageFiles[imageFilePointer]);
    tiles = createTiles( sourceImage, 11, 11);
  }

  if ( key == 'l' ) drawLineRepresentation = !drawLineRepresentation;
}
