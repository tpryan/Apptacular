component  extends="codeGenerator"
{
	
	public any function createAuthenticationService(){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName("authenticationService");
	    cfc.setFileLocation(variables.config.getServiceFilePath());
		
		var username = New apptacular.handlers.cfc.code.Argument();
		username.setName('username');
		username.setRequired(true);
		username.setType('string');
		
		var password = New apptacular.handlers.cfc.code.Argument();
		password.setName('password');
		password.setRequired(true);
		password.setType('string');
		
		var auth= New apptacular.handlers.cfc.code.function();
		auth.setAccess(config.getServiceAccess());
		auth.setReturnType("boolean");
		auth.AddArgument(username);
		auth.AddArgument(password);
		auth.setName('authenticate');
		
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
	
	public any function createORMServiceCFC(required any table){
		var i=0;
		var EntityName = table.getEntityName();
		var OrderBy = table.getOrderBy();
		var cfcPath = variables.config.getEntityCFCPath();
		var columns = table.getColumns();
		var access = variables.config.getServiceAccess();
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(EntityName & "Service");
	    cfc.setFileLocation(config.getServiceFilePath());
		cfc.setFormat(variables.config.getCFCFormat());
	    
		//create Count Method
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('count');
		func.setAccess(access);
		func.setReturnType("numeric");
		func.setReturnResult('ormExecuteQuery("select Count(*) from #entityName#")[1]');
		cfc.addFunction(func);
		
		//create list method
		var list= New apptacular.handlers.cfc.code.function();
		list.setName('list');
		list.setAccess(access);
		list.setReturnType("#cfcPath#.#EntityName#[]");
		list.setReturnResult('entityLoad("#entityName#", {}, "#orderby#", arguments)');
		
		list.AddOperation('		<cfif arguments.offset eq 0>');
		list.AddOperation('			<cfset structDelete(arguments, "offset") />');		
		list.AddOperation('		</cfif>');
		list.AddOperation('		<cfif arguments.maxresults eq 0>');
		list.AddOperation('			<cfset structDelete(arguments, "maxresults") />');		
		list.AddOperation('		</cfif>');
		
		list.AddOperationScript('		if(arguments.offset eq 0){');
		list.AddOperationScript('			structDelete(arguments, "offset");');		
		list.AddOperationScript('		}');
		list.AddOperationScript('		if(arguments.maxresults eq 0){');
		list.AddOperationScript('			structDelete(arguments, "maxresults");');		
		list.AddOperationScript('		}');
		
		var offset = New apptacular.handlers.cfc.code.Argument();
		offset.setName('offset');
		offset.setRequired(false);
		offset.setType('numeric');
		offset.setDefaultValue(0);
		list.AddArgument(offset);
		
		var maxresults = New apptacular.handlers.cfc.code.Argument();
		maxresults.setName('maxresults');
		maxresults.setRequired(false);
		maxresults.setType('numeric');
		maxresults.setDefaultValue(0);
		list.AddArgument(maxresults);
		
		
		cfc.addFunction(list);
		
		//Create get method
		var arg = New apptacular.handlers.cfc.code.Argument();
		arg.setName('id');
		arg.setRequired(true);
		arg.setType('numeric');
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('get');
		func.setAccess(access);
		func.setReturnType('any');
		func.AddArgument(arg);
		
		func.setReturnResult('EntityLoad("#EntityName#", arguments.id, true)');
		cfc.addFunction(func);
		
		//Update Method
		var arg = New apptacular.handlers.cfc.code.Argument();
		arg.setName("#EntityName#");
		arg.setRequired(true);
		arg.setType("any");
		
		var func= New apptacular.handlers.cfc.code.function();
		func.setName("update");
		func.setAccess(access);
		func.setReturnType("void");
		func.AddArgument(arg);
		func.AddOperation('		<cfset arguments.#EntityName#.nullifyZeroID() />');
		func.AddOperation('		<cfset EntitySave(arguments.#EntityName#) />');
		func.AddOperationScript('		arguments.#EntityName#.nullifyZeroID();');
		func.AddOperationScript('		EntitySave(arguments.#EntityName#);');		
		cfc.addFunction(func);
		
		//Delete Method
		var func= New apptacular.handlers.cfc.code.function();
		func.setName("destroy");
		func.setAccess(access);
		func.setReturnType("void");
		func.AddArgument(arg);
		func.AddOperation('		<cfset EntityDelete(arguments.#EntityName#) />');
		func.AddOperationScript('		EntityDelete(arguments.#EntityName#);');		
		cfc.addFunction(func);
		
		//Search Method
		var search= New apptacular.handlers.cfc.code.function();
		search.setName("search");
		search.setAccess(access);
		search.setReturnType("#cfcPath#.#EntityName#[]");
		search.addLocalVariable("hqlString","string","FROM #EntityName# ");
		search.addLocalVariable("whereClause","string","");
		search.addLocalVariable("params","struct","Duplicate(arguments)", false);
		
		var q = New apptacular.handlers.cfc.code.Argument();
		q.setName("q");
		q.setType("string");
		q.setDefaultValue("");
		search.addArgument(q);
		
		var offset = New apptacular.handlers.cfc.code.Argument();
		offset.setName('offset');
		offset.setRequired(false);
		offset.setType('numeric');
		offset.setDefaultValue(0);
		search.AddArgument(offset);
		
		var maxresults = New apptacular.handlers.cfc.code.Argument();
		maxresults.setName('maxresults');
		maxresults.setRequired(false);
		maxresults.setType('numeric');
		maxresults.setDefaultValue(0);
		search.AddArgument(maxresults);
		
		search.AddOperation('');
		search.AddOperation('		<cfif params.offset eq 0>');
		search.AddOperation('			<cfset structDelete(params, "offset") />');		
		search.AddOperation('		</cfif>');
		search.AddOperation('		<cfif params.maxresults eq 0>');
		search.AddOperation('			<cfset structDelete(params, "maxresults") />');		
		search.AddOperation('		</cfif>');
		search.AddOperation('		<cfset structDelete(params, "q") />');
		search.AddOperation('');		
		
		search.AddOperationScript('');
		search.AddOperationScript('		if(params.offset eq 0){');
		search.AddOperationScript('			structDelete(params, "offset");');		
		search.AddOperationScript('		}');
		search.AddOperationScript('		if(params.maxresults eq 0){');
		search.AddOperationScript('			structDelete(params, "maxresults");');		
		search.AddOperationScript('		}');
		search.AddOperationScript('		structDelete(params, "q");');
		search.AddOperationScript('');	
		
		
		
		
		
		
		search.AddOperationScript('		if (len(arguments.q) gt 0){');		
		search.AddOperation('		<cfif len(arguments.q) gt 0>');
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i].getName();
			
			if (FindNoCase("char",columns[i].getDataType())){
				search.AddOperationScript('			whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|"); 	  ');		
				search.AddOperation('				<cfset whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|") />');		
			}
		}
		
		search.AddOperationScript('			whereClause = Replace(whereClause, "|", " OR ", "all");');	
		search.AddOperation('			<cfset whereClause = Replace(whereClause, "|", " OR ", "all") />');	
		
		search.AddOperationScript('		}');		
		search.AddOperation('		</cfif>');
		
		search.AddOperationScript('		if (len(whereClause) gt 0){');	
		search.AddOperationScript('			hqlString = hqlString & " WHERE " & whereClause;');	
		search.AddOperationScript('		}');
		
		search.AddOperationScript('		hqlString = hqlString & " ORDER BY #OrderBy#";');	
		
		search.AddOperation('		<cfif len(whereClause) gt 0>');
		search.AddOperation('			<cfset hqlString = hqlString & " WHERE " & whereClause />');
		search.AddOperation('		</cfif>');
		
		search.AddOperation('		<cfset hqlString = hqlString & " ORDER BY #OrderBy#" />');
		
		search.setReturnResult('ormExecuteQuery(hqlString, false, params)');
		cfc.addFunction(search);		
		
		return cfc;
	}    


}