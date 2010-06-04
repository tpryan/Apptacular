/**
	* @hint Generates anything that will be used as a service by the generated application
*/
component  extends="codeGenerator"
{
	
	/**
	* @hint Creates the Authentication service for use with config setting "createLogin"
	*/
	public apptacular.handlers.cfc.code.cfc function createAuthenticationService(){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName("authenticationService");
	    cfc.setFileLocation(variables.config.getServiceFilePath());
		cfc.setFormat(variables.config.getCFCFormat());
		
		var username = New apptacular.handlers.cfc.code.Argument();
		username.setName('username');
		username.setRequired(true);
		username.setType('string');
		
		var password = New apptacular.handlers.cfc.code.Argument();
		password.setName('password');
		password.setRequired(true);
		password.setType('string');
		
		var auth= New apptacular.handlers.cfc.code.func();
		auth.setAccess(config.getServiceAccess());
		auth.setReturnType("boolean");
		auth.AddArgument(username);
		auth.AddArgument(password);
		auth.setName('authenticate');
		auth.setHint("Provides basic authentication for the application.");
		
		auth.AddOperationScript('		if (arguments.username eq arguments.password){');
		auth.AddOperationScript('				return true;');
		auth.AddOperationScript('		}');
		auth.AddOperationScript('		else{');
		auth.AddOperationScript('				return false;');
		auth.AddOperationScript('		}');

		auth.AddOperation('		<cfif arguments.username eq arguments.password >');
		auth.AddOperation('				<cfreturn true />');
		auth.AddOperation('		<cfelse>');
		auth.AddOperation('				<cfreturn false />');
		auth.AddOperation('		</cfif> ');

		
		cfc.addFunction(auth);
		
		return cfc;
	}
	
	/**
	* @hint Spins through all of the tables in the database and creates a service cfc for it. 
	*/
	public apptacular.handlers.cfc.code.cfc function createORMServiceCFC(required any table){
		var i=0;
		var EntityName = table.getEntityName();
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(EntityName & "Service");
	    cfc.setFileLocation(config.getServiceFilePath());
		cfc.setFormat(variables.config.getCFCFormat());
		
		//create Init method
		var init= createInitMethod(arguments.table);
		cfc.addFunction(init);
	    
		//create Count Method
		var func= createCountMethod(arguments.table);
		cfc.addFunction(func);
		
		//create list method
		var list= createListMethod(arguments.table, false);
		cfc.addFunction(list);
		
		var listPaged= createListMethod(arguments.table, true);
		cfc.addFunction(listPaged);
		
		//Create get method
		var get= This.createGetMethod(arguments.table);
		cfc.addFunction(get);
		
		//Remove views from editing
		if (not table.getIsView()){
		
			//Update Method
			var func= createUpdateMethod(arguments.table);
			cfc.addFunction(func);
			
			//Delete Method
			var func = createDestroyMethod(arguments.table);
			cfc.addFunction(func);
		
		}	
		
		//Search Method
		var search= createSearchMethod(arguments.table, false);
		cfc.addFunction(search);
		
		var searchPaged= createSearchMethod(arguments.table, true);
		cfc.addFunction(searchPaged);
		
		var searchCount= createSearchMethod(arguments.table, false, true);
		cfc.addFunction(searchCount);						
		
		return cfc;
	}
	
	/**
    * @hint Creates the delete method of the service.
    */
	public apptacular.handlers.cfc.code.func function createDestroyMethod(required any table){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		
		var entity = New apptacular.handlers.cfc.code.Argument();
		entity.setName("#EntityName#");
		entity.setRequired(true);
		entity.setType("any");
		
		var func= New apptacular.handlers.cfc.code.func();
		func.setName(variables.config.getServiceDeleteMethod());
		func.setHint("Deletes one record from #EntityName#.");
		func.setAccess(access);
		func.setReturnType("void");
		func.AddArgument(entity);
		func.AddOperation('		<cfset EntityDelete(arguments.#EntityName#) />');
		func.AddOperationScript('		EntityDelete(arguments.#EntityName#);');		

		return func;	
	}    

	/**
    * @hint Creates the update method of the service.
    */
	public apptacular.handlers.cfc.code.func function createUpdateMethod(required any table){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		
		var entity = New apptacular.handlers.cfc.code.Argument();
		entity.setName("#EntityName#");
		entity.setRequired(true);
		entity.setType("any");
		
		var func= New apptacular.handlers.cfc.code.func();
		func.setName(variables.config.getServiceUpdateMethod());
		func.setHint("Updates one record from #EntityName#.");
		func.setAccess(access);
		func.setReturnType("void");
		func.AddArgument(entity);
		func.AddSimpleSet("arguments.#EntityName#.nullifyZeroID()", 2);
		func.AddSimpleSet("EntitySave(arguments.#EntityName#)", 2);

		return func;	
	}
	
	/**
    * @hint Creates the get method of the service.
    */
	public apptacular.handlers.cfc.code.func function createGetMethod(required any table){
		var entityName = arguments.table.getEntityName();
		var type = arguments.table.getColumn(table.getIdentity()).getType();
		var access = variables.config.getServiceAccess();
		var cfcPath = variables.config.getEntityCFCPath();
		
		var id = New apptacular.handlers.cfc.code.Argument();
		id.setName('id');
		id.setRequired(true);
		
		if (arguments.table.hasCompositePrimaryKey()){
			id.setType('struct');	
		}
		else if(FindNoCase("numeric", type)){
			id.setType('numeric');
		}
		else{
			id.setType('string');
		}
		
		var func= New apptacular.handlers.cfc.code.func();
		func.setName(variables.config.getServiceGetMethod());
		func.setHint("Returns one record from #EntityName#.");
		func.setAccess(access);
		func.setReturnType("#cfcPath#.#EntityName#");
		func.AddArgument(id);
		
		func.setReturnResult('EntityLoad("#EntityName#", arguments.id, true)');
		

		return func;	
	}

	/**
    * @hint Creates the count method of the service.
    */
	public apptacular.handlers.cfc.code.func function createCountMethod(required any table){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		
		var func= New apptacular.handlers.cfc.code.func();
		func.setName(variables.config.getServiceCountMethod());
		func.setHint("Returns the count of records in #EntityName#");
		func.setAccess(access);
		func.setReturnType("numeric");
		func.setReturnResult('ormExecuteQuery("select Count(*) from #entityName#")[1]');

		return func;	
	}
	
	/**
    * @hint Creates the init method of the service.
    */
	public apptacular.handlers.cfc.code.func function createInitMethod(required any table){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		var tableName = arguments.table.getName();
		
		var func= New apptacular.handlers.cfc.code.func();
		func.setName(variables.config.getServiceInitMethod());
		func.setHint("A initialization routine, runs when object is created.");
		func.setAccess(access);
		func.setReturnType(entityName & "Service");
		func.setReturnResult('This');
		func.AddSimpleSet('This.table = "#tableName#"', 2);

		return func;	
	}
	
	/**
    * @hint Creates the list method of the service.
    */
	public apptacular.handlers.cfc.code.func function createListMethod(required any table, boolean paged=false){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		var cfcPath = variables.config.getEntityCFCPath();
		var OrderBy = table.getOrderBy();
		
		var func= New apptacular.handlers.cfc.code.func();
		
		if (arguments.paged){
			func.setName(variables.config.getServiceListPagedMethod());
			func.setHint("Returns all of the records in #EntityName#, with paging.");
			func.setReturnResult('entityLoad("#entityName#", {}, arguments.orderby, loadArgs)');
		}
		else{
			func.setName(variables.config.getServiceListMethod());
			func.setHint("Returns all of the records in #EntityName#.");
			func.setReturnResult('entityLoad("#entityName#", {}, "#orderby#")');
		}
		func.setAccess(access);
		func.setReturnType("#cfcPath#.#EntityName#[]");
		
		
		
		if (arguments.paged){
		
			func.addSimpleSet("var loadArgs = {}",2);
			
			func.startSimpleIf("arguments.offset neq 0", 2);
			func.addSimpleSet('loadArgs.offset = arguments.offset',3);
			func.endSimpleIf(2);
			
			func.startSimpleIf("arguments.maxresults neq 0", 2);
			func.addSimpleSet('loadArgs.maxresults = arguments.maxresults',3);
			func.endSimpleIf(2);
			
			
			var offset = New apptacular.handlers.cfc.code.Argument();
			offset.setName('offset');
			offset.setRequired(false);
			offset.setType('numeric');
			offset.setDefaultValue(0);
			func.AddArgument(offset);
			
			var maxresults = New apptacular.handlers.cfc.code.Argument();
			maxresults.setName('maxresults');
			maxresults.setRequired(false);
			maxresults.setType('numeric');
			maxresults.setDefaultValue(0);
			func.AddArgument(maxresults);
			
			var orderbyarg = New apptacular.handlers.cfc.code.Argument();
			orderbyarg.setName('orderby');
			orderbyarg.setRequired(false);
			orderbyarg.setType('string');
			orderbyarg.setDefaultValue(OrderBy);
			func.AddArgument(orderbyarg);
			
		}
		return func;	
	}
	
	/**
    * @hint Creates the search method of the service.
    */
	public apptacular.handlers.cfc.code.func function createSearchMethod(required any table, boolean paged=false, boolean count=false){
		var entityName = arguments.table.getEntityName();
		var access = variables.config.getServiceAccess();
		var cfcPath = variables.config.getEntityCFCPath();
		var OrderBy = table.getOrderBy();
		var columns = table.getColumns();
		
		if (arguments.count){
			arguments.paged= false;
		}
		
		
		var func= New apptacular.handlers.cfc.code.func();
		
		if (arguments.paged){
			func.setName(variables.config.getServiceSearchPagedMethod());
			func.setHint("Performs search against #EntityName#., with paging.");
		}
		else if(arguments.count){
			func.setName(variables.config.getServiceSearchCountMethod());
			func.setHint("Determines total number of results of search for paging purposes.");
		}
		else{
			func.setName(variables.config.getServiceSearchMethod());
			func.setHint("Performs search against #EntityName#.");
		}
		
		
		func.setAccess(access);
		func.addLocalVariable("hqlString","string","");
		func.addLocalVariable("whereClause","string","");
		func.addLocalVariable("params","struct","{}", false);
		
		if (arguments.count){
			func.setReturnType("numeric");
		}
		else{
			func.setReturnType("#cfcPath#.#EntityName#[]");
		}
		
		var q = New apptacular.handlers.cfc.code.Argument();
		q.setName("q");
		q.setType("string");
		q.setDefaultValue("");
		func.addArgument(q);
		
		if (arguments.count){
			func.addSimpleSet('hqlString = hqlString & "SELECT count(*) " ',2);
		}
		
		func.addSimpleSet('hqlString = hqlString & "FROM #EntityName#" ',2);
		
		
		// handle manipulating the input arguments to be appropriate to pass to entityLoad
		if (arguments.paged){
			func.startSimpleIf("arguments.offset neq 0", 2);
			func.addSimpleSet('params.offset = arguments.offset',3);
			func.endSimpleIf(2);
			
			func.startSimpleIf("arguments.maxresults neq 0", 2);
			func.addSimpleSet('params.maxresults = arguments.maxresults',3);
			func.endSimpleIf(2);
			
			var offset = New apptacular.handlers.cfc.code.Argument();
			offset.setName('offset');
			offset.setRequired(false);
			offset.setType('numeric');
			offset.setDefaultValue(0);
			func.AddArgument(offset);
			
			var maxresults = New apptacular.handlers.cfc.code.Argument();
			maxresults.setName('maxresults');
			maxresults.setRequired(false);
			maxresults.setType('numeric');
			maxresults.setDefaultValue(0);
			func.AddArgument(maxresults);
			
			var orderbyarg = New apptacular.handlers.cfc.code.Argument();
			orderbyarg.setName('orderby');
			orderbyarg.setRequired(false);
			orderbyarg.setType('string');
			orderbyarg.setDefaultValue(OrderBy);
			func.AddArgument(orderbyarg);
			
			
		}
		
		//Build the where clause
		func.StartSimpleIf('len(arguments.q) gt 0', 2);		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i].getName();
			
			if (FindNoCase("char",columns[i].getDataType())){
				func.addSimpleSet('whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|")',3);
			}
		}
		
		func.AddSimpleSet('whereClause = Replace(whereClause, "|", " OR ", "all")', 3);
		func.EndSimpleIf(2);
		
		//Add Where Clause
		func.StartSimpleIf('len(whereClause) gt 0', 2);		
		func.addSimpleSet('hqlString = hqlString & " WHERE " & whereClause',3);
		func.EndSimpleIf(2);
		
		//Add order by
		if (arguments.paged){
			func.addSimpleSet('hqlString = hqlString & " ORDER BY ##arguments.orderby##"',3);
		}
		else if (not arguments.count){
			func.addSimpleSet('hqlString = hqlString & " ORDER BY #OrderBy#"',3);
		}
		//Execute and return
		if (arguments.count){
			func.setReturnResult('ormExecuteQuery(hqlString, false, params)[1]');
		}
		else{
			func.setReturnResult('ormExecuteQuery(hqlString, false, params)');
		}
		
		
		
		
		
		
		
		return func;	
	}


}