// Class for animating sprites

class Animation {
  private PImage[] images;
  private int imageCount;
  private int frame;
  private int counter;;
  
  Animation(String imagePrefix, int count) {
    counter = 0;
    
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = String.format("sprites/%s/%s%s.png", imagePrefix, imagePrefix, nf(i+1));
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    if (counter == 0) {
      frame = (frame+1) % imageCount;
      counter++;
    } else {
      counter--;
    }
    image(images[frame], xpos, ypos);
  }
}
