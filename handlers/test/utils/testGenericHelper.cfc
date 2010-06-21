component extends="mxunit.framework.TestCase"{
	
	
	
	public void function testGetDisplayName(){
		var configHelper = new apptacular.handlers.cfc.utils.genericHelper();
		var actual = configHelper.getDisplayName("Astringthatshouldneverbeaconfigitem");
		var expected  = "Astringthatshouldneverbeaconfigitem";
				
		AssertEquals(expected, actual);
		
    }
	
	

}