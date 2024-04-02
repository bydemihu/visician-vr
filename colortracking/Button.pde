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
    
  }

}

void mousePressed(){
  //Save color where the mouse is clicked in trackColor variable
  if(mouseX < video.width && mouseY < video.height){
  int loc = video.width-mouseX + mouseY*video.width;
  stylusColor = video.pixels[loc]; 
  }
  
  undo();
}
