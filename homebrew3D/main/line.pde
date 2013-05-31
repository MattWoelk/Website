public class line {
	private point A;
	private point B;
	
	public line(point A, point B){
		this.A = A;
		this.B = B;
	}
	
	public point vector(){
		//returns a vector that points from A to B
		return new point(B.x - A.x, B.y - A.y, B.z - A.z);
	}
	
	public point point(){
		//returns A (a point on the line)
		return A;
	}
	
	public point pt_time(double t){
		point v = vector();
		return new point(A.x + (t*v.x), A.y + (t*v.y), A.z + (t*v.z));
	}
	
	public point int_ln(line ln){
		point v = vector();
		point u = ln.vector();
		
		double x = ((A.x/v.x)-(ln.point().x/u.x))/((1/v.x)-(1/u.x));
		double y = ((A.y/v.y)-(ln.point().y/u.y))/((1/v.y)-(1/u.y));
		double z = ((A.z/v.z)-(ln.point().z/u.z))/((1/v.z)-(1/u.z));
		
		return new point(x,y,z);
	}
	
	public point perp_pt(point p){
		//assumes that the point is not on this line (return an error if it is?)
		
		//returns a vector that points perpendicular to this line going through point p
		//their dot product is zero
		point v = vector();
		double t = (0 - (p.x*A.x) - (p.y*A.y) - (p.z*A.z))/((p.x*v.x) + (p.y*v.y) + (p.z*v.z));
		return new point(A.x + (t*v.x), A.y + (t*v.y), A.z + (t*v.z));
	}
	
	public double dist_pt(point p){
		//returns the distance from this line to point p
		point v = vector();
		
		//vector perp to this going through p:
		point perp = perp_pt(p);
		
		//an arbitrary point on the line described by p and perp_pt(p):
		point r = new point(p.x + (5.1*v.x), p.y + (5.1*v.y), p.z + (5.1*v.z));
		
		//the line perp to this going through p:
		line pline = new line(p,r);
		
		//intersection of this and pline:
		return int_ln(pline).dist_pt(p);
	}
	
	public double t_pt(point p){
		//assumes p is on this line
		//returns the value of t for which this line gives p
		point v = vector();
		return (p.x - A.x)/v.x;
		
		//will have to do some junk for when it's a flat line or vertical, etc...
	}
	
	public boolean on_line(point p){
		//returns true if p lies on this line
		point v = vector();
		double t1 = (p.x - A.x)/v.x;
		double t2 = (p.y - A.y)/v.y;
		double t3 = (p.z - A.z)/v.z;
		if(t1 == t2 && t1 == t3){
			return true;
		}else{
			return false;
		}
	}
	
/*	public point pt_distawayfromptonline(double dist, point p){
		//this function has the worst name probably ever
		//it returns a point that is dist distance away from 
		//point p (which is on this line) on this line
		
		//if +'ve dist is entered, we take the +'ve value from quad eq'n
		//-'ve for -'ve
		
		
	}*/
	
	public void draw(){
		line((float)A.x,(float)A.y,(float)B.x,(float)B.y);
	}
	
	public String toString(){
		return "x = " + A.x + " + t(" + B.x + " - " + A.x + ")\ny = " + A.y + " + t(" + B.y + " - " + A.y + ")";
	}
}


















