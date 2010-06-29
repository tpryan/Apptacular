component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_blog.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testBlogDemoCFML(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplicationCFML());
    }
	

}
  

