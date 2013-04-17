//import java.util.Date;
//
///**
//* @author taes1g09
//* Aspect to enforce AgeComparable interface on all @logging-annotated types.
//* Adds a private creation timestamp field and getters and setters through inter-type declaration.
//* Long, specific names deliberately chosen to minimise collision risk.
//*
//*/
//aspect AgeComparer {
//	
//    private interface AgeComparable {
//    	boolean olderThan(AgeComparable x);
//		void setComparableCreationTime(long time);
//    }
//    
//    declare parents: (@logging *) implements AgeComparable;
//
//    private long AgeComparable.comparableCreationTime;
//    public  long AgeComparable.getComparableCreationTime()  { 
//    	return comparableCreationTime; 
//    };
//    public  void AgeComparable.setComparableCreationTime(long time)  { 
//    	comparableCreationTime = time; 
//    };
//    
//    public boolean AgeComparable.olderThan(AgeComparable x) {
//    	return comparableCreationTime < x.comparableCreationTime;
//    };
// 
//    after(AgeComparable object): initialization(AgeComparable+.new(..)) && this(object) {
//    	object.setComparableCreationTime(new Date().getTime());
//    }
//    
//	/**
//	 * @param args
//	 */
//	public static void main(String[] args) {
//
//		Parent dad = new Parent();
//		dad.tom.complain();
//		dad.tom.brother = dad.sam;
//		dad.sam.brother = dad.tom;
//		dad.libby.age = 18;
//		System.out.println(dad.tom.getComparableCreationTime());
//		System.out.println(dad.sam.getComparableCreationTime());
//		System.out.println(dad.libby.getComparableCreationTime());
//		System.out.println("Tom > Sam " + dad.tom.olderThan(dad.sam));
//		System.out.println("Sam > Tom " + dad.sam.olderThan(dad.tom));
//		System.out.println("Tom > Tom " + dad.tom.olderThan(dad.tom));
//		System.out.println("Tom > Lib " + dad.tom.olderThan(dad.libby));
//		return;
//	}
//}