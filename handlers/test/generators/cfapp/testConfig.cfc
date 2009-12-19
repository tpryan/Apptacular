component extends="mxunit.framework.TestCase"{
	

	public void function testCalculateURLNixPathsTrailingSlashes(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = '/apache/htdocs/Apptacular/';
		var cfcPath = "apptacular";	
		var webroot = '/apache/htdocs/';
		var config = New apptacular.handlers.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLWindowsPathsTrailingSlashes(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = 'c:\inetpub\wwwroot\Apptacular\';
		var cfcPath = "apptacular";	
		var webroot = 'c:\inetpub\wwwroot\';
		var config = New apptacular.handlers.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLNixPaths(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = '/apache/htdocs/Apptacular';
		var cfcPath = "apptacular";	
		var webroot = '/apache/htdocs';
		var config = New apptacular.handlers.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	
	public void function testCalculateURLWindowsPaths(){
	
		var expectedURL = "http://#cgi.server_name#/apptacular";
		var FilePath = 'c:\inetpub\wwwroot\Apptacular';
		var cfcPath = "apptacular";	
		var webroot = 'c:\inetpub\wwwroot';
		var config = New apptacular.handlers.generators.cfapp.config(FilePath,cfcPath);
		makePublic(config,"calculateURL");
	    AssertEquals(expectedURL,config.calculateURL(FilePath, webroot) );	
    }
	

}
  

