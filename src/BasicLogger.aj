import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map.Entry;

/**
 * @author taes1g09
 * Aspect to log creation time and location of all instances of types annotated with @logging
 * Possibly overengineered, but should be speedy and robust.
 * Should complain where appropriate, and redirect to standard out where possible.
 *
 */
public aspect BasicLogger {
	public static final boolean VERBOSE = true;
	public static final boolean HEADERS = true;
	public static final String LOCATION_PREFIX = "";

	private pointcut loggedConstructor(): call((@logging *).new(..));
	
	HashMap<String, BufferedWriter> writerCache = new HashMap<String, BufferedWriter>();
	
	BufferedWriter getFile(String className){
		BufferedWriter writer;
		if ((writer = writerCache.get(className)) != null) {
			if (VERBOSE) System.out.println("Found cached logfile writer for " + className + ".");
			return writer;
		}
		try {
			File file = new File(LOCATION_PREFIX + className + ".csv");
			writer = new BufferedWriter(new FileWriter(file, true) );

			boolean preExisting = file.length() != 0;
			if (HEADERS && !preExisting) {
				writer.write("Object creation time, Object creation location\n");
				writer.flush();
			}
			
			if (VERBOSE && preExisting) System.out.println("Opened existing logfile for " + className + ".");
			if (VERBOSE && !preExisting) System.out.println("Created logfile for " + className + ", with" + ((HEADERS)? "" : "out") + " headers.");
		} catch (IOException e) {
			System.err.println("Unable to open logfile for " + className + ", redirecting to standard output.");
			writer = new BufferedWriter( new OutputStreamWriter(System.out) );
		}
		
		writerCache.put(className, writer);
		
		return writer;
	}
	
	void writeLog(String className, String creationTime, String sourceLocation) {
		try {
			getFile(className).write(creationTime + ", " + sourceLocation + "\n");
		} catch (IOException e) {
			System.err.println("Error writing to " + className + " logfile.");
			e.printStackTrace();
		}
		return;
	}
	
	before(): loggedConstructor(){
		String className = thisJoinPointStaticPart.getSignature().getDeclaringTypeName();
		String creationTime = new Date().toString(); 		//no time format specified, so have used default
		String sourceLocation = thisJoinPointStaticPart.getSourceLocation().toString();
		writeLog(className, creationTime, sourceLocation);
	}
	
	after(): execution(public static * main(..)) {
		for(Entry<String, BufferedWriter> entry : writerCache.entrySet()) {
		    try {
				entry.getValue().close();
			} catch (IOException e) {
				System.err.println("Error closing " + entry.getKey() + " logfile.");
				e.printStackTrace();
			}
		    if (VERBOSE) System.out.println("Closing logfile for " + entry.getKey() + ".");
		}
		if (VERBOSE) System.out.println("Done.");
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		Parent dad = new Parent();
		return;
	}
}

