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


}