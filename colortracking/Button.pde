// houses the Button class and mousePressed interactions

class Button {
  PVector pos;
  PVector size;
  color c;
  color ch;
  String t;

  Button(PVector pos, PVector size, color c, String t) {
    this.pos = pos;
    this.size = size;
    this.c = c;
    this.t = t;
  }


  void display() {
    if (this.hover()) {
      fill(brightness(darkclear) + 50);
    } else {
      fill(darkclear);
    }
    
    strokeWeight(3);
    stroke(blue);
    rect(pos.x, pos.y, size.x, size.y, 200);
    textSize(24);
    fill(blue);
    textAlign(CENTER, CENTER);
    text(t, pos.x + size.x / 2, pos.y + size.y /2);
  }

  boolean hover() {
    if (pos.x < mouseX && mouseX < pos.x + size.x && pos.y < mouseY && mouseY < pos.y + size.y) {
      return true;
    } else {
      return false;
    }
  }
}

void mousePressed() {
  // state switcher for next button
  if (next.hover()) {
    if (state == "calibration") {
      
      if (controller == 3  && current == "temp"){
      state = "incision";
      controller = 0;
      }
      
      else if (controller == 3 && current != "temp"){
      state = current;
      controller = 0;
      }
      
      controller += 1;
      //print("set to incision");
    }
    
    else if (state == "incision") {
      state = "removal";
      middle = true;
      //print("set to incision");
    }
    else if (state == "removal") {
      state = "suturing";
      //print("set to incision");
    }
    
    else if (state == "suturing") {
      state = "done";
      //print("set to incision");
    }
    
    else if (state == "done") {
      state = "report";
      //print("set to incision");
    }
    
  }
  
  // start for loading
  if (state == "loading") {
    state = "calibration";
  }

  // color clicker for calibration
  if (state == "calibration") {
    //Save color where the mouse is clicked in trackColor variable
    if (mouseX < video.width && mouseY < video.height) {
      int loc = video.width-mouseX + mouseY*video.width;
      calibrate(controller, loc);
      //stylusColor = video.pixels[loc];
    }
  }

  // undo key for incision
  if (clear.hover()) {
    if (state == "incision") {
      undo();
    }
    else if (state == "removal") {
      cyst = new PVector(1220, 500); // change to default pos!
    }
  }
  
  // settings button
  if (clear.hover()) {
    if (state == "incision") {
      undo();
    }
    else if (state == "removal") {
      cyst = new PVector(900, 900);
    }
  }
  
  // calibrate button
  if (cali.hover()) {
    current = state;
    state = "calibration";
  }
  
  // safety button
  if (safety.hover()){
    safemode = !safemode;  //toggle safemode
  }
  
  
}

void calibrate(int controller, int loc){  // maybe use controller as index to streamline this.
  if (controller == 1){
    stylusColor = video.pixels[loc];
    //BUG FIX THIS LATER TO ALLOW FOR MULTIPLE CAL.
  }
  else if (controller == 2){
    hingeColorL = video.pixels[loc];
  }
  if (controller == 3){
    hingeColorR = video.pixels[loc];
  }
}

void keyPressed() {
  if (key == 'c') {
    state = "calibration";
  }}
