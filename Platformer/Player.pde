class Player extends AnimatedSprite {
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  Player(PImage img, float scale) {
    super(img, scale);
    lives = 3;
    direction = RIGHT_FACING;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("player_stand_left.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("player_stand_right.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("player_walk_right1.png");
    moveRight[1] = loadImage("player_walk_right2.png");
    jumpLeft = new PImage[1];
    //no jump image provided
    jumpLeft[0] = loadImage("player_walk_left1.png");
    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("player_walk_right1.png");
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("player_walk_left1.png");
    moveLeft[1] = loadImage("player_walk_left2.png");
    currentImages = standRight;
  }

  //Override
  void updateAnimation() {
    index = 0;
    onPlatform = isOnPlatform(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
    if(change_x > 0 && direction == 2){
      index = 0;
    }
  }
  //override
  void selectDirection() {
    if (change_x > 0) {
      direction = RIGHT_FACING;
    } else if (change_x < 0) {
      direction = LEFT_FACING;
    }
  }
  //override
  void selectCurrentImages() {
    if(direction == RIGHT_FACING){
      if(inPlace){
        currentImages = standRight;
      }else if(!onPlatform){
        currentImages = jumpRight;
      }else{
        currentImages = moveRight;
      }
    }
    //left logic
    if(direction == LEFT_FACING){
      if(inPlace){
        currentImages = standLeft;
      }else if(!onPlatform){
        currentImages = jumpLeft;
      }else{
        currentImages = moveLeft;
      }
    }
  }
}
