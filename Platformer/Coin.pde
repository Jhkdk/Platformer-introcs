class Coin extends AnimatedSprite{
  Coin(PImage img, float scale){
    //inheriting again
    super(img,scale);
    standNeutral = new PImage[6];
    //added extra frames to smooth out the animation
    standNeutral[0] = loadImage("gold1.png");
    standNeutral[1] = loadImage("gold2.png");
    standNeutral[2] = loadImage("gold3.png");
    standNeutral[3] = loadImage("gold4.png");
    standNeutral[4] = loadImage("gold3.png");
    standNeutral[5] = loadImage("gold2.png");
    //only one possible animation
    currentImages = standNeutral;
  }
}
