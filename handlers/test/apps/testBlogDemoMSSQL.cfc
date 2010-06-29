component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var XMLFile = expandPath("/apptacular/local/apps/apptacular_blog_mssql.xml");
    	variables.automator = new automator(XMLFile);
    }
	
	public void function testBlogDemoMSSQL(){
		variables.automator.clearFiles();
		AssertTrue(automator.generateApplication());
    }

}