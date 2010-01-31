component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/handlers/test/apps/config/apptacular_cfartgallery.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testCFArtGallery(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplication());
    }

}
  

