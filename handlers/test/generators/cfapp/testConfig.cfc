component extends="mxunit.framework.TestCase"{
	

	public void function testCalculateURLNixPathsTrailingSlashes(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = '/apache/htdocs/Apptacular/';
		var cfcPath = "apptacular";	
		var webroot = '/apache/htdocs/';
		var config = New apptacular.handlers.cfc.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLWindowsPathsTrailingSlashes(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = 'c:\inetpub\wwwroot\Apptacular\';
		var cfcPath = "apptacular";	
		var webroot = 'c:\Inetpub\wwwroot\';
		var config = New apptacular.handlers.cfc.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLNixPaths(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = '/apache/htdocs/Apptacular';
		var cfcPath = "apptacular";	
		var webroot = '/apache/htdocs';
		var config = New apptacular.handlers.cfc.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLWindowsPaths(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = 'c:\inetpub\wwwroot\Apptacular';
		var cfcPath = "apptacular";	
		var webroot = 'c:\Inetpub\wwwroot';
		var config = New apptacular.handlers.cfc.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLWindowsPathsTestPath(){
	
		var expectedURL = "http://#cgi.server_name#/blogdemomssql/test";
		var FilePath = 'c:\inetpub\wwwroot\blogdemomssql\test';
		var cfcPath = "blogdemomssql.test";	
		var webroot = 'c:\Inetpub\wwwroot';
		var config = New apptacular.handlers.cfc.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	public void function testAllPropertiesDocumented(){
    	var metaData = GetComponentMetaData("apptacular.handlers.cfc.generators.cfapp.config");
		var props = metaData.properties;
		var i = 0;
		var missing = [];
		
		for (i = 1; i <= ArrayLen(props); i++){
			if (not StructKeyExists(props[i], "hint")){
				ArrayAppend(missing, props[i].name);
			}
		}
		
		if (ArrayLen(missing) > 0){
			debug(missing);
			fail("Missing Documentation for #arrayLen(missing)# settings. See debug for list.");
			
		}
		
    }

}
  

