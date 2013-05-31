import java.util.ArrayList;


public class Bin {
	ArrayList binData; 
	
	public Bin(){
		binData = new ArrayList();
	}
	
	public void add(int toAdd){
		binData.add(toAdd);
	}
	
	public Boolean contains(int input){
		for(int i = 0; i < binData.size(); i++){
			if((Integer)binData.get(i) == input)
				return true;
		}
		return false;
	}
	
	public int jumps(Bin otherBin, int[][] connections){
		int result = 0;
		//if the non-zero value in (i,j) of connections isn't zero,
		//and j is in otherbin, we add them.
		for(int i = 0; i < binData.size(); i++){
			for(int j = 0; j < connections[0].length; j++){
				if(connections[i][j] != 0 && otherBin.contains(j)){
					result += connections[i][j];
				}
			}
		}
		return result;
	}
	
	public int size(){
		return binData.size();
	}
	
	public String toString(){
		String output = "";
		for (int i = 0; i < binData.size(); i++){
			output += binData.get(i) + " ";
		}
		return output;
	}
	
	
}
