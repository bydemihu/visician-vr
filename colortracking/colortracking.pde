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

// type
PFont articulat_thin;
PFont articulat;
PFont ibm;
PFont ibm_italic;
PFont temp;

// buttons
Button next;
Button done;


// set tracking colors and UI colors
color stylusColor = color(51, 120, 199);
color hingeColorL = color(51, 120, 199);
color hingeColorR = color(103, 170, 110);
color bg = color(24, 32, 39);
color blue = color(68, 149, 238);

// game states
String state = "loading";
// selection, calibration, incision, removal, report

//boolean loading = false;
//boolean selection = false;
//boolean calibration = false;
//boolean incision = true;
//boolean removal = false;
//boolean report = false;

// action states
boolean drawing = false;
boolean pinching = false;

//boolean[] states = {loading, calibration, incision, removal, report, drawing, pinching};

// temp ball to pinch
float ballX = 600;
float ballY = 600;

void setup() {
  //print(PFont.list());
  temp = createFont("Neue Haas Unica Pro", 72);
  ibm = createFont("IBM Plex Mono Light", 24);
  textFont(temp);
  textAlign(CENTER, CENTER);
  
  //size(1280, 720);
  size(1920, 1080);
  //fullScreen();
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  //trackColor = color(51, 120, 199); // track pure white
  
  //setup buttons
  //next = Button(new PVector(width - 100, 20), new PVector(80, 40), blue, "NEXT"); 
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);

  if (state == "loading") {
    // display loading screen
    noStroke();
    fill(255);
    textFont(temp);
    text("VisicianVR", width/2, height/2);
    textFont(ibm);
    text("Web demo for medical simulation controllers", width/2, height/2 + 80);
    
    // set to calibration
    delay(6000);
    state = "calibration";
    print("set to calibration");
    // action
  }

  else if (state == "calibration") {
    displayVideo();
    
    // track stylus
    
    // action
    delay(3000);
    state = "incision";
    print("set to incision");
    // display video
    // track stylus and hinge
  }
  
  else if (state == "incision") {
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
    
    
    
  }
  
  else if (state == "removal") {
    // track hinge
  }
  
  else if (state == "report") {
    // display report
  }


}



// functions





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
