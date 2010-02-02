component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/handlers/test/apps/config/apptacular_facebook.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testFacebook(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplication());
    }

}
  

