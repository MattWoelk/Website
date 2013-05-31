float x = 50;
float y = 100;
float angle1 = 0.0;
float angle2 = 0.0;
float segLength = 50;
int xsize = 3;
int ysize = 3;
int mult = 40; //multiplier for display purposes.
static int[][] thisisfortesting;


  //this is xsize*ysize by xsize*ysize
 static int[][] testconnect = {{0,1,0,1,0,0,0,0,0},
                         {1,0,1,0,1,0,0,0,0},
                         {0,1,0,0,0,1,0,0,0},
                         {1,0,0,0,1,0,1,0,0},
                         {0,1,0,1,0,1,0,1,0},
                         {0,0,1,0,1,0,0,0,1},
                         {0,0,0,1,0,0,0,1,0},
                         {0,0,0,0,1,0,1,0,1},
                         {0,0,0,0,0,1,0,1,0}};
                         
  int[][] perfect = {{0,1,2},{3,4,5},{6,7,8}};

  //Set current = new Set(rndPlacement(xsize, ysize),testconnect);
  
void setup(){
  size(200, 200);
  smooth(); 
  strokeWeight(1.0);
  stroke(0, 100);

  thisisfortesting = rndPlacement(xsize, ysize);
  System.out.println("done");

}

void draw() {
  int xpos = 0;
  int ypos = 0;
  
  for(int cur = 0; cur < xsize*ysize; cur++){
    //for each vertex
    
    //find its position in the grid:
    for(int i = 0; i < xsize; i++){
      for(int j = 0; j < ysize; j++){
        if(thisisfortesting[i][j] == cur){
          xpos = i;
          ypos = j;
        }
      }
    }
      
    //find each one in the grid, and connect it with a line
    for(int check = 0; check < xsize*ysize; check++){
      if(testconnect[cur][check] == 1){
        for(int i = 0; i < xsize; i++){
          for(int j = 0; j < ysize; j++){
            if(thisisfortesting[i][j] == check){
              line(xpos*mult,ypos*mult,i*mult,j*mult);
              //System.out.println(cur + "," + check + " connects to " + i + "," + j);
              //System.out.println(xpos + "," + ypos + " connects to " + i + "," + j);
              
            }
          }
        }
      }
    }
    
  }
}

//takes two indexes and lets you know if they connect
public static Boolean does_connect(int value1, int value2){
  Boolean result = false;
  
  if(testconnect[value1][value2] == 1){
    result = true;
  }
  
  return result;
}

public static int crossovers(int[][] grid){
  int result = 0;
  
  //for each element in the grid
  for(int x1 = 0; x1 < grid.length*grid[0].length; x1++){
    //for each element in the grid... again!
    /////////////////////////////////////////////////////////
  }
  
  return result;
}

//sees if two points(x and y value) intersect.
public static Boolean does_intersect(int x11, int y11, int x12, int y12, int x21, int y21, int x22, int y22){
  Boolean result = false;
  double slope1 = 0.0;
  double slope2 = 0.0;
  double b1 = 0.0;
  double b2 = 0.0;
  if(does_connect(thisisfortesting[x11][y11],thisisfortesting[x12][y12]) && does_connect(thisisfortesting[x21][y21],thisisfortesting[x22][y22])){
    slope1 = ((double)(y12 - y11))/((double)(x12 - x11));
    slope2 = ((double)(y22 - y21))/((double)(x22 - x21));
    b1 = (double)y11 - (slope1*x11);
    b2 = (double)y21 - (slope2*x21);
    
    //if(
    
    
    
  }
  return result;
}

public static int[][] rndPlacement(int x, int y){
  int rnd[][] = new int[x][y];

  //fill rnd with -1's (which will represent unfilled spots)
  for(int i = 0; i < x; i++){
    for(int j = 0; j < y; j++){
      rnd[i][j] = -1;
    }
  }

  int iterant = 0;
  int r1 = 0;
  int r2 = 0;
  //fit x*y numbers into x*y spots
  for(int i = 0; i < x*y; i++){
    r1 = (int) (Math.random()*x);
    r2 = (int) (Math.random()*y);
    if(rnd[r1][r2] == -1){
      rnd[r1][r2] = iterant;
      iterant++;
      //System.out.println(iterant + " is in place");
    }
    else{
      i--;
      //System.out.println("finding a spot for " + iterant);
    }
  }

  printGrid2(rnd);

  return rnd;
}

public static void printGrid2(int[][] grid){
  int iterant = 0;
  for(int i = 0; i < grid.length; i++){
    System.out.print("\n[");
    for(int j = 0; j < grid[0].length; j++){
      System.out.print(grid[i][j] + "");
      if(j < grid[0].length - 1) 
        System.out.print(",");
    }
    System.out.print("]");
  }
  System.out.print("\n");
}


