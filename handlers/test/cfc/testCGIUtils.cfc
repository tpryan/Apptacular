component extends="mxunit.framework.TestCase"{
	
	public void function testSimpleGet(){
		
		var cgiStruct = {https="",server_name="localhost",server_port="80"};
		var cgiUtils = new apptacular.handlers.cfc.utils.cgiUtils(cgiStruct);
		var expected = "http://localhost:80";
		
		AssertTrue(Compare(expected, cgiUtils.getBaseURL()) eq 0 );
    }
	
	public void function testSSLGet(){
		
		var cgiStruct = {https="yes",server_name="localhost",server_port="443"};
		var cgiUtils = new apptacular.handlers.cfc.utils.cgiUtils(cgiStruct);
		var expected = "https://localhost:443";
		
		AssertTrue(Compare(expected, cgiUtils.getBaseURL()) eq 0 );
    }


	public void function testSimpleGetBuiltInServer(){
		
		var cgiStruct = {https="",server_name="localhost",server_port="8500"};
		var cgiUtils = new apptacular.handlers.cfc.utils.cgiUtils(cgiStruct);
		var expected = "http://localhost:8500";
		
		AssertTrue(Compare(expected, cgiUtils.getBaseURL()) eq 0 );
    }

}