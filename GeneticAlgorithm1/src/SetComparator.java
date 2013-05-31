import java.util.Comparator;


class SetComparator implements Comparator{
	/*
	this is all so that we can use Java's built-in sort to sort Set Objects.
	It will sort by Cost
	*/
	public int compare(Object o1, Object o2) {
		//this will make it end up sorting lowest to highest.
		return (int) (100*(((Set) o1).cost() - ((Set) o2).cost()));
	}
   
}
