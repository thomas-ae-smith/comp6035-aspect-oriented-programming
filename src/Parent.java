/**
 * 
 */

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
	Parent(){
		tom = new Son();
		sam = new Son("Sam");
		Daughter libby = new Daughter();
		libby.name = "Libby";

		libby.complain();
	}


}
