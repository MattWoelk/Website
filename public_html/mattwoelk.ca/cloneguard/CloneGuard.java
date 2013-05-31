import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class CloneGuard extends PApplet {

PImage sprite;
PImage spriteMan[];
int spriteHeight;
int spriteWidth;

//MOVEMENT
int xpos;
int ypos;
int xsp; //current speed in the x direction.
int XVELOCITY; //the starting walk speed.
boolean facingLeft; //ISSUE: 

//SHOOTING
Shot shots[];
int shotcount;
int MAXSHOTS;
int shotTimer;

//JUMPING
boolean jumping;  //indicates whether the character is in the air or not.
int JUMPVELOCITY; //the starting speed of the jump
double jumpspeed; //the current speed of vertical movement

//INPUT
boolean keys[]; //I'd love to use hashes instead.

//LEVEL
Level level;

public void setup(){
  size(600,400);

  //SPRITE
  sprite = loadImage("images/1.png");
  spriteMan = new PImage[4];
  for(int i = 0; i < 4; i+=2){
    spriteMan[i] = loadImage("images/a" + i + ".png");
    spriteMan[i+1] = loadImage("images/a" + i + "b.png");
  }
  spriteHeight = 40;
  spriteWidth = 40;

  xpos = 401;
  ypos = 201;
  xsp = 0;
  XVELOCITY = 5; 

  facingLeft = true;

  //INPUT
  keys = new boolean[4];
  for(int i = 0; i < 4; i++){
    keys[i] = false;
  }
  
  //SHOOTING
  MAXSHOTS = 30;
  shots = new Shot[MAXSHOTS];
  shotcount = 0;
  for(int i = 0; i < MAXSHOTS; i++){
    shots[i] = new Shot();
  }
  shotTimer = 100;
  
  //JUMPING
  jumping = true;
  JUMPVELOCITY = -10;
  jumpspeed = 0;
  
  //LEVEL
  level = new Level(0);
}


public void draw(){
  if(xsp > 0)
    facingLeft = false;
  else if (xsp < 0)
    facingLeft = true;

  background(000);
  level.paint();
  fill(255);
  rect(xpos,ypos,spriteWidth,spriteHeight);
  
  drawSprite();

  //WALKING AND SIDE COLLISION
  if((keys[0] || keys[1]) && isNotWall(xpos + xsp,ypos)){
    xpos += xsp;
  }

  //JUMPING AND GROUND AND CEILING COLLISION
  if(jumping)
    jumpspeed += 0.5f;//0.5
  
  if(groundCollision(xpos,ypos)){
    ypos = level.roundUpToBlockTop((int)(ypos + jumpspeed + spriteHeight)) - spriteHeight;
    jumpspeed = 0;
    jumping = false;
  }else if(ceilingCollision(xpos,ypos)){
    System.out.println("ceiling collision. speed: " + jumpspeed);
    ypos = level.roundUpToBlockTop((int)(ypos + jumpspeed + spriteHeight));
    jumpspeed = 0;
  }else{
    jumping = true;
    ypos += jumpspeed;
  }
  
  //SHOOTING
  for(int i = 0; i < MAXSHOTS; i++){
    shots[i].paint();
  }
  if (keys[2]){
    shotTimer++;
    if (shotTimer > 9){
      shotTimer = 0;
      shoot();
    }
  }
}


public void keyPressed(){
  char k = (char)key;
  switch(k){
  case 'j':
    if(!keys[0]){
      xsp -= XVELOCITY;
    }
    keys[0] = true;
    break;
  case 'l':
    if(!keys[1]){
      xsp += XVELOCITY;
    }
    keys[1] = true;
    break;
  case 'x':
    if(!keys[2])
      keys[2] = true;
    break;
  case 'z':
    if(!keys[3]){
      //jumping = true;
      jump();
    }
    keys[3] = true;
    break;
  default:
    break;
  }
}


public void keyReleased(){
  char k = (char)key;
  switch(k){
  case 'j':
    if(keys[0])
      xsp += XVELOCITY;
    keys[0] = false;
    break;
  case 'l':
    if(keys[1])
      xsp -= XVELOCITY;
    keys[1] = false;
    break;
  case 'x':
    if (keys[2] = true){
      keys[2] = false;
      shotTimer = 10;
    }
    break;
  case 'z':
    if(keys[3])
    keys[3] = false;
    break;
  default:
    break;
  }
}


public void shoot(){
  shots[shotcount].set(xpos,ypos + (int)(spriteHeight/2),true);
  if(!facingLeft){
    shots[shotcount].shootRight(); //sets direction of shot.
    shots[shotcount].x += (int)spriteWidth/2;
  }else{
    shots[shotcount].shootLeft();
    shots[shotcount].x -= (int)spriteWidth/2;
  }
  shotcount = (shotcount + 1) % MAXSHOTS;
}


public void jump(){
  if(!jumping){
    jumping = true;
    jumpspeed = JUMPVELOCITY;
  }
}

public boolean isNotWall(int x, int y){
  return !level.isSolidBlock((int)(Math.signum(xsp)*spriteWidth/2 + spriteWidth/2) + x,y + spriteHeight -1);
}

public boolean groundCollision(double x, double y){
  //checks left and right points of sprite
  return level.isSolidBlock(x,y + jumpspeed + spriteHeight) || 
      level.isSolidBlock(x + spriteWidth,y + jumpspeed + spriteHeight);
}

public boolean ceilingCollision(double x, double y){
  return level.isSolidBlock(x,y + jumpspeed) || 
      level.isSolidBlock(x + spriteWidth,y + jumpspeed);
}
  
public void drawSprite(){
  if(facingLeft && jumping)
    image(spriteMan[2], xpos, ypos,spriteWidth,spriteHeight);
  if(facingLeft && !jumping)
    image(spriteMan[0], xpos, ypos,spriteWidth,spriteHeight);
  if(!facingLeft && jumping)
    image(spriteMan[3], xpos,ypos,spriteWidth,spriteHeight);
  if(!facingLeft && !jumping)
    image(spriteMan[1], xpos,ypos,spriteWidth,spriteHeight);
}
public class Level{
  String lines[];
  char blocks[][]; 
  int BLOCKSIZE;
  int sizes[]; //numbers of blocks in each row.
  int blength; //number of blocks horizontal.
  
  public Level(int num){
    BLOCKSIZE = 60;
    blocks = new char[100][20];

    load(num);
  }
  
  public void load(int num){
    lines = loadStrings("level" + num + ".txt");
    for(int i = 0; i < lines.length; i++){
      char temp[] = new char[100];
      for(int j = 0; j < lines[i].length(); j++){
        //NB: X AND Y ARE BACKWARDS...........
        blocks[j][i] = lines[i].charAt(j);
      }
    }
    blength = blocks.length;
    sizes = new int[blength];
    for(int i = 0; i < blength; i++){
      sizes[i] = blocks[i].length;
    }
  }
  
  public void paint(){
    int blength = blocks.length;
    //IMP: only draw what's on-screen?
    for(int i = 0; i < blength; i++){
      for(int j = 0; j < sizes[i]; j++){
        if(blocks[i][j] == '-'){
          fill(255);
        }else if(blocks[i][j] == 'x'){
          fill(100);
        }else
          fill(0);
        rect(i*BLOCKSIZE,j*BLOCKSIZE,BLOCKSIZE,BLOCKSIZE);
      }
    }
  }
  
  //to see if the x,y point is within a block. 
  public boolean isSolidBlock(double x, double y){
    //NB: (this will have to be changed if ever the character is falling REALLY fast)
    return blocks[floor((float)x/BLOCKSIZE)][floor((float)y/BLOCKSIZE)] == 'x';
  }
  
  public int roundUpToBlockTop(int y){
    return floor(y/BLOCKSIZE)*BLOCKSIZE;
  }
}
public class Shot{
  boolean active;
  public int x;
  public int y;
  int SPEED;
  PImage img;
  
  public Shot(){
    x = 0;
    y = 0;
    SPEED = -8;
    img = loadImage("images/peew.png");
  }

  public void shootRight(){
    SPEED = Math.abs(SPEED);
  }

  public void shootLeft(){
    SPEED = -1 * Math.abs(SPEED);
  }

  public void paint(){
    if(active){
      x += SPEED;
      image(img, x,y);
    } 

    //if walls are everywhere, make this so it only dies when it hits a wall.
    if(x < -60 || x > width)
      active = false;
  }

  public void set(int x, int y, boolean active){
    this.x = x;
    this.y = y;
    this.active = active;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "CloneGuard" });
  }
}
