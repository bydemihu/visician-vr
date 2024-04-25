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
// make calibration doable anytime
// add suturing stage

// imports
import processing.video.*;
Capture video;

// globar vars
color trackColor = color(51, 120, 199);
float threshold = 40;  // color threshold
float pthreshold = 100; // pinch threshold
float lthreshold = 100;  // incision point distance threshold
int b = 20; // border pixel width
ArrayList<PVector> positions = new ArrayList<PVector>();

// type
PFont articulat_thin;
PFont articulat;
PFont cy_grotesk;
PFont inria;
PFont ibm;
PFont ibm_italic;
PFont temp;

// images
PImage loadscreen;
PImage bgscreen;
PImage cystdraw;
PImage cyst1;
PImage cyst2;
PImage cyst3;
PImage cystdraws;
PImage cyst1s;
PImage cyst2s;
PImage cyst3s;
PImage setting_icon;
PImage safety_icon;
PImage calibrate_icon;

// buttons
Button next;
Button clear;
Toggle setting;
Toggle cali;
Toggle safety;


// set tracking colors and UI colors
color stylusColor = color(255, 255, 0);
color hingeColorL = color(0, 255, 0);
color hingeColorR = color(255, 0, 0);
color[] colorlist = {stylusColor, hingeColorL, hingeColorR};
int controller = 1; //1 is stylus, 2 is hingeL, 3 is hingeR
color bg = color(24, 32, 39);
color blue = color(49, 207, 255);
color dark = color(12, 28, 30);
color darkclear = color(12, 28, 30, 60);
color grey = color(200, 216, 219);

// game states
// debug mode!
String state = "loading";
String current = "temp";
// selection, calibration, incision, removal, report

boolean loading = false;
boolean selection = false;
boolean calibration = false;
boolean incision = true;
boolean removal = false;
boolean report = false;
boolean middle = false;
boolean safemode = false;

// action states
boolean drawing = false;
boolean pinching = false;

String[] statelist = {"loading", "calibration", "incision", "removal", "report"};
boolean[] states = {loading, calibration, incision, removal, report, drawing, pinching};
String[] controllist = {"STYLUS", "HINGE 1", "HINGE 2"};

// temp ball to pinch
PVector cyst = new PVector(1220, 500);

void setup() {
  //print(PFont.list());
  cy_grotesk = createFont("cy-grotesk-wide-medium.ttf", 3*b);
  inria = createFont("Inria Sans", b);
  
  //size(1280, 720);
  size(1920, 1080);
  fullScreen();
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  //trackColor = color(51, 120, 199); // track pure white
  
  //setup images
  loadscreen = loadImage("v_loading.png");
  cystdraw = loadImage("cyst.png");
  cyst1 = loadImage("cyst1.png");
  cyst2 = loadImage("cyst2.png");
  cyst3 = loadImage("cyst3.png");
  cystdraws = loadImage("cysts.png");
  cyst1s = loadImage("cyst1s.png");
  cyst2s = loadImage("cyst2s.png");
  cyst3s = loadImage("cyst3s.png");
  safety_icon = loadImage("safety_icon.png");
  setting_icon = loadImage("safety_icon.png");
  calibrate_icon = loadImage("calibrate_icon.png");
  bgscreen = loadImage("v_bg.png");
  
  //setup buttons
  //dimensions of the picture sidebar are 640x480 now 620
  next = new Button(new PVector(2*b + 300, height - 90), new PVector(280, 50), color(0), "NEXT"); 
  clear = new Button(new PVector(2*b, height - 90), new PVector(280, 50), color(0), "CLEAR");
  cali = new Toggle(new PVector(width- 2*b - 60, 2*b), "icon", calibrate_icon);
  safety = new Toggle(new PVector(width- 2*b - 60, 3*b + 60), "icon", safety_icon);
  setting = new Toggle(new PVector(width-b, b), "icon", setting_icon);
  
  
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
    //textFont(cy_grotesk);
    //textAlign(CENTER, CENTER);
    image(loadscreen, 0, 0, width, height);
    //textSize(120);
    //text("VisicianVR", width/2, height/2);
    //textFont(ibm);
    //textSize(30);
    //text("Web demo for medical simulation controllers", width/2, height/2 + 5*b);
  }

  else if (state == "calibration") {
    displayVideo();
    
    // track stylus
    trackColor(stylusColor);
    trackColor(hingeColorL);
    trackColor(hingeColorR);
    
    // draw layout
    drawLayout();
    
    // show instructions
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(cy_grotesk);
    text("Calibration", 2*b, height/2);
    textFont(inria);
    text("1. Hold the stylus controller in view of the camera", 2*b, height/2 + 5*b);
    text("2. Click on the stylus tip to identify it", 2*b, height/2 + 7*b);
    text("3. Ensure the white circle is tracking the stylus tip", 2*b, height/2 + 9*b);
    text("4. Repeat for the hinge controller tips", 2*b, height/2 + 11*b);
    
    textSize(24);
    text("CALIBRATING:" + controllist[controller - 1], 2*b, height - 3.2*b);
    
    // show ui
    next.display();

  }
  
  else if (state == "incision") {
    // draw OR
    if (!safemode){
      image(cyst1, 0, 0, width * 1.1, height * 1.1);
    }
    else{
      image(cyst1s, 0, 0, width * 1.1, height * 1.1);
    }
    
    // display video
    displayVideo();
    
    
    
    
    
    // track stylus
    PVector pos = trackColor(stylusColor);
    //trackColor(hingeColorR);

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
    
    // draw UI
    drawLayout(); 
    safety.display();
    cali.display();
    
    // show instructions
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(cy_grotesk);
    text("Incision", 2*b, height/2);
    textFont(inria);
    text("1. Hold the spacebar to make an incision", 2*b, height/2 + 5*b);
    text("2. Create an elliptical incision over the cyst ", 2*b, height/2 + 7*b);
    text("3. Press [clear] to restart this step", 2*b, height/2 + 9*b);
    
    next.display();
    clear.display();
  }
  
  else if (state == "removal") {
    // draw OR
    if (!safemode){
      image(cyst2, 0, 0, width * 1.1, height * 1.1);
    }
    else{
      image(cyst2s, 0, 0, width * 1.1, height * 1.1);
    }
    
    // display video
    displayVideo();
    
    
    
    // track hinges
    PVector posL = trackColor(hingeColorL);
    PVector posR = trackColor(hingeColorR);
    
    // check if grabbing constantly
    checkHinge(posL, posR);
    
    // draw cyst
    if(pinching){
      PVector pinch = new PVector((posL.x + posR.x)/2, (posL.y + posR.y)/2);
      if (dist(pinch.x, pinch.y, cyst.x, cyst.y) < pthreshold){
        //line(pinch.x, pinch.y, cyst.x, cyst.y);
        cyst.x = pinch.x;
        cyst.y = pinch.y;
        
      cyst = pinch; // only move if distance is close to cyst
      
      }
    }
    
    // draw UI
    drawLayout(); 
    safety.display();
    cali.display(); 
    
    // draw the cyst
    fill(255);
    noStroke();
    imageMode(CENTER);
    image(cystdraw, cyst.x, cyst.y, 90, 90);
    imageMode(CORNER);
    
    
    // show instructions
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(cy_grotesk);
    text("Drainage", 2*b, height/2);
    textFont(inria);
    text("1. Securely pinch and remove the cyst", 2*b, height/2 + 5*b);
    text("2. Place it on the surgical tray", 2*b, height/2 + 7*b);
    text("3. Press [clear] to restart this step", 2*b, height/2 + 9*b);
    
    next.display();
    clear.display();
  }
  
  
  else if (state == "suturing") {
    // draw OR
    if (!safemode){
      image(cyst2, 0, 0, width * 1.1, height * 1.1);
    }
    else{
      image(cyst2s, 0, 0, width * 1.1, height * 1.1);
    }
    
    // display video
    displayVideo();

    // track stylus
    PVector pos = trackColor(stylusColor);
    //trackColor(hingeColorR);

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
    
    // draw UI
    drawLayout(); 
    safety.display();
    cali.display();
    
    // show instructions
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(cy_grotesk);
    text("Suturing", 2*b, height/2);
    textFont(inria);
    text("1. Hold the spacebar to make a stitch", 2*b, height/2 + 5*b);
    text("2. Create horizontal stitches across the incision", 2*b, height/2 + 7*b);
    text("3. Press [clear] to restart this step", 2*b, height/2 + 9*b);
    
    next.display();
    clear.display();
  }
  else if (state == "done") {
    // draw OR
    if (!safemode){
      image(cyst3, 0, 0, width * 1.1, height * 1.1);
    }
    else{
      image(cyst3s, 0, 0, width * 1.1, height * 1.1);
    }
    
    // display video
    displayVideo();

    // draw UI
    drawLayout(); 
    safety.display();
    cali.display();
    
    // show instructions
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(cy_grotesk);
    text("Cleaning", 2*b, height/2);
    textFont(inria);
    text("1. Double-check the sutures and press [next] when done", 2*b, height/2 + 5*b);

    
    next.display();
    clear.display();
    }
  else if (state == "report") {
    image(bgscreen, 0, 0, width, height);
    
    textFont(cy_grotesk);
    textAlign(CENTER, CENTER);
    textSize(120);
    fill(255);
    text("Procedure Completed", width/2, height/2);
    textFont(inria);
    textSize(30);
    text("Procedure: Sebaceous cyst excision      Score: 85/100", width/2, height/2 + 5*b);
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
    //fill(255, 0, 0);
    //noStroke();
    PVector old = positions.get(i-1);
    PVector pos = positions.get(i);

    float d = abs(dist(old.x, old.y, pos.x, pos.y)); // base size 20, dist affects it
    //ellipse(pos.x, pos.y, 12, 12);

    //blendMode(MULTIPLY);
    
    if (d < lthreshold) {
      // reduce jitter somehow
      push();
      strokeCap(ROUND);
      stroke(142, 18, 16, 30);
      strokeWeight(20);
      //line(old.x, old.y, pos.x, pos.y);
      stroke(204, 42, 11);
      strokeWeight(10);
      line(old.x, old.y, pos.x, pos.y);
      pop();
      //ellipse((old.x + pos.x)/2, (old.y + pos.y)/2, 10, 10);
      //ellipse(pos.x, pos.y, 10, 10);
    }
  }
}

void undo() {
  positions = new ArrayList<PVector>();
}

void drawLayout(){
  // order of drawing:
  // canvas, drawing, video, tracking, layout, text, ui
  
  // black border
  fill(dark);
  noStroke();
  rect(0, 0, width, 20);
  rect(0, 0, 20, height);
  rect(width-20, 0, 20, height);
  rect(0, height-20, width, 20);
  //rect(b, 480, 620, height-480);
  
  noFill();
  strokeWeight(3);
  stroke(blue);
  rect(b, b, 620, height-2*b, 30);
  
  //noFill();
  //stroke(255);
  //strokeWeight(3);
  //rect(b, b, 620, 460);
  //rect(b, 480, 620, 100);
  //rect(b, 580, 620, height-580-b);
  //rect(b, b, width- 2*b, height- 2*b);
}

void checkHinge(PVector posL, PVector posR){
  if( dist(posL.x, posL.y, posR.x, posR.y) < pthreshold){
    if (posL.x > 0 && posL.y > 0 && posR.x > 0 && posR.y > 0){  //make sure ctrls are actually detected
      // is pinching
    pinching = true;
    //line(posL.x, posL.y, posR.x, posR.y);
    //text("pinching", 800, 100);
    }
    
  }
  else{
    pinching = false;
  }
}
