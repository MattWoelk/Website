



private int width;
private int height;
private ArrayList points = new ArrayList();
private ArrayList lines = new ArrayList();

private line testline;
private view testview;

void setup(){
	width = 500;
	height = 500;
	
	size(width,height);
	strokeWeight(1.0);
	stroke(204, 102, 0);
	
	testline = new line(new point(0,0,0),new point(100,200,100));
	testview = new view(0,0,0,0,500,500,new point(0,0,0));
	
	points.add(new point(10,10,10));
	points.add(new point(20,20,20));
	
	lines.add(new line((point)points.get(0),(point)points.get(1)));
	
	
	puts(testview.toString());
	
	puts((new value(800)).equals(new value(800.0)));
}

void draw(){
	background(255);
	stroke(204, 102, 0);
	testline.draw();
	for(int i = 0; i < lines.size(); i++){
		((line)lines.get(i)).draw();
	}
	fill(0);
	stroke(0);
	for(int i = 0; i < points.size(); i++){
		((point)points.get(i)).draw();
	}
}



public static void puts(int str){
	System.out.println(str + "");
}
public static void puts(double str){
	System.out.println(str + "");
}
public static void puts(String str){
	System.out.println(str);
}
public static void puts(boolean str){
	System.out.println(str + "");
}


public static double dot_product(point p1, point p2){
	return (p1.x * p2.x) + (p1.y * p2.y) + (p1.z * p2.z);
}










