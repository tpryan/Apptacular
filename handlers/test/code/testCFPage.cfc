component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/CFPage";
	}
	
	public void function testBasicCreate(){
    	var CFPage  =  New apptacular.handlers.cfc.code.CFPage("testCasePage", variables.testDir);
		
		AssertEquals("cfm", CFPage.getExtension());
		AssertEquals("CFML", CFPage.getformat() );
		AssertEquals("testCasePage", CFPage.getName());
		AssertEquals("ram://mxunit/apptacular/code/cfpage/testCasePage.cfm", CFPage.getFileName());

    }
	
	public void function testBasicWrite(){
    	var CFPage  =  New apptacular.handlers.cfc.code.CFPage("testCasePage", variables.testDir);
		CFPage.setFileLocation(variables.testDir);
		CFPage.write();
		
		AssertTrue(FileExists(CFPage.getFileName()));
    }
	
	public void function testBasicWriteFail(){
    	var CFPage  =  New apptacular.handlers.cfc.code.CFPage("testCasePage", "");

		try{
			CFPage.write();
			fail("File creation should fail if there is no file location set.");	
		}
		catch(any e){}
    }

	public void function tearDown(){
		if (DirectoryExists(variables.rootDir)){
			DirectoryDelete(variables.rootDir, true);
		}
	}

}
  
