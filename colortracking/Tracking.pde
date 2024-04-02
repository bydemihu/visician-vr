// houses the video and color tracking-related functions

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

void displayVideo() {
  video.loadPixels();

  pushMatrix();
  translate(video.width, 0);
  scale(-1, 1);
  image(video, 0, 0, video.width, video.height);
  popMatrix();
}

// distance func
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
