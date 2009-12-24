component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
		variables.rootDir= "ram://mxunit";
		variables.testDir= rootDir & "/apptacular/code/file";
	}
	
	public void function testBasicCreate(){
    	var file  =  New apptacular.handlers.cfc.code.file();
		file.setFileLocation(variables.testDir);
		file.setName("test");
		file.setExtension("txt");
		
		AssertEquals("txt", file.getExtension());
		AssertEquals("test", file.getName());
		AssertEquals("ram://mxunit/apptacular/code/file/test.txt", file.getFileName());

    }
	
	public void function testBasicWrite(){
    	var file  =  New apptacular.handlers.cfc.code.file();
		file.setFileLocation(variables.testDir);
		file.setName("test");
		file.setExtension("txt");
		file.write();
		
		AssertTrue(FileExists(file.getFileName()));
    }
	
	
	public void function testBasicWriteFail(){
    	var file  =  New apptacular.handlers.cfc.code.file();

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
	
	public void function testinsertFileWorks(){
    	var file  =  New apptacular.handlers.cfc.code.file();
		file.setFileLocation(variables.testDir);
		file.setName("test");
		file.setExtension("txt");
		
		var FileToInsert = GetCurrentTemplatePath();
		var expected = FileRead(FileToInsert);
		
		file.InsertFile(FileToInsert);
		file.Write();
		var actual = fileRead(file.GetFileName());
		
		AssertEquals(Trim(expected), Trim(actual));
		
		
    }

}
  
