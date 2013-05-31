//float x = 50;
//float y = 100;
int curms = 0; //current milliseconds (used for a home-made delay)
static int xsize = 3;
static int ysize = 3;
int mult = 40; //multiplier for display purposes.
int border = 10;
static int[][] displaymatrix; //position of nodes (the matrix that will be displayed constantly
static int[][] curstate;
static int[][] newstate;
int lastTime;
boolean repaint;
int buttx, butty;      // position of button
static double controlparameter = 0.0;
static int totaliterations = 0;
static String s = "";



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

  
  
  
void setup(){
  size((xsize-1)*mult + border*2 + 200, (ysize-1)*mult + border*2 + 200);
  smooth(); 
  strokeWeight(1.0);
  stroke(0, 100);
  lastTime = 0;
  repaint = true;
  controlparameter = 5.0;
  
  buttx = 0;
  butty = 0;

  
  displaymatrix = rndPlacement(xsize, ysize);
  printGrid2(displaymatrix);
  
  //displaymatrix = perfect;
  
  /*displaymatrix = new int[3][3];
  displaymatrix[0][0] = 1;         //this makes the graph like this:
  displaymatrix[1][0] = 0;        //1 0 2
  displaymatrix[2][0] = 2;        //3 4 5
  displaymatrix[0][1] = 3;        //6 7 8
  displaymatrix[1][1] = 4;
  displaymatrix[2][1] = 5;
  displaymatrix[0][2] = 6;
  displaymatrix[1][2] = 7;
  displaymatrix[2][2] = 8;*/
  //printGrid2(displaymatrix);
  //int temp = crossovers(displaymatrix);
  //System.out.println("crossovers: " + temp);
  //System.out.println("crossovers/2: " + temp/2);
  //System.out.println("crossovers/8: " + temp/8);
  //System.out.println("done");
  //System.out.println(does_intersect2(0,0,2,0, 1,0,1,2)); //it works!!
  
 
}




void draw() {
  
  int t = millis();
  if (t - lastTime > 500){
    repaint = !repaint;
    lastTime = t;
    s = "";
    System.out.println("\n\niterant #" + totaliterations);
    s += "\niterant #" + totaliterations + "\n";
    displaymatrix = nextState(displaymatrix);
    printGrid2(displaymatrix);
    totaliterations++;
    if(controlparameter - (1.0/totaliterations + 0.05) > 0){
      controlparameter -= 1.0/totaliterations + 0.05;
    }
    System.out.println("c: " + controlparameter);
    s += "c: " + controlparameter + "\n";
    
    int temp = crossovers(displaymatrix);
  //System.out.println("crossovers: " + temp);
  System.out.println("crossovers: " + temp/2);
  s += "crossovers: " + temp/2 + "\n";
  //System.out.println("crossovers/8: " + temp/8);
  background(226);
  
  //rect(buttx, butty, 10, 10);
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
        //find 'check' in the grid
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
  
  //System.out.println("\nbefore");
  /*while(millis() < curms + 1000){
    System.out.println(millis());
  }*/
  fill(0);
  PFont font;
font = loadFont("CourierNew36.vlw"); 
textFont(font, 12); 
//text(s, (ysize-1)*mult + border*2 + 10, 4, 100, 100);
text(s, 3, (ysize-1)*mult + border*2, 200, 200);
    }
  //System.out.println("after");
  
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
  //from every two vertices to every other two vertices...
  
  //for each element in the grid
  for(int i = 0; i < grid.length*grid[0].length; i++){
    //for each element in the grid... again!
    for(int j = 0; j <= i; j++){
      
      for(int k = 0; k < grid.length*grid[0].length; k++){
        for(int l = 0; l <= k; l++){
          //System.out.println("checking: " +i+j+k+l);
          if(does_intersect(i,j,k,l,grid)){
            //System.out.println(i+","+j+" to "+k+","+l+" intersects.");
            result++;
          }
        }
      }
      
    }
  }
  
  return result;
}

/*
public static int crossovers(int[][] grid){
  int result = 0;
  //from every two vertices to every other two vertices...
  
  //for each element in the grid
  for(int i = 0; i < grid.length*grid[0].length; i++){
    //for each element in the grid... again!
    for(int j = 0; j < grid.length*grid[0].length; j++){
      
      for(int k = 0; k < grid.length*grid[0].length; k++){
        for(int l = 0; l < grid.length*grid[0].length; l++){
          //System.out.println("checking: " +i+j+k+l);
          if(does_intersect(i,j,k,l)){
            //System.out.println(i+","+j+" to "+k+","+l+" intersects.");
            result++;
          }
        }
      }
      
    }
  }
  
  return result;
}

*/


public static Boolean does_intersect2(int x11, int y11, int x12, int y12, int x21, int y21, int x22, int y22, int[][] grid){
		//case: a 0-length line
		  if((x11 == x12) && (y11 == y12))
		    return false;
		  if((x21 == x22) && (y21 == y22))
		    return false;
                //case: make sure that 11 and 12 are connected by lines, and that 21 and 22 are connected by lines
		  if(does_connect(grid[x11][y11],grid[x12][y12]) && does_connect(grid[x21][y21],grid[x22][y22])){
		    return true;
		  }
		   return false;
	}




//this version accepts four indexes (NOT locations)
	public static Boolean does_intersect(int index11, int index12, int index21, int index22, int[][] grid){
		//find where those idexes are in the grid
		int[] poses = new int[8];
		int[] indexes = new int[4];
		indexes[0] = index11;
		indexes[1] = index12;
		indexes[2] = index21;
		indexes[3] = index22;
		
                //for each index, find its x and y locations in the display matrix
		for(int cur = 0; cur < 4; cur++){
			for(int i = 0; i < xsize; i++){
				for(int j = 0; j < ysize; j++){
					if(grid[i][j] == indexes[cur]){
                                                //System.out.println("displaymatrix[" + i + "][" + j + "] == " + indexes[cur]);
						poses[2*cur] = i;
						poses[2*cur + 1] = j;
					}
				}
			}
		}
                //if(index11 == 0 && index12 == 1 && index21 == 3 && index22 == 4){
                  //System.out.println("0,1,3,4: "+poses[0]+","+poses[1]+" "+poses[2]+","+poses[3]+" "+poses[4]+","+poses[5]+" "+poses[6]+","+poses[7]);
                //}
                return does_intersect(poses[0],poses[1],poses[2],poses[3],poses[4],poses[5],poses[6],poses[7], grid);
                //return does_intersect(poses[1],poses[6],poses[4],poses[5],poses[2],poses[3],poses[0],poses[7]);
	}




//sees if two points(x and y value) intersect.
public static Boolean does_intersect(int x11, int y11, int x12, int y12, int x21, int y21, int x22, int y22, int[][] grid){
  //this function assumes that (x11, y11) to (x12, y12) is a line, and (x21, y21) to (x22, y22) is a line
  double m1 = 0.0; //slope 1
  double m2 = 0.0; //slope 2
  double b1 = 0.0;//offset 1
  double b2 = 0.0;//offset 2
  double x = 0.0; //x value of the intersection point
  double y1 = 0.0;//first y value of the intersection point
  double y2 = 0.0;//second "    "   "   "     "     "    "
  
  if(does_intersect2(x11, y11, x12, y12, x21, y21, x22, y22, grid) == false){
    //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
    //System.out.println("1");
    return false;    
  }
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
      b1 = x12;
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("2");
    }else{
      m1 = ((double)(y12 - y11))/((double)(x12 - x11)); 
      b1 = (double)y11 - (m1*x11); 
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("3");
      //System.out.println("m1=" + m1);
      //System.out.println("b1=" + b1);
    }
    if(x22 == x21){
      //System.out.println("x22 == x21");
      m2 = 0.00000001;
      b2 = x22; //now our b value is kind of an x offset. (this is to see if the two lines are on eachother
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("4");
    }else{
      m2 = ((double)(y22 - y21))/((double)(x22 - x21)); 
      b2 = (double)y21 - (m2*x21); 
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("5");
      //System.out.println("m2=" + m2);
      //System.out.println("b2=" + b2);
    }
    
    if(m1 == m2){
      //System.out.println("6");
      //System.out.println("m1 == m2");
      if(b1 == b2){
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("7");
        //we have intersection! (assuming infinite length lines)
        //System.out.println("b1 == b2");
        /*
        //case: --  <-- looks like that
        if((x11 == x21 && y11 == y21)||(x12 == x21)||(x11 == x22)||(x12 == x22))
          return false;
        */
        
        if((x11 < x21 && x11 > x22) || (x11 < x22 && x11 > x21)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
          //System.out.println("8");
        return true;
        }
        if((x12 < x21 && x12 > x22) || (x12 < x22 && x12 > x21)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("9");
        return true;
        }
        if((x21 < x11 && x21 > x12) || (x21 < x12 && x21 > x11)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
       // System.out.println("10");
        return true;
        }
        if((x22 < x11 && x22 > x12) || (x22 < x12 && x22 > x11)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("11");
        return true;
        }
        
        if((y11 < y21 && y11 > y22) || (y11 < y22 && y11 > y21)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("12");
        return true;
        }
        if((y12 < y21 && y12 > y22) || (y12 < y22 && y12 > y21)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("13");
        return true;
        }
        if((y21 < y11 && y21 > y12) || (y21 < y12 && y21 > y11)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("14");
        return true;
        }
        if((y22 < y11 && y22 > y12) || (y22 < y12 && y22 > y11)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("15");
        return true;
        }
        
        
        
        
      }else{
        return false;
      }
      
    }else{
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("16 - dissimilar slopes");
      //don't include in same slope case -->>>
      //case: the same point is inputted twice.
      if((x11 == x21) && (y11 == y21)){
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("17");
        return false;
      }
      if((x12 == x22) && (y12 == y22)){
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("18");
        return false;
      }
      if((x11 == x22) && (y11 == y22)){
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("19");
        return false;
      }
      if((x12 == x21) && (y12 == y21)){
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("20");
        return false;
      }
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("21 - all points are different");
    
      //calculate x (the intersection x-value)
      x = ((double)(b2 - b1))/((double)(m1-m2));
      
      y1 = m1*x + b1;
      y2 = m2*x + b2;
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("y1 = " + Math.ceil(y1*100000));
      //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("y2 = " + Math.ceil(y2*100000));
      
      y1 = (Math.ceil(y1*100000))/100000.0;
      y2 = (Math.ceil(y2*100000))/100000.0;
      
      if(y1 == y2){
        //we have intersection! (assuming infinite length lines)
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("22");
        //case: if one line starts at the intersection (the it doesn't intersect  |_  <-- like that)
        if((x == x11 && y1 == y11)||(x == x12 && y1 == y12) ||(x == x21 && y1 == y21)||(x == x22 && y1 == y22)){
          //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
     // System.out.println("23");
          return false;
        }
        
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
        //System.out.println("x: " + x);
        //the '<=' is in case of vertical and horizontal lines
        if( ((x11 <= x && x12 >= x )||(x12 <= x && x11 >= x))&&((y11 <= y1 && y12 >= y1 )||(y12 <= y1 && y11 >= y1)) ){
          if( ((x21 <= x && x22 >= x )||(x22 <= x && x21 >= x))&&((y21 <= y1 && y22 >= y1 )||(y22 <= y1 && y21 >= y1)) ){
            //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("24");
            return true;
          }
        }
        
      }else{
        //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("25");
        return false;
      }
    }
    //JUST FOR THE CASE OF UNEQUAL SLOPES
    //check bounds (using finite-length lines now)
    //if(x11==2 && y11==0 && x12==0 && y12==1 && x21==0 && y21==0 && x22==1 && y22==1)
      //System.out.println("26");
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

  //printGrid2(rnd);

  return rnd;
}

public static void printGrid2(int[][] grid){
  int iterant = 0;
  for(int i = 0; i < grid.length; i++){
    System.out.print("[");
    s += "[";
    for(int j = 0; j < grid[0].length; j++){
      System.out.print(grid[i][j] + "");
      s += grid[i][j] + "";
      if(j < grid[0].length - 1) 
        System.out.print(",");
        s += ",";
    }
    System.out.print("]\n");
    s += "]\n";
  }
  //System.out.print("\n");
}


public static int[][] perturbation(int[][] grid){
  int[][] perturbated = new int[grid.length][grid[0].length];
  //perturbated = grid;
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[0].length; j++){
      perturbated[i][j] = grid[i][j];
    }
  }
  int swap1x = 0;
  int swap1y = 0;
  int swap2x = 0;
  int swap2y = 0;
  boolean good2go = false;
  int dummy = 0;
  
  //System.out.println("perturbating...");
  
  while(!good2go){
    //randomly switch two vertices around
    swap1x = (int)(Math.random()*grid.length);
    //System.out.println("swap1x: " + swap1x);
    swap1y = (int)(Math.random()*grid[0].length);
    //System.out.println("swap1y: " + swap1y);
    swap2x = (int)(Math.random()*grid.length);
    //System.out.println("swap2x: " + swap2x);
    swap2y = (int)(Math.random()*grid[0].length);
    //System.out.println("swap2y: " + swap2y);
    
    if(swap1x != swap2x && swap1y != swap2y){
      dummy = perturbated[swap1x][swap1y];
      perturbated[swap1x][swap1y] = perturbated[swap2x][swap2y];
      perturbated[swap2x][swap2y] = dummy;
      
      good2go = true;
    }
  }
  return perturbated;
}


public static double calculatecost(int[][] grid){
  double cost = crossovers(grid);
  //System.out.println("calculating cost...");
  return cost;
}


public static int[][] nextState(int[][] curState){
  int[][] newState = new int[curState.length][curState[0].length];
  //System.out.println("calculating new state...");
  newState = perturbation(curState);
  
  //System.out.println("done perturbating.");
  double curcost = 0.0;
  double newcost = 0.0;
  
  curcost = calculatecost(curState);
  System.out.println("curcost: " + curcost);
  s += "curcost: " + curcost + "\n";
  newcost = calculatecost(newState);
  System.out.println("newcost: " + newcost);
  s += "newcost: " + newcost + "\n";
  
  
  if(newcost <= curcost){
    return newState;
  }else{
    
    if(Math.random() <= Math.exp((curcost - newcost)/controlparameter)){
      return newState;
    }else{
      return curState;
    }
  } 

}



