component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_sakila.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testSakilaDemo(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplication());
    }

}
  

