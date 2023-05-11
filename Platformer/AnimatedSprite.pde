//can take all variables from Sprite object
class AnimatedSprite extends Sprite {
  //current animation
  PImage[] currentImages;
  //possible animations
  PImage[] standNeutral;
  PImage[] moveLeft;
  PImage[] moveRight;
  //determine what animation and what part of the animation
  int direction;
  int index;
  int frame;
  AnimatedSprite(PImage img, float scale) {
    //creates a sprite and pulls the variables into this object
    super(img, scale);
    direction = NUETRAL_FACING;
    index = 0;
    frame = 0;
  }
  //updates animation to play the right animation
  void updateAnimation() {
    frame++;
    //slows animation
    if (frame % 5 == 0) {
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
      frame = 0;
    }
  }
  //determines direction
  void selectDirection() {
    if (change_x > 0) {
      direction = RIGHT_FACING;
    } else if (change_x < 0) {
      direction = LEFT_FACING;
    } else {
      direction = NUETRAL_FACING;
    }
  }
  void selectCurrentImages() {
    //Switch statements still look more organized
    switch(direction) {
    case RIGHT_FACING:
      currentImages = moveRight;
      break;
    case LEFT_FACING:
      currentImages = moveLeft;
      break;
    case NUETRAL_FACING:
      currentImages = standNeutral;
      break;
    }
  }
  void advanceToNextImage() {
    index++;
    if(index == currentImages.length){
      index = 0;
    }
    img = currentImages[index];
  }
}
