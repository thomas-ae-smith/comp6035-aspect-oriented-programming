import java.util.Date;

/**
* @author taes1g09
* Aspect to enforce AgeComparable interface on all @logging-annotated types.
* Adds a private creation timestamp field and getters and setters through inter-type declaration.
* Long, specific names deliberately chosen to minimise collision risk.
*
*/
aspect AgeComparer {

	private interface AgeComparable {
		boolean olderThan(AgeComparable x);
		void setComparableCreationTime(long time);
	}

	declare parents: (@logging *) implements AgeComparable;

	private long AgeComparable.comparableCreationTime;
	public  long AgeComparable.getComparableCreationTime()  { 
		return comparableCreationTime; 
	};
	public  void AgeComparable.setComparableCreationTime(long time)  { 
		comparableCreationTime = time; 
	};

	public boolean AgeComparable.olderThan(AgeComparable x) {
		return comparableCreationTime < x.comparableCreationTime;
	};

	after(AgeComparable object): initialization(AgeComparable+.new(..)) && this(object) {
		object.setComparableCreationTime(new Date().getTime());
	}

}