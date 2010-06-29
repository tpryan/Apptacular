component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_blog_mssql.xml");
    	variables.automator = new automator(XMLFile);
    	
    }
	
	public void function testBlogDemoMSSQLCFML(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplicationCFML());
    }

}
  

