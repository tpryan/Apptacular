component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/cfc";
	}
	
	public void function testBasicCreate(){
    	var CFC  =  New apptacular.handlers.cfc.code.cfc();
		CFC.setName("testCaseCFC");
		CFC.setFileLocation(variables.testDir);
		
		AssertEquals("cfc", CFC.getExtension());
		AssertEquals("cfscript", CFC.getformat());
		AssertEquals("testCaseCFC", CFC.getName());
		AssertEquals("ram://mxunit/apptacular/code/cfc/testCaseCFC.cfc", CFC.getFileName());

    }
	
	public void function testBasicWrite(){
    	var CFC  =  New apptacular.handlers.cfc.code.cfc();
		CFC.setFileLocation(variables.testDir);
		CFC.write();
		
		AssertTrue(FileExists(CFC.getFileName()));
    }
	
	public void function testBasicWriteFail(){
    	var CFC  =  New apptacular.handlers.cfc.code.cfc();

		try{
			appCFC.write();
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
  
