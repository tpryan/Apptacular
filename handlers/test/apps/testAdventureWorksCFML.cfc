component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_adventureworks.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testAdventureWorksCFML(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplicationCFML());
    }

}
  

