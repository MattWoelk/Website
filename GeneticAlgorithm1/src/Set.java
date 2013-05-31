import java.util.ArrayList;


public class Set {
	ArrayList binData; 
	int[][] connections;
	
	public Set(int[][] connections){
		binData = new ArrayList();
		this.connections = connections;
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
	
	public Bin separateBin0(){
		Bin bin = new Bin();
		
		for(int i = 0; i < binData.size(); i++){
			if((Integer)binData.get(i) == 0){
				bin.add(i);
			}
		}
		return bin;
	}
	
	public Bin separateBin1(){
		Bin bin = new Bin();
		
		for(int i = 0; i < binData.size(); i++){
			if((Integer)binData.get(i) != 0){
				bin.add(i);
			}
		}
		return bin;
	}
	//swaps swapData in at binData[bottom] to binData[top]
	public void replace(int bottom, int top, int[] swapData){
		for(int i = 0; i < swapData.length; i++){
			binData.set(bottom + i, swapData[i]);
		}
	}
	
	//this mutates 'mutations' amount of bits in the file.
	public void mutate(int mutations){
		int rnd;
		for(int i = 0; i < mutations; i++){
			rnd = (int)Math.random()*binData.size();
			binData.set( rnd, invert((Integer)(binData.get(rnd))) );
		}
	}
	
	public int invert(int i){
		if(i == 0){
			return 1;
		}
		else{
			return 0;
		}
	}
	
	public int get(int i){
		return (Integer)binData.get(i);
	}
	
	//takes data from binData[bottom] to binData[top]
	//NOT INCLUDING binData[top]
	public int[] get(int bottom, int top){
		int data[] = new int[top - bottom];
				
		for(int i = 0; i < (top - bottom); i++){
			data[i] = (Integer) binData.get(i + bottom);
		}
		
		
		return data;
	}
	
	//this will set all values to 0
	//with the same amount of values that are in connections[0]
	public void empty(int length){
		binData = new ArrayList();
		for(int i = 0; i < length; i++){
			binData.add(0);
		}
	}
	
	public void ones(int length){
		binData = new ArrayList();
		for(int i = 0; i < length; i++){
			binData.add(1);
		}
	}
	
	public int size(){
		return binData.size();
	}
	
	public double cost(){
		double result = 0;
		
		result = (double)jumps()/size() + Math.abs(separateBin0().size() - separateBin1().size())*0.12;
		// PARAMETER
		
		//System.out.println("Cost: " + result);
		return result;
	}
	
	public int jumps(int[][] connections){
		int result = 0;
		result = (this.separateBin0()).jumps(this.separateBin1(), connections);
		return result;
	}
	
	
	public int jumps(){
		int result = this.separateBin1().jumps(this.separateBin0(), connections);
		return result;
	}
	
	public String toString(){
		String output = "";
		for (int i = 0; i < binData.size(); i++){
			output += "" + binData.get(i);
		}
		return output;
	}
	
	
}
