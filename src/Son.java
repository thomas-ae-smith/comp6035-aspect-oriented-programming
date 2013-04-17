	@logging
	public class Son {
		public String name;
		public String talk;
		
		public void complain(){
			talk = "not fair";
			System.out.println("Not fair");
		}
		public Son(){name = "tom";}
		public Son(String newName){name = newName;}
	}