component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		var FilePath = '/apache/htdocs/Apptacular/';
		var cfcPath = "apptacular";	
		variables.config = New apptacular.handlers.generators.cfapp.config(FilePath,cfcPath);
    	
    }
    
	
	
	public void function testGetDisplayName_DisplayNameNOTSet(){
		var configHelper = new apptacular.handlers.cfc.utils.configHelper(variables.config);
		var actual = configHelper.getDisplayName("Astringthatshouldneverbeaconfigitem");
		var expected  = "Astringthatshouldneverbeaconfigitem";
				
		AssertEquals(expected, actual);
		
    }
	
	public void function testGetDisplayName_DisplayNameSet(){
		var configHelper = new apptacular.handlers.cfc.utils.configHelper(variables.config);
		var actual = configHelper.getDisplayName("createTests");
		var expected  = "Create Tests";
				
		AssertEquals(expected, actual);
		
    }
	

}