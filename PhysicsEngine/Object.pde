// Class for creating collidable Objects

class Object {
  private PImage img;
  private int oWidth, oHeight;
  private float xPos, yPos, speed;
  
  Object (String fileName, int screenWidth){
    img = loadImage(fileName);
    
    oWidth = img.width;
    oHeight = img.height;
    speed = (float)(Math.random() * 6 + 3);
    
    respawn(screenWidth);
  }
  
  float[] getProperties() { 
    float[] properties = {xPos, yPos, oWidth, oHeight};
    return properties; 
  }
  
  void respawn(int screenWidth) {
    xPos = (float)(Math.random() * screenWidth);
    if (xPos > screenWidth - oWidth) {
      xPos = screenWidth - oWidth;
    } else if (xPos < oWidth) {
      xPos = oWidth;
    }
    yPos = -oHeight;
  }
  
  void adjustVelocities() {
    yPos += speed;
    
    if (yPos > 500 - oHeight) {
      respawn(screenWidth);
    }
  }
  
  void display() {
    image(img, xPos, yPos);
  }
}
