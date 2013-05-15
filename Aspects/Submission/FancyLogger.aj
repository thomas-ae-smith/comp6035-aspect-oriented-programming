import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;
import org.aspectj.lang.JoinPoint.StaticPart;


/**
 * @author taes1g09
 * Aspect to log info on creation and modification of all instances of types annotated with @logging
 * Possibly overengineered, but should be speedy and robust - caches references to open files.
 * Will overwrite rather than re-use log files, as stale object IDs are meaningless.
 * Maintains a global atomic counter IDpool to specify the next free ID using builtin incrementAndGet().
 * Maintains a hashmap associating observed objects with their IDs.
 * Has to explicitly check against a HashSet for primitive wrapper types.
 * Should complain where appropriate, and redirect to standard out where possible.
 * Note: on modification of an object, stores modification time and location rather than creation time and location.
 *
 */
public aspect FancyLogger {
	public static final boolean VERBOSE = true;
	public static final boolean HEADERS = true;
	public static final String LOCATION_PREFIX = "";
	public static final HashSet<Class<?>> WRAPPERS = getWrappers();

	private final AtomicInteger IDpool = new AtomicInteger();

	private pointcut loggedConstructor(): call((@logging *).new(..));
	private pointcut loggedPrivate(): set(private * (@logging *).* ) && !cflowbelow(loggedConstructor());
	private pointcut loggedPublic(): set(public * (@logging *).* ) && !cflowbelow(loggedConstructor());

	HashMap<String, BufferedWriter> writerCache = new HashMap<String, BufferedWriter>();
	HashMap<Object, Integer> objectIDs = new HashMap<Object, Integer>();

	/*
	 * Primitive-checking functions - populate the static collection, and then check against it.
	 */
	private static HashSet<Class<?>> getWrappers() {
		HashSet<Class<?>> wrappers = new HashSet<Class<?>>();
		wrappers.add(Integer.class);
		wrappers.add(Short.class);
		wrappers.add(Long.class);
		wrappers.add(Boolean.class);
		wrappers.add(Character.class);
		wrappers.add(Float.class);
		wrappers.add(Double.class);
		wrappers.add(Byte.class);
		return wrappers;
	}

	boolean isPrimitiveWrapper(Object obj) {
		return WRAPPERS.contains(obj.getClass());
	}

	/*
	 * Get an open file if available. If not, create a new file for writing and store in cache.
	 * Files are named by classname - nested classes work fine.
	 */

	BufferedWriter getFile(String className){
		BufferedWriter writer;

		if ((writer = writerCache.get(className)) != null) {
			if (VERBOSE) System.out.println("Found cached logfile writer for " + className + ".");
			return writer;
		}

		try {
			File file = new File(LOCATION_PREFIX + className + ".csv");

			if (VERBOSE && file.length() != 0) System.out.println("Overwrote existing file for " + className + ".");

			writer = new BufferedWriter(new FileWriter(file, false) );

			if (HEADERS) {
				writer.write("Object ID, Object modification time, Object modification location, Operation type, Operation arguments\n");
				writer.flush();
			}

			if (VERBOSE) System.out.println("Created logfile for " + className + ", with" + ((HEADERS)? "" : "out") + " headers.");

		} catch (IOException e) {
			System.err.println("Unable to open logfile for " + className + ", redirecting to standard output.");
			writer = new BufferedWriter( new OutputStreamWriter(System.out) );
		}

		writerCache.put(className, writer);

		return writer;
	}
	
	/*
	 * First, check if it's a known object. Then check if primitive. Otherwise, assign new ID and store association.
	 */
	String parseArg(Object obj) {

		Integer knownArg;
		if ((knownArg = objectIDs.get(obj)) != null) return "#" + knownArg;

		if (isPrimitiveWrapper(obj)) return obj.toString();

		Integer newID = IDpool.incrementAndGet();
		objectIDs.put(obj, newID);
		return "#" + newID;
	}

	/*
	 * Fail-fast, or parse a collection of args; present them separated by spaces.
	 */
	String parseConstructorArgs(Object[] objs) {
		if (objs.length == 0) return "";
		StringBuilder args = new StringBuilder();
		for (Object obj : objs) {
			args.append(parseArg(obj) + " ");
		}
		return args.toString();
	}

	void writeLog(int ID, StaticPart jpsp, String modification) {
		String className = jpsp.getSignature().getDeclaringTypeName();
		String updateTime = "" + new Date().getTime();
		String sourceLocation = jpsp.getSourceLocation().toString();
		try {
			getFile(className).write("#" + ID + ", " + updateTime + ", " + sourceLocation + ", " + modification + "\n");
		} catch (IOException e) {
			System.err.println("Error writing to " + className + " logfile.");
			e.printStackTrace();
		}
		return;
	}

	/*
	 * Grab IDs before construction to ensure nested constructors for multiple @logging objects behave as expected.
	 */
	Object around(): loggedConstructor(){
		Integer ID = IDpool.incrementAndGet();
		Object newObj = proceed();
		objectIDs.put(newObj, ID);
		writeLog(ID, thisJoinPointStaticPart, "n, " + parseConstructorArgs(thisJoinPoint.getArgs()));
		return newObj;
	}

	before(): loggedPrivate(){
		Object obj = thisJoinPoint.getTarget();
		Integer ID = objectIDs.get(obj);
		String modification = "p(" + thisJoinPoint.getSignature().getName() + "), " +  parseArg(thisJoinPoint.getArgs()[0]);
		writeLog(ID, thisJoinPointStaticPart, modification);
	}

	before(): loggedPublic(){
		Object obj = thisJoinPoint.getTarget();
		Integer ID = objectIDs.get(obj);
		String modification = "u(" + thisJoinPoint.getSignature().getName() + "), " +  parseArg(thisJoinPoint.getArgs()[0]);
		writeLog(ID, thisJoinPointStaticPart, modification);
	}

	/*
	 * Flush and close all files once done.
	 */
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

}