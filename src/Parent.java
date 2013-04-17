/**
 * 
 */

/**
 * @author taes1g09
 *
 */

@logging
public class Parent {

//	@logging
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

	Parent(){
		Son tom = new Son();
		Son sam = new Son("Sam");
		Daughter libby = new Daughter();
		libby.name = "Libby";
		tom.complain();
		libby.complain();
	}


}
