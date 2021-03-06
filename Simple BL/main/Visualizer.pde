class Visualizer {
  PImage fade; 
  float rWidth, rHeight;
  int hVal;

  float bw = 0;
  // The radius of a circle
  float r = 50;

  // The width and height of the boxes (dimensions of the platforms)
  float w = 10;
  float h = 10;
  float d = 10.5;

  Visualizer() {  
    hVal = 0; //hue value
    eRadius = 20;
    rectMode(CORNER); //set rectangles to be drawn from top left corner
  }  

  void drawEQ() {
    pushMatrix(); //saves current context of the operations
    strokeWeight(1);
    // rainbow Effect parameters
    smooth(); //linearly interpolates between color gradient
    colorMode(HSB);// sets color mode value (Hue-Saturation-Brightness or RGB)
    fill(hVal, 255, 255);//cycles through hue and brightness to expose a greater color palete (parameters are H,S,B)
    stroke(hVal, 255, 225);// sets the stroke to cycle through the whole color spectrum (Draws outline of rectangles)
    colorMode(RGB);//sets color mode back to Red green and blue //Resets color setting to RGB

    //for loop for creating the audio bars
    translate(width/2, height-100); //Moves EQ wheel downward from center of the screen
    float arclength = 0; //Arc of the EQ wheel (distance between bars as the EQ wheel rotates)

    //noFill();
    fft.forward(mp3.mix);// used to analyze the frequency coming from the mix 

    for (int i = 0; i < fft.specSize(); i += 50)// specSize is changing the range of analysis (iterates through sound sample returned from fft incrementing by 50 which is the size of each line)
    {
      w = (fft.getFreq(i)*1.1); //width is set to the frequency value 
      // Each box is centered so we move half the width
      arclength += d; //spaces the boxes out at intervals of size distance (d) 

      // Angle in radians is the arclength divided by the radius
      float theta = arclength / r;     

      pushMatrix();
      rotate(-(frameCount * 0.005) + (i*PI/(i*10))); //0.005 is the velocity of rotation, (i*PI/(i*10) ensures the center points are rotating uniformly  
      // Polar to cartesian coordinate conversion
      translate(r*cos(theta), r*sin(theta)); //used to find a point on unit circle
      // Rotate the box
      rotate(theta); //rotates the boxes based on the position of the circle rotation
      rectMode(CENTER); // Draws rectangles from the center points
      rect(0, 0, w, h);  //Initializes boxes to 0, 0

      popMatrix();
      // Move halfway again
      arclength += d/2; //increments the arclength to be drawn to the next segment
    }
    hVal +=1;

    if (hVal > 255)
    {
      hVal = 0;
    }
    noStroke(); //remove outline of the circle
    fill(0);// covers up the center of the circle
    ellipse(0, 0, r*2, r*2); // draws the full circle
    popMatrix();
  }

  void drawBeat() {
    fill(255);
    ellipse(width/2, height-100, 90, 90);
    fill(0);
    ellipse(width/2, height-100, 75, 75);
    //noLoop();
    pushMatrix();
    // rainbow Effect parameters
    smooth();
    rectMode(CORNER);
    colorMode(HSB);// sets color mode value 
    noFill();
    strokeWeight(4);
    //fill(hVal, 255, 255);//cycles through hue and brightness to expose a greater color palete
    stroke(hVal, 255, 225);// sets the stroke to cycle through the whole color spectrum 
    colorMode(RGB);//sets color mode back to Red green and blue 
    beat.detect(mp3.mix);
    float a = map(eRadius, 20, 80, 60, 255);
    if ( beat.isOnset() ) eRadius = 85;
    ellipse(width/2, height-100, eRadius, eRadius);
    eRadius *= 0.95;
    if ( eRadius < 20 ) eRadius = 20;
    popMatrix();
  }
}