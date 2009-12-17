component  extends="codeGenerator"
{
	
	public any function createIndexTestCFC(){
		
		var indexURL = variables.config.getRootURL() & "/index.cfm";
		
		var testIndex  = New apptacular.handlers.cfc.code.cfc();
	    testIndex.setName("testIndex");
	    testIndex.setFileLocation(variables.config.getTestFilePath() & fs &"view");
		testIndex.setFormat(variables.config.getCFCFormat());
		testIndex.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		// Add basic 200 test
		var returns200=createSimple200UnitTest(indexURL); 
		testIndex.addFunction(returns200);
		
		//Test for loginstate
		var loginTest= New apptacular.handlers.cfc.code.function();
		loginTest.setAccess("public");
		loginTest.setReturnType("void");
		loginTest.addLocalVariable("cfhttp","struct");
		loginTest.addLocalVariable("urlToTest","string", "#indexURL#");
		
		if (config.getcreateLogin()){
			loginTest.setName('testLoginRequired');
		}
		else{
			loginTest.setName('testLoginNotRequired');
		}
		
		
		loginTest.AddOperation('');
		loginTest.AddOperation('		<cfhttp url="##urlToTest##" timeout="5" />');
		
		if (config.getcreateLogin()){
			loginTest.AddOperation('		<cfif not FindNoCase("Please login", cfhttp.fileContent)>');
			loginTest.AddOperation('			<cfset fail("Login should be required") />');
			loginTest.AddOperation('		</cfif>');
		}
		else{
			loginTest.AddOperation('		<cfif FindNoCase("Please login", cfhttp.fileContent)>');
			loginTest.AddOperation('			<cfset fail("Login should not be required") />');
			loginTest.AddOperation('		</cfif>');
		}
		
		loginTest.AddOperation('');
		
		loginTest.AddOperationScript('');
		loginTest.AddOperationScript('		var httpObj = new http(url="##urlToTest##", timeout="5" );');
		loginTest.AddOperationScript('		cfhttp = httpObj.send().getPrefix();');
		
		if (config.getcreateLogin()){
			loginTest.AddOperationScript('		if (not FindNoCase("Please login", cfhttp.fileContent)){');
			loginTest.AddOperationScript('			fail("Login should be required");');
			loginTest.AddOperationScript('		}');
		}
		else{
			loginTest.AddOperationScript('		if (FindNoCase("Please login", cfhttp.fileContent)){');
			loginTest.AddOperationScript('			fail("Login should not be required");');
			loginTest.AddOperationScript('		}');
		}
		
		loginTest.AddOperationScript('');
		
		testIndex.addFunction(loginTest);
		
		return testIndex;
	}
	
	public any function createViewsTestCFC(required any table){
		var entityName = table.getEntityName();
		var baseurl = variables.config.getRootURL() & "/#entityName#.cfm";
		
		var testView  = New apptacular.handlers.cfc.code.cfc();
	    testView.setName("test#entityName#");
	    testView.setFileLocation(variables.config.getTestFilePath() & fs & "view");
		testView.setFormat(variables.config.getCFCFormat());
		testView.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		// Add basic 200 test for list
		var listURL = baseurl;
		var listreturns200=createSimple200UnitTest(listURL, "testListReturns200"); 
		testView.addFunction(listreturns200);
		
		// Add basic 200 test for new
		var newURL = baseurl & "?method=edit";
		var newreturns200=createSimple200UnitTest(newURL, "testNewReturns200"); 
		testView.addFunction(newreturns200);
		
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource.getName(), maxrows=1);
		qry.setSQL("select #table.getIdentity()# as id from #table.getName()#");
		var id = qry.execute().getResult().id;
		
		// Add basic 200 test for read
		var readURL = baseurl & "?method=read&" & table.getIdentity() & "=" & id ;
		var readreturns200=createSimple200UnitTest(readURL, "testReadReturns200"); 
		testView.addFunction(readreturns200);
		
		// Add basic 200 test for edit
		var editURL = baseurl & "?method=edit&" & table.getIdentity() & "=" & id ;
		var editreturns200=createSimple200UnitTest(editURL, "testEditReturns200"); 
		testView.addFunction(editreturns200);
	
	
		return testView;
	}
	
	public any function createRemoteFacade(){
	
		var facade  = New apptacular.handlers.cfc.code.cfc();
	    facade.setName("remoteFacade");
	    facade.setFileLocation(variables.config.getTestFilePath());
		facade.setFormat(variables.config.getCFCFormat());
		facade.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.remoteFacade");
		return facade;
	}
	
	public any function createHttpAntRunner(){
	
		var runner  = New apptacular.handlers.cfc.code.cfc();
	    runner.setName("HttpAntRunner");
	    runner.setFileLocation(variables.config.getTestFilePath());
		runner.setFormat(variables.config.getCFCFormat());
		runner.setExtends(variables.config.getMXUNITCFCPAth() & ".runner.HttpAntRunner");
		return runner;
	}
	
	private any function createSimple200UnitTest(required string targetURL, string name="testReturns200"){
		var returns200= New apptacular.handlers.cfc.code.function();
		returns200.setAccess("public");
		returns200.setReturnType("void");
		returns200.setName(arguments.name);
		returns200.addLocalVariable("cfhttp","struct");
		returns200.addLocalVariable("urlToTest","string", "#arguments.targetURL#");
	
		returns200.AddOperation('');
		returns200.AddOperation('		<cfhttp url="##urlToTest##" timeout="5" />');
		returns200.AddOperation('		<cfif not FindNoCase("200", cfhttp.statusCode)>');
		returns200.AddOperation('			<cfset debug(urlToTest) />');
		returns200.AddOperation('			<cfset debug(cfhttp) />');
		returns200.AddOperation('			<cfset fail("Simple HTTP Calls to view should work.") />');
		returns200.AddOperation('		</cfif>');
		returns200.AddOperation('');
		returns200.AddOperationScript('');
		returns200.AddOperationScript('		var httpObj = new http(url="##urlToTest##", timeout="5" );');
		returns200.AddOperationScript('		cfhttp = httpObj.send().getPrefix();');
		returns200.AddOperationScript('		if (not FindNoCase("200", cfhttp.statusCode)){');
		returns200.AddOperationScript('			debug(urlToTest);');
		returns200.AddOperationScript('			debug(cfhttp);');
		returns200.AddOperationScript('			fail("Simple HTTP Calls to view should work.");');
		returns200.AddOperationScript('		}');
		returns200.AddOperationScript('');
	
		return returns200;
	}

}