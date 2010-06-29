component extends="mxunit.framework.TestCase"{
	
	public void function testGetLatestVersion(){
		
		var currentVersion = "1.000150";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		var expectedVersion = "1.000123";
		
		AssertTrue(Compare(expectedVersion, update.getLatestVersion()) eq 0 );
    }
	
	public void function testGetLatestVersionShouldFail(){
		
		var currentVersion = "1.000150";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		var unexpectedVersion = "1.000150";
		
		AssertFalse(Compare(unexpectedVersion, update.getLatestVersion()) eq 0 );
    }
	
	public void function testShouldUpdate_currentLowerThenLatest(){
		
		var currentVersion = "1.000100";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		
		AssertTrue(update.shouldUpdate());
    }
	
	public void function testShouldUpdate_currentEqualToLatest(){
		
		var currentVersion = "1.000123";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		
		AssertFalse(update.shouldUpdate());
    }
	
	public void function testShouldUpdate_currentGreaterThenLatest(){
		
		var currentVersion = "1.000150";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		
		AssertFalse(update.shouldUpdate());
    }
	
	public void function testShouldUpdate_currentHasStrings(){
		
		var currentVersion = "1.@buildNumber@";
		var buildURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/test.build";
		var appURL = "";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		
		AssertFalse(update.shouldUpdate());
    }
	
	public void function testGetLatestZip(){
		
		var currentVersion = "";
		var buildURL = "";
		var zipPath = getDirectoryFromPath(getCurrentTemplatePath());
		var appURL = "http://" & cgi.server_name & "/apptacular/handlers/test/cfc/updateTest/Apptacular.zip";
		var update = new apptacular.handlers.cfc.utils.update(currentVersion, buildURL, appURL);
		var expectedFilePath = zipPath & "Apptacular.zip";
		
		update.getLatestZip(zipPath);
		
		AssertTrue(FileExists(expectedFilePath));
		
		if (FileExists(expectedFilePath)){
			fileDelete(expectedFilePath);
		}
		
    }


}