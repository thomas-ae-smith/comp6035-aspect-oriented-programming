	@logging
	public class Son {
		public String name;
		private String talk;
		public Son brother;
		
		public void complain(){
			talk = "not fair";
			System.out.println("Not fair");
		}
		public Son(){name = "tom";}
		public Son(String newName){name = newName;}
	}