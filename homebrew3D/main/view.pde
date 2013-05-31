/*the point of this is to hold the information for 
	the plane that the view sees through
	
	this uses the general equation of the plane
	format:
	ax + by + cz + d = 0
	*/

public class view {
	public double a;
	public double b;
	public double c;
	public double d;
	public int width;
	public int height;
	public point centre;
	
	public line top;
	public line bottom;
	public line left;
	public line right;
	
	public view(double a, double b, double c, double d, int width, int height, point centre){
		//maybe four corners should be given instead? (three pionts?)
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.width = width;
		this.height = height;
		this.centre = centre;
		
		top = top();
		bottom = bottom();
		////////////////////////INCOMPLETE
	}
	
	public String toString(){
		return a + "x + " + b + "y + " + c + "z + " + d + " = 0";
	}
	
	public point norm(){
		return new point(a,b,c);
	}
	
	public point unitnorm(){
		double distance = Math.sqrt(Math.pow(a,2) + Math.pow(b,2) + Math.pow(c,2));
		return new point(a/distance, b/distance, c/distance);
	}
	
	public double getz(double x, double y){
		//give it two coords and it will give you the third
		return (0 - d - (b * y) - (a * x))/c;
	}
	
	public double gety(double x, double z){
		//give it two coords and it will give you the third
		return (0 - d - (c * z) - (a * x))/b;
	}
	
	public double getx(double y, double z){
		//give it two coords and it will give you the third
		return (0 - d - (b * y) - (c * z))/a;
	}
	
/*	public boolean canseepoint(point p){
		//returns true if the point will be seen in this view
		return false;
	}*/
	
	public Point point_on_plane(point p){
		//gives the 2D coord of where the point p maps onto the plane expressed by the view.
		//plane equation: ax+by+cz+d=0
		//line equation: x = at + p.x; y = bt + p.y; z = ct + p.z
		//put together and solve for t:
		//this gives the intersection between a plane and a line.
		double t = (0.0 - d - (a*p.x) - (b*p.y) - (c*p.z))/(Math.pow(a,2) + Math.pow(b,2) + Math.pow(c,2));
		//intersection is the point on the plane where the line parallel to the normal and the plane meet.
		point intersection = new point(a*t + p.x, b*t + p.y, b*t + p.z);
		return coord_in_2D(intersection);
	}
	
	public Point coord_in_2D(point p){
		//returns the 2D Point where the point p maps to the view's plane
		int left = (int)(coord_in_2D(centre).x - (width/2));
		int right = (int)(coord_in_2D(centre).x + (width/2));
		int top = (int)(coord_in_2D(centre).y + (height/2));
		int bottom = (int)(coord_in_2D(centre).y - (height/2));
		
		
		return new Point(2,2);
	}
	
	public boolean is_within_plane(Point p, int left, int right, int top, int bottom){
		//this assumes that 'roll' is not allowed.
		boolean result = false;
		
		
		if(p.x < left || p.x > right || p.y < bottom || p.y > top){
			return false;
		}else{
			return true;
		}
	}
	
	public line top(){
		//calculates the line that expressed the top of the view.
		//z1 & z2 = a value.
		double z = centre.z - (height/2);
		return new line(new point(0,gety(0,z),z),new point(1,gety(1,z),z));
	}
	
	public line bottom(){
		//see 'top'
		double z = centre.z - (height/2);
		return new line(new point(0,gety(0,z),z),new point(1,gety(1,z),z));
	}
	
	public point bottom_mid(){
		//used so that we can find distance from this point to width/2 away
		//from it on the line bottom.
		return bottom.perp_pt(centre);
	}
	

	
}






