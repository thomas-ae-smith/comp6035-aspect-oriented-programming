/**
 * @author taes1g09
 *
 */
	
	@logging
	public class Son {
		public String name;
		private String talk;
		public Son brother;
		int age;
		
		public void complain(){
			talk = "not fair";
			System.out.println("Not fair");
		}
		public Son(){name = "tom";}
		public Son(String newName, int newAge){name = newName; age = newAge;}
	}