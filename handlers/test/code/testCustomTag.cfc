component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/CustomTag";
	}
	
	public void function testBasicCreate(){
    	var CustomTag  =  New apptacular.handlers.cfc.code.CustomTag("testCaseCustomTag", variables.testDir);
		
		AssertEquals("cfm", CustomTag.getExtension());
		AssertEquals("CFML", CustomTag.getformat() );
		AssertEquals("testCaseCustomTag", CustomTag.getName());
		AssertEquals("ram://mxunit/apptacular/code/CustomTag/testCaseCustomTag.cfm", CustomTag.getFileName());

    }
	
	public void function testBasicWrite(){
    	var CustomTag  =  New apptacular.handlers.cfc.code.CustomTag("testCaseCustomTag", variables.testDir);
		CustomTag.setFileLocation(variables.testDir);
		CustomTag.write();
		
		AssertTrue(FileExists(CustomTag.getFileName()));
    }
	
	public void function testBasicWriteFail(){
    	var CustomTag  =  New apptacular.handlers.cfc.code.CustomTag("testCaseCustomTag", variables.testDir);

		try{
			CustomTag.write();
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
  
