/**
* @hint Generates all code that has anything to do with MXUnit testing.  
*/
component  extends="codeGenerator"
{
	/**
	* @hint Creates the test for the application's index.cfm
	*/
	public apptacular.handlers.cfc.code.cfc function createIndexTest(){
		
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
		var loginTest= New apptacular.handlers.cfc.code.func();
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
	public apptacular.handlers.cfc.code.cfc function createViewsTest(required any table){
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
		
		var id = table.discoverValidId(format='url');
		
		
		
		
		if (table.getRowCount() > 0){
			// Add basic 200 test for read
			if (table.hasCompositePrimaryKey()){
				var readURL = baseurl & "?method=read&" & id ;
			}
			else{
				var readURL = baseurl & "?method=read&" & table.getIdentity() & "=" & id ;
			}
		
			var readreturns200=createSimple200UnitTest(readURL, "testReadReturns200", entityName, "read"); 
			testView.addFunction(readreturns200);


			// Add basic 200 test for edit
			if (table.hasCompositePrimaryKey()){
				var editURL = baseurl & "?method=edit&" & id ;
			}
			else{
				var editURL = baseurl & "?method=edit&" & table.getIdentity() & "=" & id ;
			}
			
			var editreturns200=createSimple200UnitTest(editURL, "testEditReturns200", entityName, "edit"); 
			testView.addFunction(editreturns200);
			
			// Add basic 200 test for clone
			if (table.hasCompositePrimaryKey()){
				var editURL = baseurl & "?method=clone&" & id ;
			}
			else{
				var editURL = baseurl & "?method=clone&" & table.getIdentity() & "=" & id ;
			}
			
			var clonereturns200=createSimple200UnitTest(editURL, "testCloneReturns200", entityName, "clone"); 
			testView.addFunction(clonereturns200);
		}
		
		
	
		return testView;
	}
	
	/**
	* @hint Generates the test that makes sure that the application is correctly wired through RemoteFacade.cfc
	*/
	public apptacular.handlers.cfc.code.cfc function createGlobalTest(){
		
		var testGlobal  = New apptacular.handlers.cfc.code.cfc();
	    testGlobal.setName("testGlobal");
	    testGlobal.setFileLocation(variables.config.getTestFilePath() & fs & "_" );
		testGlobal.setFormat(variables.config.getCFCFormat());
		testGlobal.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");
		
		
		var isAppWorking= New apptacular.handlers.cfc.code.func();
		isAppWorking.setReturnType("void");
		isAppWorking.setName("testIsApplicationWorking");
		
		isAppWorking.addSimpleSet('AssertTrue(IsDefined("application"), "This occur might occur because you have not pointed your ColdFusion Builder project to the remotefacade.cfc (#config.getTestURL()#/remoteFacade.cfc)in this project.")', 2);
		testGlobal.addFunction(isAppWorking);
		return testGlobal;
	}
	
	/**
	* @hint Creates a CRUD test for Entities.
	*/
	public apptacular.handlers.cfc.code.cfc function createEntityTest(required any table){
		var entityName = table.getEntityName();
		var columns = table.getColumns();

		var testEntity  = New apptacular.handlers.cfc.code.cfc();
	    testEntity.setName("test#entityName#");
	    testEntity.setFileLocation(variables.config.getTestFilePath() & fs & "entity");
		testEntity.setFormat(variables.config.getCFCFormat());
		testEntity.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");

		if (table.getIsView()){
		
			var id = table.discoverValidId();
			
			if (len(id) > 0){
				//Create Read Test
				var read = createSimpleReadUnitTest(table=table);
				testEntity.addFunction(read);
			}	
		
		}
		else{
			//Create Create Test
			var create = createSimpleCreateOrDeleteUnitTest(table=table);
			testEntity.addFunction(create);
	
			var id = table.discoverValidId();
			
			if (len(id) > 0){
				//Create Read Test
				var read = createSimpleReadUnitTest(table=table);
				testEntity.addFunction(read);
				
				//Create Update Test
				var update = createSimpleUpdateUnitTest(table=table);
				testEntity.addFunction(update);
			}
			
			//Create Delete Test
			var delete = createSimpleCreateOrDeleteUnitTest(table=table, type="Delete");
			testEntity.addFunction(delete);
			
			//deal with the idiocy of MSSQL
			if (FindNoCase("Microsoft",variables.datasource.getEngine()) and table.hasRealIdentity()){
				var tearDown = createTearDownUnitTestforMSSQL(table=table);
				testEntity.addFunction(tearDown);
			}
			
		}

		
		

		return testEntity;
	}
	
	
	
	/**
	* @hint Creates a CRUD test for Services.
	*/
	public apptacular.handlers.cfc.code.cfc function createServiceTest(required any table){
		var entityName = table.getEntityName();
		var columns = table.getColumns();

		var testEntity  = New apptacular.handlers.cfc.code.cfc();
	    testEntity.setName("test#entityName#");
	    testEntity.setFileLocation(variables.config.getTestFilePath() & fs & variables.config.getServiceFolder());
		testEntity.setFormat(variables.config.getCFCFormat());
		testEntity.setExtends(variables.config.getMXUNITCFCPAth() & ".framework.TestCase");

		if (table.getIsView()){
		
			var id = table.discoverValidId();
			
			if (len(id) > 0){
				//Create Read Test
				var read = createSimpleReadUnitTest(table=table, isService=true);
				testEntity.addFunction(read);
			}	
		
		}
		else{
			//Create Create Test
			var create = createSimpleCreateOrDeleteUnitTest(table=table, isService=true);
			testEntity.addFunction(create);
	
			var id = table.discoverValidId();
			
			if (len(id) > 0){
				//Create Read Test
				var read = createSimpleReadUnitTest(table=table, isService=true);
				testEntity.addFunction(read);
				
				//Create Update Test
				var update = createSimpleUpdateUnitTest(table=table, isService=true);
				testEntity.addFunction(update);
			}
			
			//Create Delete Test
			var delete = createSimpleCreateOrDeleteUnitTest(table=table, isService=true, type="Delete");
			testEntity.addFunction(delete);
		}

		
		

		return testEntity;
	}
	
		
	
	/**
	* @hint Creates the remote facade that wires the IDE runner through the application scope of the application. 
	*/
	public apptacular.handlers.cfc.code.cfc function createRemoteFacade(){
	
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
	public apptacular.handlers.cfc.code.cfc function createHttpAntRunner(){
	
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
	public apptacular.handlers.cfc.code.cfpage function createDirectoryRunner(string location=""){
		
		if (len(arguments.location)){
			var fileLocation = arguments.location;
		}
		else{
			var fileLocation = variables.config.getTestFilePath();
		}
		
		var runner = New apptacular.handlers.cfc.code.cfpage("runner", fileLocation);
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
	public apptacular.handlers.cfc.code.build function createAntRunner(){
		var runner = New apptacular.handlers.cfc.code.build();
		
		var packagename = "#datasource.getName()#_#config.getCFCFormat()#";
		
		runner.setProjectName(variables.datasource.getName());
		runner.setProjectDefault("test");
		runner.setFileLocation(variables.config.getTestFilePath());
		
		runner.addProperty("mxunit.jar", variables.config.getMXUnitFilePath() & "/ant/lib/mxunit-ant-java5.jar");
		//This is a hack to make sure that CF doesn't even run any debugging while ANT tests are running.
		runner.addProperty("test.dir", variables.config.getTestFilePath() );
		runner.addProperty("runner.cfc", variables.config.getTestRelativePath() & "/HttpAntRunner.cfc");
		runner.addProperty("server", cgi.server_name);
		runner.addProperty("cfc.path", variables.config.getTestCFCPath());
		
		runner.appendBody('');
		runner.appendBody('	<target name="test" description="Run a dir of tests recursively">');
		runner.appendBody('');
		runner.appendBody('		<taskdef name="mxunittask" classname="org.mxunit.ant.MXUnitAntTask" classpath="${mxunit.jar}" />');
		runner.appendBody('		');
		runner.appendBody('		<mxunittask server="${server}" defaultrunner="${runner.cfc}" haltonerror="true" haltonfailure="true" verbose="true" outputdir="${test.dir}">');
		runner.appendBody('			<directory path="${test.dir}" recurse="true" componentPath="${cfc.path}" packageName="#packagename#" />');
		runner.appendBody('		</mxunittask>');
		runner.appendBody('');
		runner.appendBody('	</target>');

		
		return runner;
	}
	
	/**
	* @hint Creates an update test for ORM objects.
	*/
	private apptacular.handlers.cfc.code.func function createSimpleUpdateUnitTest(required any table, boolean isService=false){
		var i = 0;
		var id = table.discoverValidId();
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var update= New apptacular.handlers.cfc.code.func();
		update.setReturnType("void");
		update.setName("testUpdate");
		var composites = StructNew();
		var compositeArray = ArrayNew(1);
		
		//Dealing with those pesky composite keys again. 
		if (table.hasCompositePrimaryKey()){
			var idString = id;
		}
		else{
			var idString = "'#id#'";
		}
		
		
	
		update.addLineBreak();
		update.AddOperation('			<cftransaction action="begin">');
		update.AddOperationScript('		transaction action="begin"{');	
		
		if (arguments.isService){
			update.addSimpleSet('var #entityName#Service = new #variables.config.getserviceCFCPath()#.#entityName#Service()', 3);
		}
		
		update.addSimpleSet('var #entityName# = EntityLoad("#entityName#", #idString#, true)', 3);
		
		
		//Convert all of these columns to dummy data.
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			if (column.getisPrimaryKey() ){ 
				continue;
			}
			
			if (column.getisForeignKey() AND column.getIsMemeberOfCompositeForeignKey()){
				if (not StructKeyExists(composites,column.getForeignKeyTable() )){
					composites[column.getForeignKeyTable()] = column.getForeignKey();
       			}
				else{
					composites[column.getForeignKeyTable()] = ListAppend(composites[column.getForeignKeyTable()], column.getForeignKey());
				}
				
				continue;		
			}	
			
			
			else if (column.getIsForeignKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				var ftid = foreignTable.discoverValidId();
				
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1){
					update.addSimpleSet('#entityName#.set#column.getName()#(EntityLoad("#ftEntityName#", "#ftid#", true))', 3);  
				}
				else{
					update.addSimpleSet('#entityName#.set#ftEntityName#(EntityLoad("#ftEntityName#", "#ftid#", true))', 3); 
				}
				
				
				
			}
			
			else if (not config.isMagicField(column.getName())){
				update.addSimpleSet('#entityName#.set#column.getName()#("#getDummyData(column)#")', 3); 
			}
		}
		
		
		//handle composite foreign key relationships
		for (i=1; i <= ArrayLen(compositeArray); i++){
	       	var fTable = dataSource.getTable(compositeArray[i]);
			var ftEntityName = foreignTable.getEntityName();
			var ftid = foreignTable.discoverValidId(excludeStruct[column.getforeignKeyTable()]);
			var ftidString  = '#ftid#';
			var setterName = ftEntityName;
			
			update.addSimpleSet('#entityName#.set#setterName#(EntityLoad("#ftEntityName#", #ftidString#, true))', 3);
		
		}
		
		
		if (arguments.isService){
			update.addSimpleSet('#entityName#Service.update(#entityName#)', 3);
		}
		else{
			update.addSimpleSet("EntitySave(#entityName#)",3);
		}
		
		
		
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
	private apptacular.handlers.cfc.code.func function createSimpleReadUnitTest(required any table, boolean isService=false){
		var i = 0;
		var id = table.discoverValidId();
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var SchemaName = table.getSchema();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var read= New apptacular.handlers.cfc.code.func();
		read.setReturnType("void");
		read.setName("testRead");
		read.addLocalVariable("fromQuery");
		var composites = StructNew();
		var compositeArray = ArrayNew(1);
		
		
		//Slight tweak because I was running into case sensitivity issues.
		var idColumn = table.getColumn(table.getIdentity());
		
		//Dealing with those pesky composite keys again. 
		if (table.hasCompositePrimaryKey()){
			var	WhereClause = Replace(ReplaceList(id, "{,}",","  ), ",", " AND ", "ALL");
			var idString = id;
		}
		else{
			
			if (FindNoCase("Int", idColumn.getDataType())){
				var	WhereClause = "#idColumn.getColumn()# = #id#";
				var idString = "#id#";
			}
			else{
				var	WhereClause = "#idColumn.getColumn()# = '#id#'";
				var idString = "'#id#'";
			}
			
		}
		
		if (Len(SchemaName) > 0){
			var sql = "SELECT * FROM #SchemaName#.#tableName# WHERE #WhereClause#";
		}
		else{
			var sql = "SELECT * FROM #tableName# WHERE #WhereClause#";
		}
		
		
		if (arguments.isService){
			read.addSimpleSet('var #entityName#Service = new #variables.config.getserviceCFCPath()#.#entityName#Service()', 2);
		}
		
		read.AddLineBreak('');
		
		read.AddOperation('		<cfquery name="fromQuery" datasource="#dsname#">');
		read.AddOperation('			#sql#');
		read.AddOperation('		</cfquery>');
		
		read.AddOperationScript('		var qry = new Query(datasource="#dsname#");');
		read.AddOperationScript('		qry.setSQL("#sql#");');
		read.AddOperationScript('		fromQuery = qry.execute().getResult();');
		
		read.AddLineBreak('');
		
		
		if (arguments.isService){
			read.addSimpleSet('var #entityName# = #entityName#Service.get(#idString#)', 2);
		}
		else{
			read.AddSimpleSet('var #entityName# = EntityLoad("#entityName#", #idString#, true)', 2);
		}
		
		
		
		read.AddLineBreak('');
		
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			
			if (column.getisForeignKey() AND column.getIsMemeberOfCompositeForeignKey()){
				if (not StructKeyExists(composites,column.getForeignKeyTable() )){
					composites[column.getForeignKeyTable()] = column.getForeignKey();
       			}
				else{
					composites[column.getForeignKeyTable()] = ListAppend(composites[column.getForeignKeyTable()], column.getForeignKey());
				}
				
				continue;		
			}	
			else if (column.getIsForeignKey() and not column.getIsPrimaryKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				
				read.AddSimpleComment("Need to test if #column.getName()# is null that we don't try and test an empty string versus null", 2);
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1 AND not table.hasCompositePrimaryKey()){
					read.StartSimpleIF('not IsNull(#entityName#.get#column.getName()#())',2);
					read.AddSimpleSet('assertEquals(fromQuery["#column.getColumn()#"][1], #entityName#.get#column.getName()#().get#ftIdentity#())', 3);
				}
				else{
					read.StartSimpleIF('not IsNull(#entityName#.get#ftEntityName#())',2);
					read.AddSimpleSet('assertEquals(fromQuery["#column.getColumn()#"][1], #entityName#.get#ftEntityName#().get#ftIdentity#())', 3);
				}
				
				read.EndSimpleIF(2, true);
				read.StartSimpleElse(2);
				read.AddSimpleSet('assertTrue(Len(fromQuery["#column.getColumn()#"][1]) eq 0)', 3);	
				read.EndSimpleIF(2);
				read.AddLineBreak();
				
			}
			else{
				
				if (column.getIsPrimaryKey()){
					read.AddSimpleComment("Primary Key Test", 2);
				}
				
				read.AddSimpleComment("Need to test if #column.getName()# is null that we don't try and test an empty string versus null", 2);
				read.StartSimpleIF('not IsNull(#entityName#.get#column.getName()#())',2);
				
				if (column.getTestType() eq "binary"){
					read.AddSimpleSet('assertEquals(Left(toBase64(fromQuery["#column.getColumn()#"][1]),100), Left(toBase64(#entityName#.get#column.getName()#()), 100))', 3);
				}
				else if (column.getDataType() eq "money"){
					read.AddSimpleSet('assertEquals(DollarFormat(Round(fromQuery["#column.getColumn()#"][1])), DollarFormat(Round(#entityName#.get#column.getName()#())))', 3);
				}
				else if (column.getTestType() eq "year"){
					read.AddSimpleSet('assertEquals(Year(fromQuery["#column.getColumn()#"][1]), #entityName#.get#column.getName()#())', 3);
				}
				else if (column.getOrmType() eq "integer"){
					read.AddSimpleSet('assertEquals(numberFormat(fromQuery["#column.getColumn()#"][1], "_"), numberFormat(#entityName#.get#column.getName()#(), "_"))', 3);
				}
				else if (column.getTestType() eq "numeric"){
					read.AddSimpleSet('assertEquals(numberFormat(Round(fromQuery["#column.getColumn()#"][1]), "_.______"), numberFormat(Round(#entityName#.get#column.getName()#()), "_.______"))', 3);
				}
				
				else if (column.getTestType() eq "bit"){
					read.AddSimpleSet('assertEquals(YesNoFormat(fromQuery["#column.getColumn()#"][1]), YesNoFormat(#entityName#.get#column.getName()#()))', 3);
					
				}
				else if (column.getTestType() eq "date"){
					read.AddSimpleSet('var formatedExpected = DateFormat(fromQuery["#column.getColumn()#"][1], "yyyy-dd-mm") & " " & TimeFormat(fromQuery["#column.getColumn()#"][1], "hh:mm:ss.l")', 3);
					read.AddSimpleSet('var formatedActual = DateFormat(#entityName#.get#column.getName()#(), "yyyy-dd-mm") & " " & TimeFormat(#entityName#.get#column.getName()#(), "hh:mm:ss.l")', 3);
					read.AddSimpleSet('assertEquals(formatedExpected, formatedActual)', 3);
					
				}
				else{
					read.AddSimpleSet('assertEquals(fromQuery["#column.getColumn()#"][1], #entityName#.get#column.getName()#())', 3);	
				}
				read.EndSimpleIF(2, true);
				read.StartSimpleElse(2);
				read.AddSimpleSet('assertTrue(Len(fromQuery["#column.getColumn()#"][1]) eq 0)', 3);	
				read.EndSimpleIF(2);
				read.AddLineBreak();
			}
			
			
		}
		compositeArray = StructKeyArray(composites);
		
		//handle composite foreign key relationships
		for (i=1; i <= ArrayLen(compositeArray); i++){
	       	var fTable = dataSource.getTable(compositeArray[i]);
			var ftEntityName = fTable.getEntityName();
			var ftid = fTable.discoverValidId();
			var ftidString  = '#ftid#';
			var setterName = ftEntityName;
			var fklist = composites[compositeArray[i]];
			
			read.AddSimpleComment("Testing for a composite Foreign Key.  That's right I generate unit tests for COMPOSITE FOREIGN KEYS, that's how much I rock. ", 2);
			read.StartSimpleIF('not IsNull(#entityName#.get#ftEntityName#())',2);
			
			for (j = 1; j <= ListLen(fklist); j++ ){
				var fk = ListGetAt(fklist, j);
				read.AddSimpleSet('assertEquals(fromQuery["#fk#"][1], #entityName#.get#ftEntityName#().get#fk#())', 3);
			}
			
			read.EndSimpleIF(2, true);
			read.StartSimpleElse(2);
			for (j = 1; j <= ListLen(fklist); j++ ){
				var fk = ListGetAt(fklist, j);
				read.AddSimpleSet('assertTrue(Len(fromQuery["#fk#"][1]) eq 0)', 3);	
			}
			
			read.EndSimpleIF(2);		
		
		}
		
		read.AddOperation('');
		read.AddOperationScript('');
	
		return read;
	}
	
	/**
	* @hint Creates an Creates or Delete test for ORM objects.
	*/
	private apptacular.handlers.cfc.code.func function createSimpleCreateOrDeleteUnitTest(required any table, boolean isService=false, string type="Create"){
		var i = 0;
		var entityName = table.getEntityName();
		var tableName = table.getName();
		var identity = table.getIdentity();
		var dsname = variables.datasource.getName();
		var columns = table.getColumns();
		var read= New apptacular.handlers.cfc.code.func();
		var excludeStruct = {};
		var composites = StructNew();
		var compositeArray = ArrayNew(1);
		
		read.setReturnType("void");
		read.setName("test#arguments.type#");
		
		read.addLocalVariable("fromHQL");
		
		
		if (arguments.isService){
			read.addSimpleSet('var #entityName#Service = new #variables.config.getserviceCFCPath()#.#entityName#Service()', 2);
		}
		
		
		read.addLineBreak();
		read.AddOperation('			<cftransaction action="begin">');
		read.AddOperationScript('		transaction action="begin"{');
		
		
		read.addLineBreak();
		read.addSimpleComment("See if we can create an object", 3);
		read.addSimpleSet('var #entityName# = EntityNew("#entityName#")', 3); 
		
		//Generate dummy content for all of those columns.
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			if (column.getisPrimaryKey() and FindNoCase("numeric", column.getTestType()) AND not column.getIsForeignKey() AND column.getIsIdentity()){ 
				continue;
			}
			
			if (column.getisComputed() ){ 
				read.addSimpleSet('#entityName#.set#column.getName()#("#getDummyData(column)#")', 3);
				continue; 
			}
			
			
			
			if (not StructKeyExists(excludeStruct, column.getforeignKeyTable())){
				excludeStruct[column.getforeignKeyTable()]="";
			}
			if (column.getIsPrimaryKey() AND column.getIsForeignKey()) {
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				var ftid = foreignTable.discoverValidId(excludeStruct[column.getforeignKeyTable()]);
				
				var ftidString  = '"#ftid#"';
				var setterName = column.getName();
				
				read.addSimpleSet('#entityName#.set#setterName#(#ftidString#)', 3);  
				
			}
			else if (config.isMagicField(column.getName())){
				read.addSimpleComment("So it appears that eventHandlers don't fire in transactions, so workaround.", 3);
				read.addSimpleSet('#entityName#.set#column.getName()#(Now())', 3);
			}
			
			else if (column.getisForeignKey() AND column.getIsMemeberOfCompositeForeignKey()){
				if (not StructKeyExists(composites,column.getForeignKeyTable() )){
					composites[column.getForeignKeyTable()] = column.getForeignKey();
       			}
				else{
					composites[column.getForeignKeyTable()] = ListAppend(composites[column.getForeignKeyTable()], column.getForeignKey());
				}
				
				continue;		
			}	
			
			else if (column.getIsForeignKey()){
				var foreignTable = variables.datasource.getTable(column.getforeignKeyTable());
				
				var ftIdentity = foreignTable.getIdentity();
				var ftEntityName = foreignTable.getEntityName();
				var ftid = foreignTable.discoverValidId(excludeStruct[column.getforeignKeyTable()]);
				excludeStruct[column.getforeignKeyTable()] = ListAppend(excludeStruct[column.getforeignKeyTable()], ftid);
				
			
				
				if (table.getForeignTableCount(foreignTable.getName()) gt 1){
					var setterName = column.getName();
				}
				else{
					var setterName = ftEntityName;
				}
				
				if (foreignTable.hasCompositePrimaryKey()){
					var ftidString  = '#ftid#';
				}
				else{
					var ftidString  = '"#ftid#"';
				}
				
				
				read.addSimpleSet('#entityName#.set#setterName#(EntityLoad("#ftEntityName#", #ftidString#, true))', 3);  
				
				
			}
			else {
				read.addSimpleSet('#entityName#.set#column.getName()#("#getDummyData(column)#")', 3); 
			}
			
			
		}
		
		//handle composite foreign key relationships
		for (i=1; i <= ArrayLen(compositeArray); i++){
	       	var fTable = dataSource.getTable(compositeArray[i]);
			var ftEntityName = foreignTable.getEntityName();
			var ftid = foreignTable.discoverValidId(excludeStruct[column.getforeignKeyTable()]);
			var ftidString  = '#ftid#';
			var setterName = ftEntityName;
			
			read.addSimpleSet('#entityName#.set#setterName#(EntityLoad("#ftEntityName#", #ftidString#, true))', 3);
		
		}
		
		if (arguments.isService){
			read.addSimpleSet('#entityName#Service.update(#entityName#)', 3);
		}
		else{
			read.addSimpleSet("EntitySave(#entityName#)",3);
		}
		
		if(FindNoCase("delete", arguments.type)){
		
			read.addLineBreak();
			read.addSimpleComment("Now see if we can delete it. ", 3);
		
			if (table.HasCompositePrimaryKey()){
				var pkColumns = table.getPrimaryKeyColumns();
				
				read.addSimpleSet('var idStruct = {}', 3);
				
				for (i=1; i <= ArrayLen(pkColumns); i++){
					read.addSimpleSet('idStruct["#pkColumns[i].getName()#"] = #entityName#.get#pkColumns[i].getName()#()', 3);
				}
				read.addSimpleSet('var #entityName#Copy = EntityLoad("#entityName#", idStruct, true)', 3);
			}
			else{
				
				read.addSimpleSet('var #entityName#Copy = EntityLoad("#entityName#", #entityName#.get#Identity#(), true)', 3);
				
			}
		
		
			if (arguments.isService){
				read.addSimpleSet('#entityName#Service.destroy	(#entityName#)', 3);
			}
			else{
				read.addSimpleSet('EntityDelete(#entityName#Copy)', 3);
			}

		
			
		
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
	private apptacular.handlers.cfc.code.func function createSimple200UnitTest(required string targetURL, string name="testReturns200", string entityName="", string operation=""){
		var returns200= New apptacular.handlers.cfc.code.func();
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
		returns200.AddOperationScript('			fail("Simple HTTP Calls to #arguments.entityName#.#arguments.operation#() should work.");');
		returns200.AddOperationScript('		}');
		returns200.AddOperationScript('');
	
		return returns200;
	}
	
	private apptacular.handlers.cfc.code.func function createTearDownUnitTestforMSSQL(required any table){
		var tableName = table.getName();
		var SchemaName = table.getSchema();
		var identity = table.getIdentity();
		//Slight tweak because I was running into case sensitivity issues.
		var idColumn = table.getColumn(identity).getColumn();
		var dsname = variables.datasource.getName();
		
		if (Len(SchemaName) > 0){
			var tableReference = "#SchemaName#.#tableName#";
		}
		else{
			var tableReference = "#tableName#";
		}
		
		
		var tearDown= New apptacular.handlers.cfc.code.func();
		tearDown.setReturnType("void");
		tearDown.setName("tearDown");
		tearDown.AddSimpleSet('var idSQL = "SELECT #idColumn# as high FROM #tableReference# ORDER BY #idColumn# DESC "', 2);
		tearDown.AddSimpleSet('var qry = New query()', 2);
		
		
		if (table.getRowCount() gt 0){
			tearDown.AddSimpleComment('Figure out the right value for the identity');
			tearDown.AddSimpleSet('qry.setDataSource("' & dsname &'")', 2);
			tearDown.AddSimpleSet('qry.setMaxRows(1)', 2);
			tearDown.AddSimpleSet('qry.setSQL(idSQL)', 2);
			tearDown.AddSimpleSet('var newidentity=qry.execute().getResult().high', 2);
		}
		else{
			tearDown.AddSimpleComment('There are no records in the table so start at 1');
			tearDown.AddSimpleSet('var newidentity=1', 2);
		}
		
		
		tearDown.AddSimpleComment('Reset the identity');
		tearDown.AddSimpleSet('var resetSQL = "DBCC CHECKIDENT (''#tableReference#'', RESEED, ##newidentity##)"', 2);
		tearDown.AddSimpleSet('qry.setSQL(resetSQL)', 2);
		tearDown.AddSimpleSet('qry.execute()', 2);
		
		
	
		return tearDown;
	}
	
	
	
	/**
	* @hint Generates repeatable data for testing creates and updates.
	*/
	private any function getDummyData(required any column){
	
	
		var type = arguments.column.getTestType();
		var dummy = structNew();
		dummy['string'] = "Test String";
		dummy['numeric'] = 2;
		dummy['integer'] = 2;
		dummy['bit'] = true;
		dummy['boolean'] = true;
		dummy['xml'] = XMLNew();
		dummy['year'] = 2000;
		dummy['date'] = CreateDate(2000, 1, 1);
		dummy['datetime'] = CreateDateTime(2000, 1, 1, 0, 0, 0);
		dummy['binary'] = "##ImageGetBlob(ImageNew('#config.getCSSFilePath()##fs#appgrad.jpg'))##";
		dummy['uniqueidentifier'] = "9aadcb0d-36cf-483f-84d8-585c2d4ec6e8";
	
		var returnValue = dummy[arguments.column.getTestType()];
		
		if (FindNoCase("string", type)){
			returnValue = left(returnValue, column.getLength());
		}
		
		if (FindNoCase("date", type) and FindNoCase("end", arguments.column.getName())){
			returnValue = DateAdd("d", 1, returnValue);		
		}
		return returnValue;
	}
	

}