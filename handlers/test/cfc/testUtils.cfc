component extends="mxunit.framework.TestCase"{

	public void function findCFCPathFromFilePathNixPaths(){
		var utils = new apptacular.handlers.cfc.utils("/Users/terryr/Sites/centaur.dev/");
		var PathToTest = "/Users/terryr/Sites/centaur.dev/BlogDemo/services";
		var expectedPath = "BlogDemo.services";
		AssertEquals(expectedPath, utils.findCFCPathFromFilePath(PathToTest));
    }
	
	public void function findCFCPathFromFilePathWindowsPaths(){
		var utils = new apptacular.handlers.cfc.utils("c:\Inetpub\wwwroot\");
		var PathToTest = "c:\inetpub\wwwroot\BlogDemo\services";
		var expectedPath = "BlogDemo.services";
		AssertEquals(expectedPath, utils.findCFCPathFromFilePath(PathToTest));
    }
	
	public void function findPathFromfileName(){
		var utils = new apptacular.handlers.cfc.utils("/Users/terryr/Sites/centaur.dev/");
		var PathToTest = "/Users/terryr/Sites/centaur.dev/blogdemo/cfc/author.cfc";
		var expectedPath = "blogdemo.cfc.author";
		AssertEquals(expectedPath, utils.findCFCPathFromFilePath(PathToTest));
    }

	public void function testFindConfigWhenProjectIsRootButSelectedIsNotRoot(){
    	var utils = new apptacular.handlers.cfc.utils();
		var start = GetDirectoryFromPath(GetCurrentTemplatePath());
		var expectedPath = start & "configTest/blogdemo/.apptacular/config.xml"; 
		var projectlocation = start & "configTest/blogdemo";
		var resourcepath= start & "configTest/blogdemo/cfc";
		AssertEquals(expectedPath, utils.findConfig(projectlocation, resourcepath));
    }
	
	public void function testFindConfigWhenProjectIsRootAndSelectedIsRoot(){
    	var utils = new apptacular.handlers.cfc.utils();
		var start = GetDirectoryFromPath(GetCurrentTemplatePath());
		var expectedPath = start & "configTest/blogdemo/.apptacular/config.xml"; 
		var projectlocation = start & "configTest/blogdemo";
		var resourcepath= start & "configTest/blogdemo";
		AssertEquals(expectedPath, utils.findConfig(projectlocation, resourcepath));
    }
	
	public void function testFindConfigWhenThereIsNoConfig(){
    	var utils = new apptacular.handlers.cfc.utils();
		var start = GetDirectoryFromPath(GetCurrentTemplatePath());
		var expectedPath = "/dev/null"; 
		var projectlocation = start & "configTest/NotAnApptacularApp";
		var resourcepath= start & "configTest/NotAnApptacularApp";
		AssertEquals(expectedPath, utils.findConfig(projectlocation, resourcepath));
    }
	
	public void function testFindConfigWhenProjectIsNotRootAndSelectedIsDeeper(){
    	var utils = new apptacular.handlers.cfc.utils();
		var start = GetDirectoryFromPath(GetCurrentTemplatePath());
		var expectedPath = start & "configTest/Collection/cfart1/.apptacular/config.xml"; 
		var projectlocation = start & "configTest/Collection/cfart1";
		var resourcepath= start & "configTest/Collection/cfart1/cfc";
		AssertEquals(expectedPath, utils.findConfig(projectlocation, resourcepath));
    }
    
	public void function testFindEmptyDirs(){
		var FS = createObject("java", "java.lang.System").getProperty("file.separator");
    	var utils = new apptacular.handlers.cfc.utils();
		var start = GetDirectoryFromPath(GetCurrentTemplatePath());
		var testPath = start & "utilsTest";
		
		if (not directoryExists(testPath & fs & "empty")){
			DirectoryCreate(testPath & fs & "empty");
			DirectoryCreate(testPath & fs & "emptyWithSub");
			DirectoryCreate(testPath & fs & "emptyWithSub" & fs & "sub");
		}
		
		 
		var results = utils.getEmptyDirectories(testPath);
		var resultAsList = ValueList(results.path);
		AssertTrue(ListFindNoCase(resultAsList, testPath & FS & "empty"), "Folder 'Empty' was not found");
		AssertTrue(ListFindNoCase(resultAsList, testPath & FS & "emptyWithSub" & FS & "sub"), "Folder 'sub' was not found");
		AssertTrue(ListFindNoCase(resultAsList, testPath & FS & "emptyWithSub"), "Folder 'emptyWithSub' was not found");
		AssertFalse(ListFindNoCase(resultAsList, testPath & FS & "notEmpty"), "Folder 'notEmpty' was found, should not have been");
		
		
		debug(resultAsList);
    }

}