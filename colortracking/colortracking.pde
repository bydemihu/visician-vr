// Demi Hu
// https://demi-hu.com
// Object and Spaces II, Visician VR Controller demo
// Processing color tracking code from Daniel Shiffman, attributed below.

// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

// next steps:
// add drawing bound box
// add diff screens for gamestates
// add illustrations for procedure
// track multiple colors

// imports
import processing.video.*;
Capture video;

// globar vars
color trackColor = color(51, 120, 199);
float threshold = 40;  // color threshold
float pthreshold = 60; // pinch threshold
float lthreshold = 100;  // incision point distance threshold
ArrayList<PVector> positions = new ArrayList<PVector>();


// set tracking colors
color stylusColor = color(51, 120, 199);
color hingeColorL = color(51, 120, 199);
color hingeColorR = color(103, 170, 110);

// game states
boolean loading = false;
boolean calibration = false;
boolean incision = true;
boolean removal = false;
boolean report = false;

// action states
boolean drawing = false;
boolean pinching = false;

boolean[] states = {loading, calibration, incision, removal, report, drawing, pinching};

// temp ball to pinch
float ballX = 600;
float ballY = 600;

void setup() {
  //size(1280, 720);
  size(1920, 1080);
  //fullScreen();
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  //trackColor = color(51, 120, 199); // track pure white
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);

  if (loading) {
    // action
  }

  if (calibration) {
    // action
    // display video
    // track stylus and hinge
  } else if (incision) {
    // display video
    displayVideo();
    
    // track stylus
    PVector pos = trackColor(stylusColor);
    trackColor(hingeColorR);

    // record incision points
    if (keyPressed == true) {
      drawing = true;
      recordIncision(pos);
    } else {
      drawing = false;
      PVector pseudo = new PVector(0, 0);
      positions.add(pseudo);
    }

    // draw incision
    displayIncision();
    
    
    
  } else if (removal) {
    // track hinge
  } else if (report) {
    // display report
  }


}

// distance func
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

// functions
void mousePressed() {
  //Save color where the mouse is clicked in trackColor variable
  if(mouseX < video.width && mouseY < video.height){
  int loc = video.width-mouseX + mouseY*video.width;
  stylusColor = video.pixels[loc]; 
  }
  
  undo();
}

void displayVideo() {
  video.loadPixels();

  pushMatrix();
  translate(video.width, 0);
  scale(-1, 1);
  image(video, 0, 0, video.width, video.height);
  popMatrix();
}

PVector trackColor(color trackColor) {
  // takes a color to track, draws an ellipse where identified, and returns the position of color

  float avgX = 0;
  float avgY = 0;
  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(video.width - x, y);
        avgX += video.width - x;
        avgY += y;
        count++;
      }
    }
  }

  if (count > 20) {
    avgX = avgX / count;  // take the average x position
    avgY = avgY / count;

    // Draw a circle at the tracked pixel in video
    strokeWeight(2.0);
    noFill();
    stroke(255);
    ellipse(avgX, avgY, 12, 12);

    // Remap to the large screen
    avgX = map(avgX, 0, video.width, 0, width);
    avgY = map(avgY, 0, video.height, 0, height);

    // Draw a circle at the corresponding pixel in large screen
    ellipse(avgX, avgY, 24, 24);
  }
  
  // return the tracked color position
  return new PVector(avgX, avgY);
}

void recordIncision(PVector pos) {

  // if there is an existing point, make tweens
  if (positions.size() > 1) {
    
    // get last point
    float pastX = positions.get(positions.size()-1).x;
    float pastY = positions.get(positions.size()-1).y;
    
    // make inbetweens
    PVector tween = new PVector((3*pastX + pos.x)/4, (3*pastY + pos.y)/4);
    positions.add(tween);
    
    tween = new PVector((pastX + pos.x)/2, (pastY + pos.y)/2);
    positions.add(tween);
    
    tween = new PVector((pastX + 3*pos.x)/4, (pastY + 3*pos.y)/4);
    positions.add(tween);
    
  }
  
  // add current incision point to array
  positions.add(pos);
}


void displayIncision() {
  for (int i = 1; i < positions.size(); i ++) {
    fill(255, 0, 0);
    noStroke();
    PVector old = positions.get(i-1);
    PVector pos = positions.get(i);

    float d = abs(dist(old.x, old.y, pos.x, pos.y)); // base size 20, dist affects it
    //ellipse(pos.x, pos.y, 12, 12);

    //blendMode(MULTIPLY);
    stroke(255, 0, 0);

    strokeWeight(10);
    if (d < lthreshold) {
      // reduce jitter somehow
      line(old.x, old.y, pos.x, pos.y);
      //ellipse((old.x + pos.x)/2, (old.y + pos.y)/2, 10, 10);
      //ellipse(pos.x, pos.y, 10, 10);
    }
  }
}

void undo() {
  positions = new ArrayList<PVector>();
}
