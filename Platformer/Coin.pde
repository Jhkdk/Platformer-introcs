class Coin extends AnimatedSprite{
  Coin(PImage img, float scale){
    //inheriting again
    super(img,scale);
    standNeutral = new PImage[6];
    //added extra frames to smooth out the animation
    standNeutral[0] = loadImage("data/Coin/gold1.png");
    standNeutral[1] = loadImage("data/Coin/gold2.png");
    standNeutral[2] = loadImage("data/Coin/gold3.png");
    standNeutral[3] = loadImage("data/Coin/gold4.png");
    standNeutral[4] = loadImage("data/Coin/gold3.png");
    standNeutral[5] = loadImage("data/Coin/gold2.png");
    //only one possible animation
    currentImages = standNeutral;
  }
}
