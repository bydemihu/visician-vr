// Demi Hu
// demi-hu.com
// Object and Spaces II, Visician VR Controller demo
// Processing color tracking code from Daniel Shiffman, attributed below.

// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

// next steps: map it to the larger canvas
// track multiple colors

// imports
import processing.video.*;
Capture video;

// globar vars
color trackColor = color(51, 120, 199);
float threshold = 40;  // color threshold
float pthreshold = 60; // pinch threshold
ArrayList<PVector> positions = new ArrayList<PVector>();
float pastX;
float pastY;
float currStroke = 0;
boolean sameStroke;

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
  
  if (loading){
    // action
  }
  
  if (calibration){
    // action
    // display video
    // track stylus and hinge
  }
  
  else if (incision){
    // track stylus
    // display video
    // display video
    displayVideo();
    trackColor(stylusColor);
    trackColor(hingeColorR);
  }
  
  else if (removal){
    // track hinge
  }
  
  else if (report){
    // display report
  }
  
  //video.loadPixels();

  //pushMatrix();
  //translate(video.width, 0);
  //scale(-1, 1);
  //image(video, 0, 0, video.width, video.height);
  //popMatrix();



  //threshold = map(mouseX, 0, width, 0, 100);
  //threshold = 50;

  //float avgX = 0;
  //float avgY = 0;

  //float hrX = 0;
  //float hrY = 0;

  //int count = 0;
  //int counthr = 0;

  //// Begin loop to walk through every pixel
  //for (int x = 0; x < video.width; x++ ) {
  //  for (int y = 0; y < video.height; y++ ) {
  //    int loc = x + y * video.width;
  //    // What is current color
  //    color currentColor = video.pixels[loc];
  //    float r1 = red(currentColor);
  //    float g1 = green(currentColor);
  //    float b1 = blue(currentColor);
  //    float r2 = red(trackColor);
  //    float g2 = green(trackColor);
  //    float b2 = blue(trackColor);

  //    float r3 = red(hingeColorR);
  //    float g3 = green(hingeColorR);
  //    float b3 = blue(hingeColorR);

  //    float d = distSq(r1, g1, b1, r2, g2, b2);
  //    float dhr = distSq(r1, g1, b1, r3, g3, b3);

  //    if (d < threshold*threshold) {
  //      stroke(255);
  //      strokeWeight(1);
  //      point(video.width - x, y);
  //      avgX += video.width - x;
  //      avgY += y;
  //      count++;
  //    } else if (dhr < threshold*threshold) {
  //      stroke(255);
  //      strokeWeight(1);
  //      point(video.width - x, y);
  //      hrX += video.width - x;
  //      hrY += y;
  //      counthr++;
  //    }
  //  }
  //}

  // We only consider the color found if its color distance is less than 10.
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  //if (count > 20) {
  //  avgX = avgX / count;  // take the average x position
  //  avgY = avgY / count;

  //  // Draw a circle at the tracked pixel in video
  //  strokeWeight(2.0);
  //  noFill();
  //  stroke(255);
  //  ellipse(avgX, avgY, 24, 24);

  //  // Map to the large screen
  //  avgX = map(avgX, 0, video.width, 0, width);
  //  avgY = map(avgY, 0, video.height, 0, height);

  //  // Draw a circle at the tracked pixel
  //  ellipse(avgX, avgY, 24, 24);
  //}
  
  //if (counthr > 20) {
  //  hrX = hrX / counthr;  // take the average x position
  //  hrY = hrY / counthr;

  //  // Draw a circle at the tracked pixel in video
  //  strokeWeight(2.0);
  //  noFill();
  //  stroke(0,255,0);
  //  ellipse(hrX, hrY, 24, 24);

  //  // Map to the large screen
  //  hrX = map(hrX, 0, video.width, 0, width);
  //  hrY = map(hrY, 0, video.height, 0, height);

  //  // Draw a circle at the tracked pixel in large screen
  //  ellipse(hrX, hrY, 24, 24);
  //}




  // Add that circle to the positions if drawable
  //if (keyPressed == true && count>0) {
  //  //avgX = map(avgX, 0, video.width, 0, width);
  //  //avgY = map(avgY, 0, video.height, 0, height);

  //  PVector pos = new PVector(avgX, avgY);
  //  positions.add(pos);

  //  // if there is an avg already
  //  if (positions.size() > 1 && sameStroke == true) {
  //    PVector past = new PVector((pastX + avgX)/2, (pastY + avgY)/2);
  //    positions.add(past);

  //    past = new PVector((3*pastX + avgX)/4, (3*pastY + avgY)/4);
  //    positions.add(past);

  //    past = new PVector((pastX + 3*avgX)/4, (pastY + 3*avgY)/4);
  //    positions.add(past);
  //  }

  //  pastX = avgX;
  //  pastY = avgY;
  //  sameStroke = true;
  //} else {
  //  sameStroke = false;
  //  // add a false position
  //  PVector pseudo = new PVector(2000, 2000);
  //  positions.add(pseudo);
  //}
  
  
  //// if both left and right are screen, calculate if they're touching
  //if (count > 20 && counthr > 20){
  //  float p = abs(dist(hrX, hrY, avgX, avgY));
  //  if (p < pthreshold){
  //    print("pinched");
  //    pinching = true;
  //    float pX = (hrX + avgX)/2;
  //    float pY = (hrY + avgY)/2;
      
  //    fill(255);
  //    text("pinched", pX, pY);
  //    //ellipse(pX, pY, 24, 24);
      
      
  //    // Draw the pinching action

  //  if(dist(pX, pY, ballX, ballY) < 100){
  //  ballX = pX;
  //ballY = pY;

  //}
  //  }
  //}
  
  
  //noStroke();
  //fill(255);
  //ellipse(ballX, ballY, 60, 60);


  // Draw the surgery action
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
    if (d < 1000) {

      // reduce jitter somehow



      line(old.x, old.y, pos.x, pos.y);
      //ellipse((old.x + pos.x)/2, (old.y + pos.y)/2, 10, 10);
      //ellipse(pos.x, pos.y, 10, 10);
    }
    //currStroke = d;
  }
}

// distance func
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

// functions
void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  //int loc = video.width-mouseX + mouseY*video.width;
  //trackColor = video.pixels[loc];  // this is inaccurate?

  // Clear canvas
  positions = new ArrayList<PVector>();
}

void displayVideo(){
  video.loadPixels();

  pushMatrix();
  translate(video.width, 0);
  scale(-1, 1);
  image(video, 0, 0, video.width, video.height);
  popMatrix();
}

void trackColor(color trackColor){
  // takes a color to track, draws an ellipse where identified, and returns the count and position of color
  
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
    ellipse(avgX, avgY, 24, 24);

    // Remap to the large screen
    avgX = map(avgX, 0, video.width, 0, width);
    avgY = map(avgY, 0, video.height, 0, height);

    // Draw a circle at the corresponding pixel in large screen
    ellipse(avgX, avgY, 24, 24);
  }
}

void recordIncision(){
  //if (keyPressed == true && count>0) {
  //  //avgX = map(avgX, 0, video.width, 0, width);
  //  //avgY = map(avgY, 0, video.height, 0, height);

  //  PVector pos = new PVector(avgX, avgY);
  //  positions.add(pos);

  //  // if there is an avg already
  //  if (positions.size() > 1 && sameStroke == true) {
  //    PVector past = new PVector((pastX + avgX)/2, (pastY + avgY)/2);
  //    positions.add(past);

  //    past = new PVector((3*pastX + avgX)/4, (3*pastY + avgY)/4);
  //    positions.add(past);

  //    past = new PVector((pastX + 3*avgX)/4, (pastY + 3*avgY)/4);
  //    positions.add(past);
  //  }

  //  pastX = avgX;
  //  pastY = avgY;
  //  sameStroke = true;
  //} else {
  //  sameStroke = false;
  //  // add a false position
  //  PVector pseudo = new PVector(2000, 2000);
  //  positions.add(pseudo);
  //}
}
