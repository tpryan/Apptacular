component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/applicationcfc";
	}
	
	public void function testBasicCreate(){
    	var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
		appCFC.setFileLocation(variables.testDir);

		AssertEquals("cfc", appCFC.getExtension());
		AssertEquals("cfscript", appCFC.getformat());
		AssertEquals("Application", appCFC.getName());
		AssertEquals("ram://mxunit/apptacular/code/applicationcfc/Application.cfc", appCFC.getFileName());

    }
	
	public void function testBasicWrite(){
    	var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
		appCFC.setFileLocation(variables.testDir);
		appCFC.write();
		
		AssertTrue(FileExists(appCFC.getFileName()));
    }
	
	public void function testBasicWriteFail(){
    	var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();

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
  
