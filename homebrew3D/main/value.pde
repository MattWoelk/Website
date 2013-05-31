/*the purpose of this is to be a double, but with 
	the option of infinity, infinitessimal, 
	and possibly even fractions
*/

public class value implements Cloneable{
	public double dbl;
	public String str;
	public boolean dblorstr; //false for dbl, true for str.
	
	public value(String str){
		if(str.compareTo("inf") == 0){
			this.str = "inf"; //for infinite
		}else if(str.compareTo("ins") == 0){
			this.str = "ins"; //for infinitessimal
		}else{
			this.str = "und"; //for undefined
		}
		dblorstr = true;
	}
	
	public value(double dbl){
		this.dbl = dbl;
		dblorstr = false;
	}
	
	public boolean eq(value vl){
		return equals(vl);
	}
	
	public boolean equals(value vl){
		if(dblorstr == vl.dblorstr){
			if(!dblorstr && dbl == vl.dbl){
				return true;
			}else if(dblorstr && str.compareTo(vl.str) == 0){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	public value divide(value vl){
		return div(vl);
	}
	
	public value div(value vl){ //divide by
		if(dblorstr == vl.dblorstr){
			if(!dblorstr){
				return new value(dbl/vl.dbl);
			}else if(str.compareTo(vl.str) == 0){
				if(str.compareTo("inf") == 0)
					return new value("inf");
				else if(str.compareTo("ins") == 0)
					return new value("ins");
				else
					return new value("und");
			}else{
				return new value("und");
			}
		}else{
			return new value("und");
		}
	}
	
	public value mult(value vl){
		return mul(vl);
	}
	
	public value multiply(value vl){
		return mul(vl);
	}
	
	public value mul(value vl){ //multiply
		if(dblorstr == vl.dblorstr){
			if(!dblorstr){
				return new value(dbl*vl.dbl);
			}else if(str.compareTo(vl.str) == 0){
				if(str.compareTo("inf") == 0)
					return new value("inf");
				else if(str.compareTo("ins") == 0)
					return new value("ins");
				else
					return new value("und");
			}else{
				return new value("und");
			}
		}else{
			return new value("und");
		}
	}
	
	public value add(value vl){ //multiply
		if(dblorstr == vl.dblorstr){
			if(!dblorstr){
				return new value(dbl+vl.dbl);
			}else if(str.compareTo(vl.str) == 0){
				if(str.compareTo("inf") == 0)
					return new value("inf");
				else if(str.compareTo("ins") == 0)
					return new value("ins");
				else
					return new value("und");
			}else{
				return new value("und");
			}
		}else{
			return new value("und");
		}
	}
	
	public value subtract(value vl){
		return sub(vl);
	}
	
	public value sub(value vl){ //multiply
		if(dblorstr == vl.dblorstr){
			if(!dblorstr){
				return new value(dbl-vl.dbl);
			}else if(str.compareTo(vl.str) == 0){
				if(str.compareTo("inf") == 0)
					return new value("und");
				else if(str.compareTo("ins") == 0)
					return new value("ins");
				else
					return new value("und");
			}else{
				return new value("und");
			}
		}else{
			return new value("und");
		}
	}
	
	public value modulus(value vl){
		return mod(vl);
	}
	
	public value mod(value vl){ //multiply
		if(dblorstr == vl.dblorstr){
			if(!dblorstr){
				return new value(dbl%vl.dbl);
			}else if(str.compareTo(vl.str) == 0){
				if(str.compareTo("inf") == 0)
					return new value("und");
				else if(str.compareTo("ins") == 0)
					return new value("ins");
				else
					return new value("und");
			}else{
				return new value("und");
			}
		}else{
			return new value("und");
		}
	}
	
	public boolean ins(){
		if(str.compareTo("ins") == 0 && dblorstr == true)
			return true;
		else
			return false;
	}
	
	public boolean und(){
		if(str.compareTo("und") == 0 && dblorstr == true)
			return true;
		else
			return false;
	}
	
	public boolean inf(){
		if(str.compareTo("inf") == 0 && dblorstr == true)
			return true;
		else
			return false;
	}
	
	public value clone(){
		try{
			return (value)super.clone();
		}catch(Exception e){
			System.out.println("clone failed!");
			return null;
		}
	}
	
	public String toString(){
		if(!dblorstr)
			return "" + dbl;
		else
			return str;
	}
}