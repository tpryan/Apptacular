component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_testbed.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testApptacularTestbed(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplication());
    }
	

}
  

