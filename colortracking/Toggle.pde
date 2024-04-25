// houses the Button class and mousePressed interactions

class Toggle {
  PVector pos;
  Boolean state;
  String variable;
  String type;
  PImage img;

  Toggle(PVector pos, Boolean state, String variable, String type) {
    this.pos = pos;
    this.state = state;
    this.variable = variable;
    this.type = type;
  }
  
  Toggle(PVector pos, String type, PImage img) {
    this.pos = pos;
    this.type = type;
    this.img = img;
  }



  void display() {
    if (this.type == "icon"){
      image(this.img, pos.x, pos.y, 60, 60);
    }
    
    else if (this.type == "toggle"){
      strokeWeight(3);
      stroke(blue);
      if (this.state){
        fill(blue);
        rect(pos.x, pos.y, 120, 60, 30);
        
        fill(dark);
        ellipse(pos.x, pos.y + 60, 60, 60);
        
      }
      else{
        fill(dark);
        rect(pos.x, pos.y, 120, 60, 30);
        
        ellipse(pos.x, pos.y, 60, 60);
    
      }
    }
    
    
  }

  boolean hover() {
    if (pos.x < mouseX && mouseX < pos.x + 60 && pos.y < mouseY && mouseY < pos.y + 60) {
      return true;
    } else {
      return false;
    }
  }

}
