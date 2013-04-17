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

import com.sun.org.apache.regexp.internal.recompile;
import com.sun.org.apache.xalan.internal.xsltc.compiler.sym;

/**
 * @author taes1g09
 * Aspect to log creation time and location of all instances of types annotated with @logging
 * Possibly overengineered, but should be speedy and robust.
 * Will overwrite rather than re-use log files, as stale object IDs are meaningless.
 * Should complain where appropriate, and redirect to standard out where possible.
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
	
	void writeLog(String className, String logMessage) {
		try {
			getFile(className).write(logMessage + "\n");
		} catch (IOException e) {
			System.err.println("Error writing to " + className + " logfile.");
			e.printStackTrace();
		}
		return;
	}
	
	boolean isPrimitiveWrapper(Object obj) {
		return WRAPPERS.contains(obj.getClass());
	}
	
	String parseArg(Object obj) {
		Integer arg;
		if ((arg = objectIDs.get(obj)) != null) return "#" + arg;
		if (isPrimitiveWrapper(obj)) return obj.toString();
		Integer ID = IDpool.incrementAndGet();
		objectIDs.put(obj, ID);
		return "#" + ID;
	}
	
	String parseConstructorArgs(Object[] objs) {
		System.out.println("Parsing constructor args" + objs.length);
		if (objs.length == 0) return "";
		StringBuilder args = new StringBuilder();
		for (Object obj : objs) {
			args.append(parseArg(obj) + " ");
		}
		return args.toString();
	}
	
	//preserve (law &) order by recording correct data prior to construction
	Object around(): loggedConstructor(){
		String className = thisJoinPointStaticPart.getSignature().getDeclaringTypeName();
		String creationTime = "" + new Date().getTime();
		String sourceLocation = thisJoinPointStaticPart.getSourceLocation().toString();
		Integer ID = IDpool.incrementAndGet();
		Object obj = proceed();
		objectIDs.put(obj, ID);
		writeLog(className, "#" + ID + ", " + creationTime + ", " + sourceLocation + ", n, " +  parseConstructorArgs(thisJoinPoint.getArgs()));
		return obj;
	}
	
	before(): loggedPrivate(){
		String className = thisJoinPointStaticPart.getSignature().getDeclaringTypeName();
		System.out.println("Private className " + className);
		String updateTime = "" + new Date().getTime();
		String sourceLocation = thisJoinPointStaticPart.getSourceLocation().toString();
		Object obj = thisJoinPoint.getTarget();
		Integer ID = objectIDs.get(obj);
		String field = thisJoinPoint.getSignature().getName();
		System.out.println("Field: " + field);
		writeLog(className, "#" + ID + ", " + updateTime + ", " + sourceLocation + ", p(" + field + "), " +  parseArg(thisJoinPoint.getArgs()[0]));
	}
	
	before(): loggedPublic(){
		String className = thisJoinPointStaticPart.getSignature().getDeclaringTypeName();
		System.out.println("Public className " + className);
		String updateTime = "" + new Date().getTime();
		String sourceLocation = thisJoinPointStaticPart.getSourceLocation().toString();
		Object obj = thisJoinPoint.getTarget();
		Integer ID = objectIDs.get(obj);
		String field = thisJoinPoint.getSignature().getName();
		System.out.println("Field: " + field);
		writeLog(className, "#" + ID + ", " + updateTime + ", " + sourceLocation + ", u(" + field + "), " +  parseArg(thisJoinPoint.getArgs()[0]));
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
		dad.tom.complain();
		dad.tom.brother = dad.sam;
		dad.sam.brother = dad.tom;
		return;
	}
}