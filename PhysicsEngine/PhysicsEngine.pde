// Physics Engine main file

import oscP5.*;
import netP5.*;

OscP5 oscP5;
Animation curAnim;
Animation animIdle, animLeft, animRight, animEat;

Object[] objects = new Object[3];
int score = 0;

int screenWidth = 800;
int screenHeight = 600;

int ground = 500;

int sHeight = 95;
int sWidth = 56;

float gravity = 0.49;
float drag = 1.0;
float speed = 50.0;
float accel = 10.0;

float xPos, xVel;

float urgency = 0.6;

int eatTimer = 0;


void setup() {
  size(800, 600);
  frameRate(24);
  textFont(createFont("Arial", 36));
   
  animIdle = new Animation("idle", 5);
  animLeft = new Animation("left", 5);
  animRight = new Animation("right", 5);
  animEat = new Animation("eat", 5);
  
  curAnim = animIdle;
  
  xPos = (screenWidth / 2) - (sWidth / 2);
  xVel = 0;
  
  for (int i=0; i<3; i++) {
    objects[i] = new Object("sprites/snack.png", screenWidth);
  }
  
  oscP5 = new OscP5(this, 12000);
}


void draw () {
  background(173, 216, 255);
  fill(180,255,120);
  rect(-50, ground, 850, 200);
  
  curAnim.display(xPos, ground - sHeight);
  for (int i=0; i<objects.length; i++) {
    objects[i].display();
  }
  
  fill(0,0,0);
  text(String.format("Score: %s", score), 15, 35);
  
  delay(10);
  
  getKeysPressed();
  checkObjects();
  adjustVelocities();
  
  if (eatTimer > 0) {
    eatTimer--;
  }
}


void oscEvent (OscMessage msg) {
  if (msg.addrPattern().equals("/wek/outputs")) {
    float action = msg.get(0).floatValue();
    urgency = msg.get(1).floatValue();
    
    println(String.format("Received event || C: %s U: %.5s ||", action, urgency));
    
    if (action == 2) {
      move(true);
    } else if (action == 1) {
      move(false);
    } else if (action == 3) {
      pause();
    }
  }
}


void getKeysPressed () {
  if (keyPressed) {
      if (key == '1') {
        move(true);
      } else if (key == '2') {
        move(false);
      } else if (key == '3') {
        pause();
      } else if (key == '4') {
        urgency += 0.2;
        if (urgency > 0.8){
          urgency = 0.8;
        }
      } else if (key == '5') {
        urgency -= 0.2;
        if (urgency < 0.2){
          urgency = 0.2;
        }
      } else if (key == '6') {
        eat();
      }
    }
}


void checkObjects() {
  Object cur;
  for (int i=0; i<objects.length; i++) {
    cur = objects[i];
    cur.adjustVelocities();
    float[] properties = cur.getProperties();
    float x = properties[0];
    float y = properties[1];
    float w = properties[2]; 
    float h = properties[3];
    
    int yPos = ground - sHeight;
    
    if (
      xPos < x + w &&
      yPos < y + h &&
      x < xPos + sWidth &&
      y < yPos + sHeight
    ) {
      eat();
      cur.respawn(screenWidth);
    }
  }
}


void adjustVelocities () {
  xPos += xVel;
  
  if (xVel != 0) {
    xVel += (xVel < 0) ? drag : -drag;
  }
  
  if (xPos < 0) {
    xPos = 0;
    xVel = 0;
  } else if (xPos > screenWidth - sWidth) {
    xPos = screenWidth - sWidth;
    xVel = 0;
  }
  
  if (-drag < xVel && xVel < drag) {
    if (eatTimer == 0) {
      curAnim = animIdle;
    }
    xVel = 0;
  }
}


void move (boolean left) {
  println(String.format("Moving %s, Urgency: %s", (left) ? "Left" : "Right", urgency));
  xVel += (left) ? -accel : accel;
  xVel *= urgency;
  
  if (eatTimer == 0) {
    curAnim = (left) ? animLeft : animRight;
  }
  
  if (xVel > speed) {
    xVel = speed;
  } else if (xVel < -speed) {
    xVel = -speed;
  }
}


void pause () {
  if (xVel > 3 || xVel < -3) {
    xVel = (xVel > 0) ? 3 : -3;
  }
}

void eat() {
  score += 10;
  curAnim = animEat;
  eatTimer = 10;
}
