component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/build";
	}
	
	public void function testBasicCreate(){
    	var build  =  New apptacular.handlers.cfc.code.build();
		build.setFileLocation(variables.testDir);

		AssertEquals("xml", build.getExtension());
		AssertEquals("build", build.getName());
		AssertEquals("ram://mxunit/apptacular/code/build/build.xml", build.getFileName());

    }
	
	public void function testBasicWrite(){
    	var build  =  New apptacular.handlers.cfc.code.build();
		build.setFileLocation(variables.testDir);
		build.write();
		
		AssertTrue(FileExists(build.getFileName()));
    }
	
	public void function testIsValidXML(){
    	var build  =  New apptacular.handlers.cfc.code.build();
		build.setFileLocation(variables.testDir);
		build.write();
		
		AssertTrue(FileExists(build.getFileName()));
		AssertTrue(IsXML(FileRead(build.getFileName())));
		
    }
	
	public void function testAddProperty(){
    	var build  =  New apptacular.handlers.cfc.code.build();
		build.setFileLocation(variables.testDir);
		build.addProperty(name="testname", value="testValue");
		build.addProperty(name="testname2", value="testValue2");
		build.write();
		
		AssertTrue(FileExists(build.getFileName()));
		var createdContent = FileRead(build.getFileName());
		AssertTrue(IsXML(createdContent));
		var XML = XMLParse(createdContent);
		debug(XML);
		AssertTrue(StructKeyExists(XML.project, "property"));
		AssertEquals("testname", XML.project.property[1].XMLAttributes.name);
		AssertEquals("testValue", XML.project.property[1].XMLAttributes.value);
		AssertEquals("testname2", XML.project.property[2].XMLAttributes.name);
		AssertEquals("testValue2", XML.project.property[2].XMLAttributes.value);
		
		
    }
	
	public void function testBasicWriteFail(){
    	var build  =  New apptacular.handlers.cfc.code.build();

		try{
			build.write();
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
  
