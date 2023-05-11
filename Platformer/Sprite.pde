class Sprite {
  //declaring variables
  PImage img;
  float center_x, center_y;
  float change_x, change_y;
  float w, h;
  //taking in variables
  Sprite(String filename, float scale, float x, float y) {
    //initializing variables
    img = loadImage(filename);
    w = img.width * scale;
    h = img.height * scale;
    center_x = x;
    center_y = y;
    change_x = 0;
    change_y = 0;
  }
  //this is my personal addition to add death to the game
  void isDead() {
    if (center_y > height+1000) {
      exit();
      println("you fell off!!!");
    }
  }
  //overloaded constructor
  Sprite(String filename, float scale) {
    //initializing variables
    this(filename, scale, 0, 0);
  }
  //overloaded constructer to speed up program
  Sprite(PImage img, float scale) {
    this.img = img;
    w = img.width * scale;
    h = img.height * scale;
    change_x = 0;
    change_y = 0;
  }
  //displaying the image
  void display() {
    image(img, center_x, center_y, w, h);
  }
  //updating the image
  void update() {
    center_x += change_x;
    center_y += change_y;
  }
  //getting locations of boundaries
  float getLeft() {
    return center_x - w/2;
  }
  float getRight() {
    return center_x + w/2;
  }
  float getBottom() {
    return center_y + h/2;
  }
  float getTop() {
    return center_y - h/2;
  }
  //setting locations to resolve collisions
  void setLeft(float newLeft) {
    center_x = newLeft + w/2;
  }
  void setRight(float newRight) {
    center_x = newRight - w/2;
  }
  void setBottom(float newBottom) {
    center_y = newBottom - h/2;
  }
  void setTop(float newTop) {
    center_y = newTop + h/2;
  }
}
