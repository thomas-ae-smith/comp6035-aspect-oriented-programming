/**
 * @author taes1g09
 *
 */

@logging
public class Parent {

	@logging
	public class Daughter {
		public String name;
		public String talk;
		public int age;
		
		public void complain(){
			talk = "Awww";
			System.out.println("Awww");
		}
		
		public Daughter() {
			name = "Beth";
		}
	}

	public Son tom;
	public Son sam;
	public Daughter libby;
	Parent(){
		tom = new Son();
		int i = 0;
		while (i < 1000000000) {i++;}
		sam = new Son("Sam", 20);
		while (i > 0) {i--;}
		libby = new Daughter();
		libby.name = "Libby";

		libby.complain();
	}


}
