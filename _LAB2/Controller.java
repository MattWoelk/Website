import java.util.Arrays;

//a bin is size/2 ± 1 components.
//	 bin contents example: 1, 3, 5, 8, 10, 14
//a set is two bins (contains all the data for those bins, but not Bin objects).
//	 set contents example: 010110100101011
//a state is popSize sets.


public class Controller {
	public static void main(String[] args) {
		long timeStart, timeEnd;
		timeStart = System.currentTimeMillis();
		
		int size = 30;    //PARAMETER
		int popSize = 20; //number of sets for each State (MUST BE EVEN) 
		//PARAMETER
		
		int connections[][]; //tells us which component connects to which other
		Set curState[] = new Set[popSize]; //the sets in the current State		
		
		
		//connections = fillTestConnections(20);
		connections = fillRndConnections(size);
		
		//set first state.
		curState = fillRndState(popSize, connections);
		curState = sortState(curState, connections);
		
		iterate(500, curState, connections, popSize); //PARAMETER
		
		timeEnd = System.currentTimeMillis();
		timeEnd = timeEnd - timeStart;
		System.out.println("Total time: " + timeEnd);
	}
	
	
	public static void iterate(int times, Set[] curState, int[][] connections, int popSize){
		Set oldState[] = curState;
		Set newState[] = new Set[popSize];
		for(int thisMany = 0; thisMany < times; thisMany++){
			newState = new Set[popSize];
			for(int i = 0; i < popSize; i++){
				newState[i] = new Set(connections);
				newState[i].empty(oldState[0].size());
			}
			newState = getNextState(oldState, connections, thisMany);
			
			printTotalCost(newState);
			
			oldState = newState;
			
		}
		//--finish line--
		System.out.println();
		System.out.println("final Cost: " + totalCost(newState));
		System.out.println("final best structure: ");
		printChart(newState[0], connections);
	}
	
	
	
	public static Set[] getNextState(Set[] curSet, int[][] connections, int current){
		//we assume that the state is sorted already.
		Set newSet[] = new Set[curSet.length];
		Set dummy[] = new Set[2];
		int choice1, choice2;
		int probArray[] = getProbArray(curSet);
		
		for(int i = 0; i < curSet.length; i++){
			newSet[i] = new Set(connections);
			newSet[i].empty(curSet[0].size());
		}
		
		//copy over the two best (assumed to be sorted already)
		newSet[0] = curSet[0];
		newSet[1] = curSet[1];
		
		for(int i = 0; i < (curSet.length - 2)/2; i++){
			//this assumes that we have an even number of sets in each state.
			
			//pick which two to swap:
			choice1 = probArray[(int) (Math.random()*probArray.length)]; //PARAMETER
			choice2 = probArray[(int) (Math.random()*probArray.length)]; //PARAMETER
			//swap them:  (or splice them)
			dummy = swap(curSet[choice1], curSet[choice2], connections);
			//mutate them:
			dummy[0].mutate((int)0.002*current + 1); //PARAMETER
			dummy[1].mutate((int)0.002*current + 1); //PARAMETER
			//insert them:
			newSet[2*(i+1)] = dummy[0];
			newSet[2*(i+1)+1] = dummy[1];
		}
		
		
		return newSet;
	}
	
	
	public static int[] getProbArray(Set[] curSet){
		//this assumes that the current set is already sorted.
		double probArray[] = new double[curSet.length];
		double totalAssigned = 0.0; 
		/*
		for(int i = 0; i < curSet.length; i++){
			totalAssigned += i;
		}*/
		for(int i = 0; i < curSet.length; i++){
			//this sets the highest probability to [0], etc.
			probArray[i] = (curSet.length - i);///totalAssigned; 
		}
		//it will look like (5, 4, 3, 2, 1);
		//System.out.print("\nProbArray length: " + probArray.length + "\ndata:");
		/*for(int i = 0; i < probArray.length; i++){
			System.out.print((int)probArray[i] + ",");
		}*/
		
		int length = curSet.length;
		int numberOfPieces = (int) (length*(.5 + (length*.5)));
		int newArray[] = new int[numberOfPieces];
		int counter = 0; //iterates through probArray;
		int times = 0; //gets amount of occurrences from probArray;
		
		/*
		for(int i = 0; i < length; i++){
			times = (int) probArray[counter];
			if (times < counter){
				newArray[i] = counter;
				times++;
			}else{
				i--;
				counter++;
				times = 0;
			}
			
		}
		*/
		//double for instead:
		for(int i = 0; i < probArray.length; i++){ //for every unique value in probArray;
			for(int j = 0; j < (int)probArray[i]; j++){ //for the amount
				//EX: 5 times, it will put 0 in the array;
				newArray[counter] = i;
				counter++;
			}
		}
		
		
		//System.out.print("\nNewArray length: " + newArray.length + "\ndata:");
		/*for(int i = 0; i < newArray.length; i++){
			System.out.print((int)newArray[i] + ",");
		}*/
		//System.out.print("\n");
		return newArray;
		//it ends up looking like this:
		//(0,0,0,0,0,1,1,1,1,2,2,2,3,3,4);
		
		/*
		for(int i = 0; i < curSet.length; i++){
			probArray[i] = probArray[i]/totalCost(curSet);
		}
		
		double test = 0.0;
		for(int i = 0; i < curSet.length; i++){
			test += probArray[i];
		}
		System.out.println("this should be one: " + test);
		*/
		//return probArray;
	}


	public static Set[] sortState(Set[] state, int[][] connections){
		//organizes the Stage so that Sets go from best (0) to worst (size).
		Set dummy = new Set(connections);
		
		//this will be a nice selection sort. yummy.
		Arrays.sort(state, new SetComparator());
		
		int testTest[] = new int[state.length];
		testTest = stateCosts(state, connections);
		/*System.out.println("\nthe order from 0 to size:");
		for(int i = 0; i < testTest.length; i++){
			System.out.println("" + testTest[i]);
		}*/
		
		return state;
	}
	
	public static Set[] swap(Set set0, Set set1, int[][] connections){
		Set[] result = new Set[2];
		int pivot = 0;
		Set dummy0 = new Set(connections);
		Set dummy1 = new Set(connections);
		pivot = (int)(Math.random()*set0.size());  //sets a random pivot
		
		dummy0.empty(set0.size());
		dummy1.empty(set0.size());
		
		//System.out.println(dummy0.size() + " " + dummy1.size());
		//System.out.println(pivot);
		
		
		dummy0.replace(0, pivot, set1.get(0, pivot));
		dummy0.replace(pivot, dummy1.size(), set0.get(pivot, dummy1.size()));
		
		dummy1.replace(0, pivot, set0.get(0, pivot));
		dummy1.replace(pivot, dummy1.size(), set1.get(pivot, dummy1.size()));
		
		result[0] = dummy0;
		result[1] = dummy1;
		
		return result;
	}
	
	public static int[][] fillRndConnections(int size){
		//generates random connections between 0 and 9;
		int data[][] = new int[size][size];
		int position = 0;
		int rnd = 0;
		
		for (int i = 0; i < size; i++){
			for (int j = 0; j < size; j++){ //this is inefficient (goes over twice) but it works.
				if(i == j){
					data[i][i] = 0; //a component cannot connect to itself
				}else{
					rnd = (int)(Math.random()*Math.random()*10); //weighted in favor of few connections.
					data[i][j] = rnd; //symmetry.
					data[j][i] = rnd;
					position++;
				}
			}
		}
		
		return data;
	}


	public static Set[] fillRndState(int size, int[][] connections){
		Set result[] = new Set[size];
		for(int i = 0; i < size; i ++){
			result[i] = generateRndSet(size, connections);
		}
		return result;
		
	}
	
	//this uses the Benchmark Case
	public static int[][] fillTestConnections(int size){
		int data[][] = new int[size][size];
		String stringData = "0074003008006000900100600522000900870700760003000806009000054000200090800408009000020030040460005060053000040009002000003002300000707007002302000400000400500600000900000700080000508080400070606006050700080070060004005000096049040000070008006000607006000009050700040000804700000000089002050000000080000708007006009000005990005000005000800003070000060508500000500009602050000005050010500030070070093000";
		int position = 0;
		
		for (int i = 0; i < size; i++){
			for (int j = 0; j < size; j++){
				data[i][j] = Integer.parseInt(stringData.substring(position, position+1));
				position++;
			}
		}
		
		return data;
	}


	public static int[] stateCosts(Set[] state, int[][] connections){
		int result[] = new int[state.length];
		
		for(int i = 0; i < state.length; i++){
			result[i] = (int) (10*state[i].cost());
		}
		
		return result;
	}
	
	public static Set generateRndSet(int size, int[][] connections){
		//generates one random test subject
		//must have the same amount of components in each bin
		Set data = new Set(connections);
		//0 means it's in the first bin; 1 means second.
		int num0 = 0;
		int num1 = 0;
		int rnd = 0;
		
		for(int i = 0; i < size; i++){
			rnd =  (int) Math.round(Math.random());
			if(rnd == 0){
				num0++;
				if(num0 > (size+1)/2){
					i--;
				}else{
					data.add(rnd);
				}
			}
			else{
				num1++;
				if(num1 > (size+1)/2){
					i--;
				}else{
					data.add(rnd);
				}
			}
			
		}
		
		return data;
	}
	
	
	public static void printStateCosts(Set[] state, int[][] connections){
		int costArray[] = stateCosts(state, connections);
		System.out.println("\nSet Costs for this Stage:");
		for(int i = 0; i < costArray.length; i++){
			System.out.println(costArray[i] + "");
		}
		System.out.println("Total Cost: " + totalCost(state));
	}
	
	
	public static int totalCost(Set[] state){
		int result = 0;
		
		for(int i = 0; i < state.length; i++){
			result += 10*state[i].cost();
		}
		
		return result;
	}
	
	
	public static void printTotalCost(Set[] state){
		System.out.println("" + totalCost(state));
	}
	

	public static void printConnectionTable(int[][] theData){
		for(int i = 0; i < 20; i++){
			for(int j = 0; j < 20; j++){
				System.out.print(theData[i][j] + " ");
			}
			System.out.println();
		}
	}
	
	
	
	public static void printChart(Set binData, int[][] connections){
		//prints a visual for the current Set.
		Bin bin0 = new Bin();
		Bin bin1 = new Bin();
		
		bin0 = binData.separateBin0();
		bin1 = binData.separateBin1();
		System.out.println();

		System.out.println("Bin0: " + bin0.toString());
		System.out.println("Bin1: " + bin1.toString());
		System.out.println("Jumps: " + bin1.jumps(bin0, connections));
		
	}
	
	
	
}







