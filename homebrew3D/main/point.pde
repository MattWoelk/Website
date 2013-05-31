public class point {
	public double x;
	public double y;
	public double z;
	
	public point(double x, double y, double z){
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public double dist_pt(point p){
		return Math.sqrt(Math.pow(x - p.x,2) + Math.pow(y + p.y,2) + Math.pow(z - p.z,2));
	}
	
	public void draw(){
		//draws it in 2D with 0,0 as origin
		ellipse((float)x,(float)y,2,2);
	}
	
	public void draw_as_vector(){
		//draws it in 2D with 0,0 as origin
		line(0.0,0.0,(float)x,(float)y);
		ellipse((float)x,(float)y,2,2);
	}
	public String toString(){
		return "x: " + x + "y: " + y + "z: " + z;
	}
}