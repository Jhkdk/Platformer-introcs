//declaring the new obejct
Player p;
//images
PImage red_brick, snow, crate, brown_brick, gold, spider, player;
//arrayLists, a different more adjustable array
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
Enemy enemy;
boolean isGameOver;

int numCoins;
//variable that can't be modified
final float MOVE_SPEED = 5;
final float SPRITE_SCALE = 50.0/128;
final float SPRITE_SIZE = 50;
final float GRAVITY = 0.6;
final float JUMP_SPEED = 15;

//how much of the screen is visible at any point
final float RIGHT_MARGIN = 400;
final float LEFT_MARGIN = 60;
final float VERTICAL_MARGIN = 40;
float view_x = 0, view_y = 0;

//what direction is he facing
final int NUETRAL_FACING = 0;
final int RIGHT_FACING = 1;
final int LEFT_FACING = 2;

//spider stuff
final float WIDTH = SPRITE_SIZE * 16;
final float HEIGHT = SPRITE_SIZE * 12;
final float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

//initializing stuff
void setup() {
  size(800, 600);
  imageMode(CENTER);
  //initializing the new object
  //the player size can cause boundary issues
  player = loadImage("player.png");
  p = new Player(player, 0.8);
  p.setBottom(GROUND_LEVEL);
  p.center_x = 100;
  //accessing the variables outside the object
  p.change_x = 0;
  p.change_y = 0;
  numCoins = 0;
  isGameOver = false;
  //initializing the arrayList
  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  //initializing the images
  spider = loadImage("spider_walk_right1.png");
  gold = loadImage("gold1.png");
  red_brick = loadImage("red_brick.png");
  snow = loadImage("snow.png");
  crate = loadImage("crate.png");
  brown_brick = loadImage("brown_brick.png");
  //loading the csv file and using it
  createPlatforms("map.csv");
}
void draw() {
  background(255);
  //needs to be first!!!! otherwise it will draw other stuff in wrong place
  scroll();
  displayAll();
  if(!isGameOver){
    updateAll();
    collectCoins();
  }
}
void collectCoins(){
  ArrayList<Sprite> coin = checkCollisionList(p,coins);
  int num = coin.size();
  numCoins += num;
}
void updateAll(){
  //calling the methods
  p.updateAnimation();
  
  resolvePlatformCollisions(p, platforms);
  enemy.update();
  enemy.updateAnimation();
}
void displayAll(){
  p.display();
  //drawing the csv file
  for (Sprite s : platforms) {
    s.display();
  }
  for(Sprite c : coins){
    c.display();
   ((AnimatedSprite)c).updateAnimation();
  }
  fill(255,0,0);
  textSize(32);
  text("Coins:" + numCoins,view_x+50,view_y+50);
  text("Lives:" + p.lives, view_x+50,view_y+100);
  if(isGameOver){
    fill(0,0,255);
    text("GAME OVER!", view_x + width/2 - 100, view_y + height/2);
    if(p.lives == 0){
      text("you lost!", view_x + width/2 - 100, view_y + height/2 + 100);
    }else{
      text("you won!", view_x + width/2 - 100, view_y + height/2 + 100);
    }
  }
  enemy.display();
}
void scroll() {
  //too far to the right, adjusts camera
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if (p.getRight() > right_boundary) {
    view_x += p.getRight() - right_boundary;
  }
  //too far to the left, adjusts camera
  float left_boundary = view_x + LEFT_MARGIN;
  if (p.getLeft() < left_boundary) {
    view_x -= left_boundary - p.getLeft();
  }
  //you probably fell, adjusts camera
  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if (p.getBottom() > bottom_boundary) {
    view_y += p.getBottom() - bottom_boundary;
  }
  //how did you even get this part to call??
  float top_boundary = view_y + height - VERTICAL_MARGIN;
  if (p.getTop() > top_boundary) {
    view_y -= p.getTop() - top_boundary;
  }
  //moves camera to fit new position
  translate(-view_x, -view_y);
}
//checks if sprite is flying, cause thats a big nono
boolean isOnPlatform(Sprite s, ArrayList<Sprite> walls) {
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  if (col_list.size() > 0) {
    return true;
  } else {
    return false;
  }
}
//updates player location
void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
  //add gravity to change_y
  s.change_y += GRAVITY;
  //move in y-directions
  s.center_y += s.change_y;
  //resolve y-collisions
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  //oh no!!!! someone hit something!!!!!!
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    //are you falling??
    if (s.change_y > 0) {
      //you tripped and fell off a platform. Hah! what a loser
      s.setBottom(collided.getTop());
    } else if (s.change_y < 0) {
      //you jumped too high and hit your head, luckily, there was nothing for the impact to damage
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  //wow a second dimension, who coulda though
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  //this idiot ↓ ran into a wall
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    //are you falling??
    if (s.change_x > 0) {
      //you tripped and fell off a platform. Hah! what a loser
      s.setRight(collided.getLeft());
    } else if (s.change_x < 0) {
      //you jumped too high and hit your head, luckily, there was nothing for the impact to damage
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
}

//checking for collisions
boolean checkCollisions(Sprite s1, Sprite s2) {
  //checking if overlap between two borders
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2. getTop() ||s1.getTop() >= s2.getBottom();
  if (noXOverlap || noYOverlap) {
    return false;
  } else {
    return true;
  }
}
//checking collisions between an object(Player) and a list of objects(obstacles)
ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {
    if (checkCollisions(s, p)) {
      //adding sprites that fail the vibe check to the naughty list
      collision_list.add(p);
    }
  }
  return collision_list;
}
//method that uses the csv file to load and display textures
void createPlatforms(String filename) {
  //loading the csv file into an array where each line is a seperate part of the array
  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++) {
    //seperating each individial value by a ","
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      //deciding what texture based on the number assigned
      if (values[col].equals("1")) {
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("2")) {
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("3")) {
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("4")) {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("5")) {
        Coin c = new Coin(gold, SPRITE_SCALE);
        c.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(c);
      } else if (values[col].equals("6")) {
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        enemy = new Enemy(spider,50/48.0,bLeft,bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
      }
    }
  }
}
//movement starts
void keyPressed() {
  //using a switch statement because it looks nicer
  switch(keyCode) {
  case RIGHT:
    p.change_x = MOVE_SPEED;
    break;
  case LEFT:
    p.change_x = -MOVE_SPEED;
    break;
  case UP:
    //checks if on platform before allowing jumps
    if (isOnPlatform(p, platforms)) {
      p.change_y = -JUMP_SPEED;
    }
    break;
    /*
    This code adds the feature to move downward while in midair, which is weird
     case DOWN:
     p.change_y = MOVE_SPEED;
     break;
     */
  }
}
//resets change to zero to stop movement
void keyReleased() {
  switch(keyCode) {
  case RIGHT:
    p.change_x = 0;
    break;
  case LEFT:
    p.change_x = 0;
    break;
    /*
    This code makes the jumps bumpy
     case UP:
     p.change_y = 0;
     break;
     case DOWN:
     p.change_y = 0;
     break;
     */
  }
}
