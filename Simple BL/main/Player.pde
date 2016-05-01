float [] j = new float [50];
float [] k = new float [50];
boolean startOfGame = true;
float gravity = .3;
boolean gameInit = true;
boolean jump;
Ball b;

int bmLevCount ;
int midLevCount;
int highLevCount;
class Ball {
  PVector pos;
  PVector velo;

  int dir;
  int currentPlatform;

  float songSpd;
  float radius;
  //int score;
  int bounceCounter;
  int bonusCap = 20;

  boolean alive;
  int bColor;
  int currentZone = 0;
  int bounceCounts[] = new int[4];

  int lowZoneIdx = 0;
  int midZondIdx = 1;
  int highZoneIdx = 2;



  Ball (float x, float y, float r) {
    pos = new PVector(x, y); //Vec2 of x and y position
    velo = new PVector(0, 0); //Vec2 of x and y velocity
    currentPlatform = 1;
    dir = 1;  
    radius = r;
    alive = true;
    //bColor = (int)(random(1, 3));
    bColor = 1;
    bounceCounter = 0;
    songSpd = 13;

    bounceCounts[0] =0;
    bounceCounts[1] =0;
    bounceCounts[2] =0;
    bounceCounts[3] =0;

    for (int i = 0; i<50; i++) {
      j[i] = -10;
      k[i] = -10;
    }
  }

  void update() {
    pos.y += velo.y;
    pos.x += velo.x;
    //velo.y += gravity;

    if (startOfGame) {
      velo.y = 0;
    } else {
      velo.y += gravity;
    }

    if (grounded()) {
      onGround();
    } else {
      inAir();
    }

    if (BelowDropLine() && !hitFloor) {
      hitFloor = true;
    }

    if (BelowMidLine()) {
      currentZone =0;
    }

    if (AboveMidLine()) {
      currentZone =1;
    }

    if (BelowDropLine()) {
      currentZone = 3;
    }

    if (leftB() || rightB()) {
      gravity = .4;
    }

    if (pos.x < 40) {
      velo.x = 0;
      pos.x = 40;
    } else if (pos.x > 440) {
      velo.x = 0;
      pos.x = 440;
    }

    if (pos.x == 40 || pos.x == 440) {
      gravity = .02;
    }

    if (pos.y > ground+3) {
      pos.y = ground;
    }
  }
  void onGround() {
    if (leftB() && jump) {
      velo.y = -3;
      velo.x = songSpd;
    } else if (rightB() && jump) {
      velo.y = -3;
      velo.x = -songSpd;
    } else {
      velo.y = 0;
      velo.x = 0;
    }
    //gravity = .2;
  }
  void inAir() {
    if (leftB() && jump) {
      if (eRadius >= 52) { 
        velo.y = -.95;
      } else {
        velo.y = 0;
      }
      velo.x = songSpd;
    } else if (rightB() && jump) {
      if (eRadius >= 52) { 
        velo.y = -.95;
      } else {
        velo.y = 0;
      }
      velo.x = -songSpd;
    } 
    //gravity = .3;
    if (pos.y < ceilling && !leftB() && !rightB()) {
     velo.y = 0;
    } 
  }
  void setSongSpeed(float s) {
    songSpd = s;
  }
  Boolean grounded() {
    if (pos.y <= ground+3 && pos.y >= ground-3) return true; //If the ball is between the positions right above and below the "ground"
    return false;
  }
  Boolean leftB() {
    if (pos.x <= left+2 && pos.x >= left-2) return true;
    return false;
  }
  Boolean rightB() {
    if (pos.x <= right+2 && pos.x >= right-2) return true;
    return false;
  }
  boolean TopLine() {
    if (pos.y < ceilling) return true;
    return false;
  }
  boolean BelowMidLine() {
    if (pos.y > middle && pos.y < ground) return true;
    return false;
  }
  boolean AboveMidLine() {
    if (pos.y < middle && pos.y > ceilling) return true;
    return false;
  }
  boolean AboveSafeLine() {
    if (pos.y < safeLine && pos.y > middle) return true;
    return false;
  }
  boolean BelowDropLine() {
    if (pos.y > dropLine) return true;
    return false;
  }

  void render() {
    noStroke();

    noStroke();
    showLastPosition();
    //showTrail();
    noStroke();

    drawPlayer();
  }

  void showLastPosition() {
    if (pos.x == 40 || pos.x == 440) {
      for (int i=0; i<radius; i++) {
        j[i] = pos.x;
        k[i] = pos.y;
        if (!(jump && eRadius >= 52)) {
          fill(255, 1, 1);
        } else {
          fill(100, 255, 100);
        }
        ellipse (j[i], k[i], radius, radius);
      }
    } else {
      for (int i=0; i<radius; i++) {
        j[i] = j [i+1];
        k[i] = k [i+1];
        if (!(jump && eRadius >= 52)) {
          fill(255, 1, 1);
        } else {
          fill(100, 255, 100);
        }
        ellipse (j[i], k[i], i, i);
      }
    }
  }
  void showTrail() {
    for (int i=0; i<radius; i++) {
      j[i] = j [i+1];
      k[i] = k [i+1];
      ellipse (j[i], k[i], i, i);
    }
    j[25] = pos.x;
    k[25] = pos.y;
  }
  void drawPlayer() {
    //draw the player normally
    if (!failing) {
      float rVal = pos.y / height;
      float bVal = 1 - (rVal / 10) ;
      fill(255*rVal, 255, 255*bVal);
    }
    //draw the player with the faded color
    else {
      fill(100, 255, 100, fadeValue);
    }
    ellipse(pos.x, pos.y, radius+1, radius+1);
  }

  void manageScore() {
    if (BelowMidLine()) {
      //score += 10;
      bmLevCount += 10;
    } else if (AboveMidLine()) {
      //score += 30 * bounceCounter;
      //midLevCount += 30 * bounceCounter;
      midLevCount += 30 ;
    } else if (TopLine()) {
      //score += 50 * bounceCounter;
      highLevCount += 50;
    }
  }
  void manageBonusCounter() {
    if (jump && eRadius >= 52 && (pos.x == 40 || pos.x == 440)) {
      noLoop();
      bounceCounter++;
      loop();
    } else {
      bounceCounter = 0;
    }
  }
}