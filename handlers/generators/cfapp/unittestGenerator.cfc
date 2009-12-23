/**
* @hint Generates all code that has anything to do with MXUnit testing.  
*/
component  extends="codeGenerator"
{
	/**
	* @hint Creates the test for the application's index.cfm
	*/
	public any function createIndexTest(){
		
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
	
	/**
	* @hint Spins through and creates a simple Returns200 for every view.
	*/
	public any function createViewsTest(required any table){
		var entityName = table.getEntityName();
		var baseurl = variables.config.getRootURL() & "/#entityName#.cfm";
		
		var testView  = New apptacular.handlers.cfc.code.cfc();
	    testView.setName("test#entityName#");
	    testView.setFileLocation(variables.config.getTestFilePath() & fs & "view");
		testView.setFormat(variables.config.getCFCFormat());
		testView.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		// Add basic 200 test for list
		var listURL = baseurl;
		var listreturns200=createSimple200UnitTest(listURL, "testListReturns200", entityName, "list"); 
		testView.addFunction(listreturns200);
		
		// Add basic 200 test for new
		var newURL = baseurl & "?method=edit";
		var newreturns200=createSimple200UnitTest(newURL, "testNewReturns200", entityName, "new"); 
		testView.addFunction(newreturns200);
		
		var id = discoverValidId(table);
		
		// Add basic 200 test for read
		var readURL = baseurl & "?method=read&" & table.getIdentity() & "=" & id ;
		var readreturns200=createSimple200UnitTest(readURL, "testReadReturns200", entityName, "read"); 
		testView.addFunction(readreturns200);
		
		// Add basic 200 test for edit
		var editURL = baseurl & "?method=edit&" & table.getIdentity() & "=" & id ;
		var editreturns200=createSimple200UnitTest(editURL, "testEditReturns200", entityName, "edit"); 
		testView.addFunction(editreturns200);
	
	
		return testView;
	}
	
	/**
	* @hint Generates the test that makes sure that the application is correctly wired through RemoteFacade.cfc
	*/
	public any function createGlobalTest(){
		
		var testGlobal  = New apptacular.handlers.cfc.code.cfc();
	    testGlobal.setName("testGlobal");
	    testGlobal.setFileLocation(variables.config.getTestFilePath() & fs & "_" );
		testGlobal.setFormat(variables.config.getCFCFormat());
		testGlobal.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		
		var isAppWorking= New apptacular.handlers.cfc.code.function();
		isAppWorking.setReturnType("void");
		isAppWorking.setName("testIsApplicationWorking");
		
		isAppWorking.addSimpleSet('AssertTrue(IsDefined("application"), "This occur might occur because you have not pointed your ColdFusion Builder project to the remotefacade.cfc (#config.getTestURL()#/remoteFacade.cfc)in this project.")', 2);
		testGlobal.addFunction(isAppWorking);
		return testGlobal;
	}
	
	/**
	* @hint Creates a CRUD test for Entities.
	*/
	public any function createEntityTest(required any table){
		var entityName = table.getEntityName();
		var columns = table.getColumns();

		var testEntity  = New apptacular.handlers.cfc.code.cfc();
	    testEntity.setName("test#entityName#");
	    testEntity.setFileLocation(variables.config.getTestFilePath() & fs & "entity");
		testEntity.setFormat(variables.config.getCFCFormat());
		testEntity.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");


		//Create Create Test
		var create = createSimpleCreateOrDeleteUnitTest(table);
		testEntity.addFunction(create);

		//Create Read Test
		var read = createSimpleReadUnitTest(table);
		testEntity.addFunction(read);
		
		//Create Update Test
		var update = createSimpleUpdateUnitTest(table);
		testEntity.addFunction(update);
		
		
		//Create Delete Test
		var delete = createSimpleCreateOrDeleteUnitTest(table, "Delete");
		testEntity.addFunction(delete);
		

		return testEntity;
	}	
	
	/**
	* @hint Creates the remote facade that wires the IDE runner through the application scope of the application. 
	*/
	public any function createRemoteFacade(){
	
		var facade  = New apptacular.handlers.cfc.code.cfc();
	    facade.setName("remoteFacade");
	    facade.setFileLocation(variables.config.getTestFilePath());
		facade.setFormat(variables.config.getCFCFormat());
		facade.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.remoteFacade");
		return facade;
	}
	
	/**
	* @hint Creates an ant runner that wires the ant runner through the application scope of the application. 
	*/
	public any function createHttpAntRunner(){
	
		var runner  = New apptacular.handlers.cfc.code.cfc();
	    runner.setName("HttpAntRunner");
	    runner.setFileLocation(variables.config.getTestFilePath());
		runner.setFormat(variables.config.getCFCFormat());
		runner.setExtends(variables.config.getMXUNITCFCPAth() & ".runner.HttpAntRunner");
		return runner;
	}
	
	/**
	* @hint Creates a simple html runner for MXunit
	*/
	public any function createDirectoryRunner(){
		var runner = New apptacular.handlers.cfc.code.cfpage("runner", variables.config.getTestFilePath());
		runner.appendBody('<cfparam name="url.output" type="string" default="extjs" />');
		runner.appendBody('');
		runner.appendBody('<cfinvoke component="#variables.config.getMXUNITCFCPAth()#.runner.DirectoryTestSuite"   ');
		runner.appendBody('          method="run"  ');
		runner.appendBody('          directory="##expandPath(''.'')##"   ');
		runner.appendBody('          recurse="true"   ');
		runner.appendBody('          returnvariable="results" />  ');
		runner.appendBody('		  ');
		runner.appendBody('<cfoutput> ##results.getResultsOutput(url.output)## </cfoutput> ');
		
		return runner;
	}
	
	/**
	* @hint Creates a simple ant runner for MXunit
	*/
	public any function createAntRunner(){
		var runner = New apptacular.handlers.cfc.code.build();
		
		runner.setProjectName(variables.datasource.getName());
		runner.setProjectDefault("test");
		runner.setFileLocation(variables.config.getTestFilePath());
		
		runner.addProperty("mxunit.jar", variables.config.getMXUnitFilePath() & "/ant/lib/mxunit-ant-java5.jar");
		//This is a hack to make sure that CF doesn't even run any debugging while ANT tests are running.
		runner.addProperty("test.dir", variables.config.getTestFilePath() & "&amp;_cf_nodebug=true");
		runner.addProperty("runner.cfc", variables.config.getTestRelativePath() & "/HttpAntRunner.cfc");
		runner.addProperty("server", cgi.server_name);
		runner.addProperty("cfc.path", variables.config.getTestCFCPath());
		
		runner.appendBody('');
		runner.appendBody('	<target name="test" description="Run a dir of tests recursively">');
		runner.appendBody('');
		runner.appendBody('		<taskdef name="mxunittask" classname="org.mxunit.ant.MXUnitAntTask" classpath="${mxunit.jar}" />');
		runner.appendBody('		');
		runner.appendBody('		<mxunittask server="${server}" defaultrunner="${runner.cfc}" haltonerror="true" verbose="true">');
		runner.appendBody('			<directory path="${test.dir}" recurse="true" componentPath="${cfc.path}" />');
		runner.appendBody('		</mxunittask>');
		runner.appendBody('');
		runner.appendBody('	</target>');

		
		return runner;
	}
	
	/**
	* @hint Creates an update test for ORM objects.
	*/
	private any function createSimpleUpdateUnitTest(required any table){
		var i = 0;
		var id = discoverValidId(table);
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var update= New apptacular.handlers.cfc.code.function();
		update.setReturnType("void");
		update.setName("testUpdate");
	
		update.addLineBreak();
		update.AddOperation('			<cftransaction action="begin">');
		update.AddOperationScript('		transaction action="begin"{');	
		update.addSimpleSet('var #entityName# = EntityLoad("#entityName#", #id#, true)', 3);
		
		
		//Convert all of these columns to dummy data.
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			if (column.getIsForeignKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				var ftid = discoverValidId(foreignTable);
				
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1){
					update.addSimpleSet('#entityName#.set#column.getName()#(EntityLoad("#ftEntityName#", #ftid#, true))', 3);  
				}
				else{
					update.addSimpleSet('#entityName#.set#ftEntityName#(EntityLoad("#ftEntityName#", #ftid#, true))', 3); 
				}
				
				
				
			}
			else if (column.getisPrimaryKey() ){ 
			
			}
			else if (not config.isMagicField(column.getName())){
				update.addSimpleSet('#entityName#.set#column.getName()#("#getDummyData(column.getType())#")', 3); 
			}
		}
		update.addSimpleSet("EntitySave(#entityName#)",3);
		
		update.addLineBreak();
		update.addSimpleComment("Make it go away!", 3);
		update.addSimpleSet('transactionRollback()', 3);
		
		update.AddOperation('		</cftransaction>');
		update.AddOperationScript('		};');
		
		update.addLineBreak();
		
	
		return update;
	}
	
	/**
	* @hint Creates a read test for ORM objects.
	*/
	private any function createSimpleReadUnitTest(required any table){
		var i = 0;
		var id = discoverValidId(table);
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var read= New apptacular.handlers.cfc.code.function();
		read.setReturnType("void");
		read.setName("testRead");
		read.addLocalVariable("fromQuery");
		var sql = "SELECT * FROM #tableName# WHERE #identity# = #id#";
		
		
		read.AddOperation('');
		read.AddOperation('		<cfquery name="fromQuery" datasource="#dsname#">');
		read.AddOperation('			#sql#');
		read.AddOperation('		</cfquery">');
		read.AddOperation('');
		read.AddOperation('		<cfset var #entityName# = EntityLoad("#entityName#", #id#, true) />');
		
		read.AddOperation('');
		read.AddOperationScript('');
		read.AddOperationScript('		var qry = new Query(datasource="#dsname#");');
		read.AddOperationScript('		qry.setSQL("#sql#");');
		read.AddOperationScript('		fromQuery = qry.execute().getResult();');
		read.AddOperationScript('');
		read.AddOperationScript('		var #entityName# = EntityLoad("#entityName#", #id#, true);');
		read.AddOperationScript('');
		
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			if (column.getIsForeignKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				
				read.AddSimpleComment("Need to test if #column.getName()# is null that we don't try and test an empty string versus null", 2);
				
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1){
					read.StartSimpleIF('not IsNull(#entityName#.get#column.getName()#())',2);
					read.AddSimpleSet('assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#column.getName()#().get#ftIdentity#())', 3);
				}
				else{
					read.StartSimpleIF('not IsNull(#entityName#.get#ftEntityName#())',2);
					read.AddSimpleSet('assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#ftEntityName#().get#ftIdentity#())', 3);
				}
				
				
				read.EndSimpleIF(2);
				read.StartSimpleElse(2);
				read.AddSimpleSet('assertTrue(Len(fromQuery.#column.getColumn()#) eq 0)', 3);	
				read.EndSimpleIF(2);
				read.AddLineBreak();
				
			}
			else{
				read.AddSimpleComment("Need to test if #column.getName()# is null that we don't try and test an empty string versus null", 2);
				read.StartSimpleIF('not IsNull(#entityName#.get#column.getName()#())',2);
				
				if (column.getOrmType() eq "binary"){
					read.AddSimpleSet('assertEquals(toBase64(fromQuery.#column.getColumn()#), toBase64(#entityName#.get#column.getName()#()))', 3);
					
				}
				else if (column.getDataType() eq "year"){
					read.AddSimpleSet('assertEquals(Year(fromQuery.#column.getColumn()#), #entityName#.get#column.getName()#())', 3);
					
				}
				else if (column.getDataType() eq "bit"){
					read.AddSimpleSet('assertEquals(YesNoFormat(fromQuery.#column.getColumn()#), YesNoFormat(#entityName#.get#column.getName()#()))', 3);
					
				}
				else{
					read.AddSimpleSet('assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#column.getName()#())', 3);	
				}
				read.EndSimpleIF(2);
				read.StartSimpleElse(2);
				read.AddSimpleSet('assertTrue(Len(fromQuery.#column.getColumn()#) eq 0)', 3);	
				read.EndSimpleIF(2);
				read.AddLineBreak();
			}
			
			
		}
		
		read.AddOperation('');
		read.AddOperationScript('');
	
		return read;
	}
	
	/**
	* @hint Creates an Creates or Delete test for ORM objects.
	*/
	private any function createSimpleCreateOrDeleteUnitTest(required any table, string type="Create"){
		var i = 0;
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var read= New apptacular.handlers.cfc.code.function();
		read.setReturnType("void");
		read.setName("test#arguments.type#");
		
		read.addLocalVariable("fromHQL");
		
		
		read.addLineBreak();
		read.AddOperation('			<cftransaction action="begin">');
		read.AddOperationScript('		transaction action="begin"{');
		
		
		read.addLineBreak();
		read.addSimpleComment("See if we can create an object", 3);
		read.addSimpleSet('var #entityName# = EntityNew("#entityName#")', 3); 
		
		//Generate dummy content for all of those columns.
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			if (column.getIsForeignKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				var ftid = discoverValidId(foreignTable);
				
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1){
					read.addSimpleSet('#entityName#.set#column.getName()#(EntityLoad("#ftEntityName#", #ftid#, true))', 3); 
				}
				else{
					read.addSimpleSet('#entityName#.set#ftEntityName#(EntityLoad("#ftEntityName#", #ftid#, true))', 3); 
				}
				
				
				
			}
			else if (column.getisPrimaryKey() ){ 
			
			}
			else if (not config.isMagicField(column.getName())){
				read.addSimpleSet('#entityName#.set#column.getName()#("#getDummyData(column.getType())#")', 3); 
			}
		}
		
		read.addSimpleSet("EntitySave(#entityName#)",3);
		
		if(FindNoCase("delete", arguments.type)){
			read.addLineBreak();
			read.addSimpleComment("Now see if we can delete it. ", 3);
			read.addSimpleSet('var #entityName#Copy = EntityLoad("#entityName#", #entityName#.get#Identity#(), true)', 3);
			read.addSimpleSet('EntityDelete(#entityName#Copy)', 3);
			
		
		}

		read.addLineBreak();
		read.addSimpleComment("Make it go away!", 3);
		read.addSimpleSet('transactionRollback()', 3);
		
		read.AddOperation('		</cftransaction>');
		read.AddOperationScript('		};');
		
		read.addLineBreak();
		
		
	
		return read;
	}
	
	/**
	* @hint Creates an simple 200 test for input url.
	*/
	private any function createSimple200UnitTest(required string targetURL, string name="testReturns200", string entityName="", string operation=""){
		var returns200= New apptacular.handlers.cfc.code.function();
		returns200.setAccess("public");
		returns200.setReturnType("void");
		returns200.setName(arguments.name);
		returns200.addLocalVariable("cfhttp","struct");
		returns200.addLocalVariable("urlToTest","string", "#arguments.targetURL#");
	
		returns200.AddOperation('');
		returns200.AddOperation('		<cfhttp url="##urlToTest##" timeout="30" />');
		returns200.AddOperation('		<cfif not FindNoCase("200", cfhttp.statusCode)>');
		returns200.AddOperation('			<cfset debug(urlToTest) />');
		returns200.AddOperation('			<cfset debug(cfhttp) />');
		returns200.AddOperation('			<cfset fail("Simple HTTP Calls to view should work.") />');
		returns200.AddOperation('		</cfif>');
		returns200.AddOperation('');
		returns200.AddOperationScript('');
		returns200.AddOperationScript('		var httpObj = new http(url="##urlToTest##", timeout="30" );');
		returns200.AddOperationScript('		cfhttp = httpObj.send().getPrefix();');
		returns200.AddOperationScript('		if (not FindNoCase("200", cfhttp.statusCode)){');
		returns200.AddOperationScript('			debug(urlToTest);');
		returns200.AddOperationScript('			debug(cfhttp);');
		returns200.AddOperationScript('			fail("Simple HTTP Calls to #arguments.entityName# #arguments.operation# should work.");');
		returns200.AddOperationScript('		}');
		returns200.AddOperationScript('');
	
		return returns200;
	}
	
	/**
	* @hint Generates repeatable data for testing creates and updates.
	*/
	private any function getDummyData(required string type){
	
		var dummy = structNew();
		dummy['string'] = "Test String";
		dummy['numeric'] = 1;
		dummy['integer'] = 1;
		dummy['boolean'] = true;
		dummy['date'] = CreateDate(2000, 1, 1);
		dummy['datetime'] = CreateDateTime(2000, 1, 1, 0, 0, 0);
		dummy['binary'] = "##ImageGetBlob(ImageNew('#config.getCSSFilePath()##fs#appgrad.jpg'))##";
		
		return dummy[arguments.type];
	}
	
	/**
	* @hint Searchs through a table to determine if there is a valid id to use for reads and updates. 
	*/
	private any function discoverValidId(table){
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource.getName(), maxrows=1);
		qry.setSQL("select #table.getIdentity()# as id from #table.getName()#");
		var id = qry.execute().getResult().id;
		return id;		
	}

}