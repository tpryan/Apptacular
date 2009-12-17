component  extends="codeGenerator"
{
	
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
		var listreturns200=createSimple200UnitTest(listURL, "testListReturns200"); 
		testView.addFunction(listreturns200);
		
		// Add basic 200 test for new
		var newURL = baseurl & "?method=edit";
		var newreturns200=createSimple200UnitTest(newURL, "testNewReturns200"); 
		testView.addFunction(newreturns200);
		
		var id = discoverValidId(table);
		
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
	
	public any function createGlobalTest(){
		
		var testGlobal  = New apptacular.handlers.cfc.code.cfc();
	    testGlobal.setName("testGlobal");
	    testGlobal.setFileLocation(variables.config.getTestFilePath() & fs & "_" );
		testGlobal.setFormat(variables.config.getCFCFormat());
		testGlobal.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		
		var isAppWorking= New apptacular.handlers.cfc.code.function();
		isAppWorking.setReturnType("void");
		isAppWorking.setName("testIsApplicationWorking");
		
		isAppWorking.addSimpleSet('AssertTrue(IsDefined("application"), "This occur might occur because you have not pointed your ColdFusion Builder project to the remotefacade.cfc in this project.")', 2);
		testGlobal.addFunction(isAppWorking);
		return testGlobal;
	}
	
	private any function discoverValidId(table){
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource.getName(), maxrows=1);
		qry.setSQL("select #table.getIdentity()# as id from #table.getName()#");
		var id = qry.execute().getResult().id;
		return id;		
	}
	
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
				
				update.addSimpleSet('#entityName#.set#ftEntityName#(EntityLoad("#ftEntityName#", #ftid#, true))', 3); 
				
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
				read.AddOperation('		<cfset assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#ftEntityName#().get#ftIdentity#()) />');
				read.AddOperationScript('		assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#ftEntityName#().get#ftIdentity#());');
			}
			else{
				read.AddOperation('		<cfset assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#column.getName()#()) />');
				read.AddOperationScript('		assertEquals(fromQuery.#column.getColumn()#, #entityName#.get#column.getName()#());');
			}
		}
		
		read.AddOperation('');
		read.AddOperationScript('');
	
		return read;
	}
	
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
				
				read.addSimpleSet('#entityName#.set#ftEntityName#(EntityLoad("#ftEntityName#", #ftid#, true))', 3); 
				
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
	
	private any function getDummyData(required string type){
	
		var dummy = structNew();
		dummy['string'] = "Test String";
		dummy['numeric'] = 1;
		dummy['boolean'] = true;
		dummy['date'] = CreateDate(2000, 1, 1);
		dummy['datetime'] = CreateDateTime(2000, 1, 1, 0, 0, 0);
		
		return dummy[arguments.type];
	}
	
	

}