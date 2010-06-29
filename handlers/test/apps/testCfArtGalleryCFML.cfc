component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_cfartgallery.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testCFArtGalleryCFML(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplicationCFML());
    }

}
  

