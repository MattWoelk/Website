float x = 50;
float y = 100;
float angle1 = 0.0;
float angle2 = 0.0;
float segLength = 50;
int xsize = 3;
int ysize = 3;
int mult = 40; //multiplier for display purposes.
int border = 10;
static int[][] displaymatrix; //position of nodes (the matrix that will be displayed constantly


  //this is xsize*ysize by xsize*ysize
 static int[][] testconnect = {{0,1,0,1,0,0,0,0,0},  //connections between the nodes
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
  size((xsize-1)*mult + border*2, (ysize-1)*mult + border*2);
  smooth(); 
  strokeWeight(1.0);
  stroke(0, 100);

  displaymatrix = rndPlacement(xsize, ysize);
  //System.out.println("done");
  System.out.println(does_intersect2(0,0,1,0, 1,0,0,0)); //it works!!
}

void draw() {
  int xpos = 0;
  int ypos = 0;
  
  for(int cur = 0; cur < xsize*ysize; cur++){
    //for each vertex
    
    //find its position in the grid:
    for(int i = 0; i < xsize; i++){
      for(int j = 0; j < ysize; j++){
        if(displaymatrix[i][j] == cur){
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
            if(displaymatrix[i][j] == check){
              line(xpos*mult+border,ypos*mult+border,i*mult+border,j*mult+border);
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

public static Boolean does_intersect(int x11, int y11, int x12, int y12, int x21, int y21, int x22, int y22){
		//case: a 0-length line
		  if((x11 == x12) && (y11 == y12))
		    return false;
		  if((x21 == x22) && (y21 == y22))
		    return false;
		  if(does_connect(displaymatrix[x11][y11],displaymatrix[x12][y12]) && does_connect(displaymatrix[x21][y21],displaymatrix[x22][y22])){
			return does_intersect2(x11, y11, x12, y12, x21, y21, x22, y22);
		  }
		  return false;
	}

//sees if two points(x and y value) intersect.
public static Boolean does_intersect2(int x11, int y11, int x12, int y12, int x21, int y21, int x22, int y22){
  //this function assumes that (x11, y11) to (x12, y12) is a line, and (x21, y21) to (x22, y22) is a line
  double m1 = 0.0; //slope 1
  double m2 = 0.0; //slope 2
  double b1 = 0.0;//offset 1
  double b2 = 0.0;//offset 2
  double x = 0.0; //x value of the intersection point
  double y1 = 0.0;//first y value of the intersection point
  double y2 = 0.0;//second "    "   "   "     "     "    "
  
  /*
  //case: a 0-length line
  if((x11 == x12) && (y11 == y12))
    return false;
  if((x21 == x22) && (y21 == y22))
    return false;
    
  
  if(does_connect(displaymatrix[x11][y11],displaymatrix[x12][y12]) && does_connect(displaymatrix[x21][y21],displaymatrix[x22][y22])){
    */
    //infinite slope if division by zero!!!!!!!!!!!!
    //the fix:
    if(x12 == x11){
      //System.out.println("x12 == x11");
      m1 = 0.00000001; //this number will not ever occur naturally
      b1 = 0.00000001;
    }else{
      m1 = ((double)(y12 - y11))/((double)(x12 - x11)); 
      b1 = (double)y11 - (m1*x11); 
      //System.out.println("m1=" + m1);
      //System.out.println("b1=" + b1);
    }
    if(x22 == x21){
      //System.out.println("x22 == x21");
      m2 = 0.00000001;
      b2 = 0.00000001;
    }else{
      m2 = ((double)(y22 - y21))/((double)(x22 - x21)); 
      b2 = (double)y21 - (m2*x21); 
      //System.out.println("m2=" + m2);
      //System.out.println("b2=" + b2);
    }
    
    if(m1 == m2){
      //System.out.println("m1 == m2");
      if(b1 == b2){
        //we have intersection! (assuming infinite length lines)
        //System.out.println("b1 == b2");
        /*
        //case: --  <-- looks like that
        if((x11 == x21 && y11 == y21)||(x12 == x21)||(x11 == x22)||(x12 == x22))
          return false;
        */
        
        if((x11 < x21 && x11 > x22) || (x11 < x22 && x11 > x21))
        return true;
        if((x12 < x21 && x12 > x22) || (x12 < x22 && x12 > x21))
        return true;
        if((x21 < x11 && x21 > x12) || (x21 < x12 && x21 > x11))
        return true;
        if((x22 < x11 && x22 > x12) || (x22 < x12 && x22 > x11))
        return true;
        
        if((y11 < y21 && y11 > y22) || (y11 < y22 && y11 > y21))
        return true;
        if((y12 < y21 && y12 > y22) || (y12 < y22 && y12 > y21))
        return true;
        if((y21 < y11 && y21 > y12) || (y21 < y12 && y21 > y11))
        return true;
        if((y22 < y11 && y22 > y12) || (y22 < y12 && y22 > y11))
        return true;
        
        
        
        
      }else{
        return false;
      }
      
    }else{
      
      //don't include in same slope case -->>>
      //case: the same point is inputted twice.
      if((x11 == x21) && (y11 == y21))
        return false;
      if((x12 == x22) && (y12 == y22))
        return false;
      if((x11 == x22) && (y11 == y22))
        return false;
      if((x12 == x21) && (y12 == y21))
        return false;
        
    
      //calculate x (the intersection x-value)
      x = ((double)(b2 - b1))/((double)(m1-m2));
      
      y1 = m1*x + b1;
      y2 = m2*x + b2;
      
      if(y1 == y2){
        //we have intersection! (assuming infinite length lines)
        
        //case: if one line starts at the intersection (the it doesn't intersect  |_  <-- like that)
        if((x == x11 && y1 == y11)||(x == x12 && y1 == y12) ||(x == x21 && y1 == y21)||(x == x22 && y1 == y22)){
          return false;
        }
        
        //the '<=' is in case of vertical and horizontal lines
        if( ((x11 <= x && x12 >= x )||(x12 <= x && x11 >= x))&&((y11 <= y1 && y12 >= y1 )||(y12 <= y1 && y11 >= y1)) ){
          if( ((x21 <= x && x22 >= x )||(x22 <= x && x21 >= x))&&((y21 <= y1 && y22 >= y1 )||(y22 <= y1 && y21 >= y1)) ){
            return true;
          }
        }
        
      }else{
        return false;
      }
    }
    //JUST FOR THE CASE OF UNEQUAL SLOPES
    //check bounds (using finite-length lines now)
    
    
    
  //}
  return false;
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


