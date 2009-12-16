component{

	public generator function init(required any datasource, required any config){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.datasource = arguments.datasource;
		variables.config = arguments.config;
		variables.files = ArrayNew(1);
				
		return This;
	}
	
	public void function generate(){
		var i =0;
		
		if (config.getCreateAppCFC()){
			var AppCFC = createAppCFC(datasource, config.getRootFilePath());
			AppCFC.setFormat(config.getCFCFormat());
			ArrayAppend(files, AppCFC);
			
			var EventHandler = createEventHandler(config.getEntityFilePath());
			EventHandler.setFormat(config.getCFCFormat());
			ArrayAppend(files, EventHandler);
			
			
		}
		
		if (config.getCreateViews()){
			copyCSS();
			copyForeignKeyCustomTag();
			copyManyToManyCustomTag();
			copyManyToManyReaderCustomTag();
			copyGradient();
			
			var index = createIndex(datasource, config.getRootFilePath());
			ArrayAppend(files, index);
			
			var pageWrapper = createPageWrapper(datasource, config.getCustomTagFilePath(), config.getCSSRelativePath());
			ArrayAppend(files, pageWrapper);
		}
		
		if (config.getCreateLogin()){
			
			var authCFC = createAuthenticationService(config.getServiceFilePath());
			ArrayAppend(files, authCFC);
			
			var login = createlogin(config.getRootFilePath());
			ArrayAppend(files, login);
			
			copyLoginCustomTag();
			
		}
		
		var tables = datasource.getTables();
		
		for (i=1; i <= ArrayLen(tables); i++){
			
			if (config.getCreateEntities() and tables[i].getCreateInterface()){
			
				var ORMCFC = createORMCFC(tables[i], config.getEntityFilePath());
				ORMCFC.setFormat(config.getCFCFormat());
				ArrayAppend(files, ORMCFC);
			
			}

			if (config.getCreateViews() and tables[i].getCreateInterface()){
				
				var ViewListCustomTag = createViewListCustomTag(tables[i], config.getCustomTagFilePath());
				ArrayAppend(files, ViewListCustomTag);
				
				var ViewReadCustomTag = createViewReadCustomTag(tables[i], config.getCustomTagFilePath());
				ArrayAppend(files, ViewReadCustomTag);
				
				var ViewEditCustomTag = createViewEditCustomTag(tables[i], config.getCustomTagFilePath(), config);
				ArrayAppend(files, ViewEditCustomTag);
				
				var View = createView(tables[i], config.getRootFilePath(), config.getEntityCFCPath());
				ArrayAppend(files, View);
				
			}
			if (config.getCreateServices() and tables[i].getCreateInterface()){
				
				var ORMServiceCFC = createORMServiceCFC(tables[i], config.getServiceFilePath(), config.getEntityCFCPath(), config.getServiceAccess());
				ORMServiceCFC.setFormat(config.getCFCFormat());
				ArrayAppend(files, ORMServiceCFC);
			
			}
		}
		
	
	}
	
	public array function getAllGeneratedFilePaths(){
		var i = 0;
		var result = ArrayNew(1);
		for (i=1; i <= ArrayLen(files); i++){
			ArrayAppend(result, files[i].getFileName());
		}
		
		ArrayAppend(result,config.getCSSFilePath() & variables.FS & "screen.css");
		ArrayAppend(result,config.getCSSFilePath() & variables.FS & "appgrad.jpg");
		ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "foreignKeySelector.cfm");
		ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "manyToManySelector.cfm");
		ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "manyToManyReader.cfm");
		ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "loginForm.cfm");
		
		
		return result;
	}
	
	public void function writeFiles(){
		var i = 0;
		for (i=1; i <= ArrayLen(files); i++){
			files[i].write();
		}
	}
	
	public numeric function fileCount(){
		return ArrayLen(files);
	}
	
	public any function createORMCFC(required any table, required string path){
		var i = 0;
		var j = 0;
		var k = 0;
	    var fileLocation = path;
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(table.getEntityName());
	    cfc.setFileLocation(fileLocation);
	   	cfc.setPersistent(true);
		
		// Create Init
		var init= New apptacular.handlers.cfc.code.function();
		init.setName('init');
		init.setAccess("public");
		init.setReturnType(table.getEntityName());
		init.setReturnResult('This');
		
		
		if (not table.isEntitySameAsTableName()){
		    cfc.setTable(table.getName());
		    cfc.setEntityname(table.getEntityName());
	   	}
	    
		var columns = table.getColumns();
		
		for (i=1; i <= ArrayLen(columns); i++){
	        column = columns[i];
			
	       	
	       	property = New apptacular.handlers.cfc.code.property();
	       	property.setName(column.getName());
			property.setType(column.getType());
			property.setORMType(column.getOrmType());
	       	
			if (not column.isColumnSameAsColumnName()){
				property.setColumn(column.getColumn());
	       	}
	       	
	       	if (column.getLength() gt 0){
	       		property.setLength(column.getLength());
	       	}
	       	
	       	if (column.getIsPrimaryKey()){
	       		property.setFieldtype('id');
	       		property.setGenerator('increment');
	       	}	
	       	else if (column.getisForeignKey()){
				var fTable = dataSource.getTable(column.getForeignKeyTable());
				property.setType("");
				property.setOrmType("");
	       		property.setName(fTable.getEntityName());
	       		property.setFieldtype('many-to-one');
	       		property.setFkcolumn(column.getForeignKey());
	       		property.setCFC(fTable.getEntityName());
	       		property.setInverse(true);
	       		property.SetmissingRowIgnored(true);
	       	}	
	        
	        cfc.AddProperty(property);
	    }
		   	
		var references = table.getReferences();
	   	
		if (not isNull(references)){
		
			for (j=1; j <= ArrayLen(references); j++){
				
				var ref = references[j];
				var foreignTable = datasource.getTable(ref.getForeignKeyTable());
				var joinTables = table.getJoinTables();
				
				if (ListFindNoCase(ArrayToList(joinTables),foreignTable.getName()) ){
					//Handle Many-to-manys
					otherJoinTable = datasource.getTable(foreignTable.getOtherJoinTable(table.getName()));		
					foreignColumns = foreignTable.getColumns();
					
					
					
					property = New apptacular.handlers.cfc.code.property();
					property.setName(otherJoinTable.getPlural());
			   		property.setFieldtype('many-to-many');
					property.setCFC(otherJoinTable.getEntityName());
					property.setLinkTable(foreignTable.getName());
					
					for (k=1; k <= ArrayLen(foreignColumns); k++){
						if (CompareNoCase(foreignColumns[k].getForeignKeyTable(),table.getName()) eq 0){
							property.setFKColumn(foreignColumns[k].getColumn());
						}
						else if (CompareNoCase(foreignColumns[k].getForeignKeyTable(),otherJoinTable.getName()) eq 0){
							property.setInverseJoinColumn(foreignColumns[k].getColumn());
						}
					}
					property.setOrderby(otherJoinTable.getOrderBy());
			   		property.setLazy(true);
					property.setSingularname(otherJoinTable.getEntityName());
			   		cfc.AddProperty(property);
					
					var countFunc= New apptacular.handlers.cfc.code.function();
					countFunc.setName("get#otherJoinTable.getEntityName()#Count");
					countFunc.setAccess("public");
					countFunc.setReturnType('numeric');
					countFunc.AddOperation('		<cfset var hql = "select #table.getEntityName()#.#otherJoinTable.getPlural()#.size as #otherJoinTable.getEntityName()#Count from #table.getEntityName()# #table.getEntityName()# where #table.getIdentity()# = ''##This.get#table.getIdentity()#()##''" />');
					countFunc.AddOperation('		<cfset var result = ormExecuteQuery(hql)[1] />');	
					countFunc.AddOperationScript('		var hql = "select #table.getEntityName()#.#otherJoinTable.getPlural()#.size as #otherJoinTable.getEntityName()#Count from #table.getEntityName()# #table.getEntityName()# where #table.getIdentity()# = ''##This.get#table.getIdentity()#()##''";');
					countFunc.AddOperationScript('		var result = ormExecuteQuery(hql)[1];');
					countFunc.setReturnResult('result');
					cfc.addFunction(countFunc);
					
				
				}
				else{
				
					//Handle Typical OneToManys
					property = New apptacular.handlers.cfc.code.property();
					property.setName(foreignTable.getPlural());
			   		property.setFieldtype('one-to-many');
			   		property.setFkcolumn(ref.getforeignKey());
			   		property.setCFC(foreignTable.getEntityName());
			   		property.setCascade("all-delete-orphan");
					property.setSingularname(foreignTable.getEntityName());
					property.setOrderby(foreignTable.getOrderBy());
			   		cfc.AddProperty(property);
					
					var countFunc= New apptacular.handlers.cfc.code.function();
					countFunc.setName("get#foreignTable.getEntityName()#Count");
					countFunc.setAccess("public");
					countFunc.setReturnType('numeric');
					countFunc.AddOperation('		<cfset var hql = "select #table.getEntityName()#.#foreignTable.getPlural()#.size as #foreignTable.getEntityName()#Count from #table.getEntityName()# #table.getEntityName()# where #table.getIdentity()# = ''##This.get#table.getIdentity()#()##''" />');
					countFunc.AddOperation('		<cfset var result = ormExecuteQuery(hql)[1] />');	
					countFunc.AddOperationScript('		var hql = "select #table.getEntityName()#.#foreignTable.getPlural()#.size as #foreignTable.getEntityName()#Count from #table.getEntityName()# #table.getEntityName()# where #table.getIdentity()# = ''##This.get#table.getIdentity()#()##''";');
					countFunc.AddOperationScript('		var result = ormExecuteQuery(hql)[1];');
					countFunc.setReturnResult('result');
					cfc.addFunction(countFunc);
					
				}
				
				
				
			}
	   	}
		
		//Handle virtual columns
		var virtualColumns = table.getVirtualColumns();
		
		for (i=1; i <= ArrayLen(virtualColumns); i++){
			vc = virtualColumns[i];
			
			vcGetter = New apptacular.handlers.cfc.code.function();
			vcGetter.setName("get" & vc.getName());
			vcGetter.setAccess("public");
			vcGetter.setReturnType(vc.getType());
			
			
			var code = vc.getGetterCode();
			for (j=1; j <= ListLen(code, linebreak); j++){
				var codeLine = ListGetAt(code, j, linebreak);
				vcGetter.AddOperation('		#codeLine#');
				vcGetter.AddOperationScript('		#codeLine#');
			}
			
			cfc.addFunction(vcGetter);
			
			//Add virtual column to properties list
			var property = New apptacular.handlers.cfc.code.property();
	       	property.setName(vc.getName());
			property.setType(vc.getType());
			property.setPersistent(false);
			property.setSetter(false);
			cfc.AddProperty(property);
			
			//Add initialization to start up for object.
			init.addOperation('		<cfset variables.#vc.getName()# = This.get#vc.getName()#() />');
			init.AddOperationScript('		variables.#vc.getName()# = This.get#vc.getName()#();');
			
		}
		
		//NullifyZeroID is for use with Remote services.
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('nullifyZeroID');
		func.setAccess("public");
		func.setReturnType('void');
		func.AddOperation('		<cfif getIDValue() eq 0>');
		func.AddOperation('			<cfset variables[getIDName()] = JavaCast("Null", "") />');	
		func.AddOperation('		</cfif>');
		func.AddOperationScript('		if (getIDValue() eq 0){');
		func.AddOperationScript('			variables[getIDName()] = JavaCast("Null", "");');
		func.AddOperationScript('		}');
		cfc.addFunction(func);
		
		
		//Add populate function
		var populate= New apptacular.handlers.cfc.code.function();
		populate.setName('populate');
		populate.setAccess("public");
		populate.setReturnType(table.getEntityName());
		populate.setReturnResult("This");
		
		var arg = New apptacular.handlers.cfc.code.Argument();
		arg.setName('formStruct');
		arg.setRequired(true);
		arg.setType('struct');
		populate.AddArgument(arg);
		
		for (i= 1; i <= ArrayLen(columns); i++){
			column = columns[i];
			
			if(column.getIsPrimaryKey()){
	    		populate.AddOperation('		<cfif StructKeyExists(arguments.formstruct, "#column.getName()#") AND arguments.formstruct.#column.getName()# gt 0>');
				populate.AddOperation('			<cfset This = EntityLoad("#table.getEntityName()#", arguments.formstruct.#column.getName()#, true) />');
				populate.AddOperation('		</cfif>');
				
				populate.AddOperationScript('		if (StructKeyExists(arguments.formstruct, "#column.getName()#") AND arguments.formstruct.#column.getName()# > 0){');
	    		populate.AddOperationScript('			This = EntityLoad("#table.getEntityName()#", arguments.formstruct.#column.getName()#, true);');
				populate.AddOperationScript('		}');
	    	}
			else if (column.getisForeignKey()){
				var fkTable = datasource.getTable(column.getForeignKeyTable());
				fkEName = fkTable.getentityName();
				populate.AddOperation('		<cfset #fkEName# = entityLoad("' & fkEName  & '", form.#fkEName#, true) />');
				populate.AddOperation('		<cfset This.set#fkEName#(#fkEName#) />');
				
				populate.AddOperationScript('		#fkEName# = entityLoad("' & fkEName  & '", form.#fkEName#, true);');
				populate.AddOperationScript('		This.set#fkEName#(#fkEName#);');
			}
	    	else if (not config.isMagicField(column.getName())){ 
				populate.AddOperation('		<cfif StructKeyExists(arguments.formstruct, "#column.getName()#")>');
	    		populate.AddOperation('			<cfset This.set#column.getName()#(arguments.formstruct.#column.getName()#)  />');
				populate.AddOperation('		</cfif>');
				
				populate.AddOperationScript('		if (StructKeyExists(arguments.formstruct, "#column.getName()#")){');
	    		populate.AddOperationScript('			this.set#column.getName()#(arguments.formstruct.#column.getName()#);');
				populate.AddOperationScript('		}');
	    	}
	    }
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
				populate.AddOperation('');
				populate.AddOperation('		<!--- Handle many-to-many relationships for table #otherJoinTable.getEntityName()# --->');
				populate.AddOperation('		<cfif structKeyExists(formstruct, "#otherJoinTable.getPlural()#")>');
				populate.AddOperation('			<cfset This.set#otherJoinTable.getPlural()#([]) />');
				populate.AddOperation('			<cfloop list="##formstruct.#otherJoinTable.getPlural()###" index="id">');
				populate.AddOperation('				<cfset #otherJoinTable.getEntityName()# = entityLoad("#otherJoinTable.getEntityName()#", id, true) />');
				populate.AddOperation('				<cfset This.add#otherJoinTable.getEntityName()#(#otherJoinTable.getEntityName()#) />');
				populate.AddOperation('			</cfloop>');
				populate.AddOperation('		</cfif>');
				
				populate.AddOperationScript('');
				populate.AddOperationScript('		//Handle many-to-many relationships for table #otherJoinTable.getEntityName()#');
				populate.AddOperationScript('		if (structKeyExists(arguments.formstruct, "#otherJoinTable.getPlural()#")){');
				populate.AddOperationScript('			This.set#otherJoinTable.getPlural()#([]);');
				populate.AddOperationScript('			if (ListLen(arguments.formstruct.#otherJoinTable.getPlural()#) gt 0){');
				populate.AddOperationScript('				for (i = 1; i <= ListLen(arguments.formstruct.#otherJoinTable.getPlural()#); i++ ){');
				populate.AddOperationScript('					var id = ListGetAt(arguments.formstruct.#otherJoinTable.getPlural()#, i);');			
				populate.AddOperationScript('					var #otherJoinTable.getEntityName()# = entityLoad("#otherJoinTable.getEntityName()#", id, true);');
				populate.AddOperationScript('					This.add#otherJoinTable.getEntityName()#(#otherJoinTable.getEntityName()#);');
				populate.AddOperationScript('				}');
				populate.AddOperationScript('			}');
				populate.AddOperationScript('		}');
			}
		
		}
		
		cfc.addFunction(populate);
		
		//Add init at the end, so any changes can be made through out this code.
		cfc.addFunction(init);
		
		return cfc;
	}
	
	public any function createEventHandler(required string path){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName("eventHandler");
	    cfc.setFileLocation(path);
		cfc.setImplements("CFIDE.ORM.IEventHandler");
		
		
		var EntityArg = New apptacular.handlers.cfc.code.Argument();
		EntityArg.setName('entity');
		EntityArg.setRequired(false);
		EntityArg.setType('any');
		
		var oldDataArg = New apptacular.handlers.cfc.code.Argument();
		oldDataArg.setName('oldData');
		oldDataArg.setRequired(false);
		oldDataArg.setType('struct');
		
		
		
		var postD= New apptacular.handlers.cfc.code.function();
		postD.setAccess("public");
		postD.setReturnType("void");
		postD.AddArgument(EntityArg);
		postD.setName('postDelete');
		cfc.addFunction(postD);
		
		var postI= New apptacular.handlers.cfc.code.function();
		postI.setAccess("public");
		postI.setReturnType("void");
		postI.AddArgument(EntityArg);
		postI.setName('postInsert');
		cfc.addFunction(postI);
		
		var postL= New apptacular.handlers.cfc.code.function();
		postL.setAccess("public");
		postL.setReturnType("void");
		postL.AddArgument(EntityArg);
		postL.setName('postLoad');
		cfc.addFunction(postL);
		
		var postU= New apptacular.handlers.cfc.code.function();
		postU.setAccess("public");
		postU.setReturnType("void");
		postU.AddArgument(EntityArg);
		postU.setName('postUpdate');
		cfc.addFunction(postU);
		
		var preD= New apptacular.handlers.cfc.code.function();
		preD.setAccess("public");
		preD.setReturnType("void");
		preD.AddArgument(EntityArg);
		preD.setName('preDelete');
		cfc.addFunction(preD);
		
		var preI= New apptacular.handlers.cfc.code.function();
		preI.setAccess("public");
		preI.setReturnType("void");
		preI.AddArgument(EntityArg);
		preI.setName('preInsert');
		preI.AddOperationScript('		if (structKeyExists(entity, "set#config.getCreatedOnString()#")){');
		preI.AddOperationScript('			entity.set#config.getCreatedOnString()#(now());');
		preI.AddOperationScript('		}');
		preI.AddOperationScript('');
		preI.AddOperationScript('		if (structKeyExists(entity, "set#config.getupdatedOnString()#")){');
		preI.AddOperationScript('			entity.set#config.getupdatedOnString()#(now());');
		preI.AddOperationScript('		}');
		
		preI.AddOperation('		<cfif structKeyExists(entity, "set#config.getCreatedOnString()#")>');
		preI.AddOperation('			<cfset entity.set#config.getCreatedOnString()#(now()) />');
		preI.AddOperation('		</cfif>');
		preI.AddOperation('');
		preI.AddOperation('		<cfif structKeyExists(entity, "set#config.getupdatedOnString()#")>');
		preI.AddOperation('			<cfset entity.set#config.getupdatedOnString()#(now()) />');
		preI.AddOperation('		</cfif>');
		cfc.addFunction(preI);
		
		
		
		var preL= New apptacular.handlers.cfc.code.function();
		preL.setAccess("public");
		preL.setReturnType("void");
		preL.AddArgument(EntityArg);
		preL.setName('preLoad');
		cfc.addFunction(preL);
		
		var preU= New apptacular.handlers.cfc.code.function();
		preU.setAccess("public");
		preU.setReturnType("void");
		preU.AddArgument(EntityArg);
		preU.setName('preUpdate');
		preU.AddArgument(OldDataArg);
		
		
		preU.AddOperationScript('		if (structKeyExists(entity, "set#config.getupdatedOnString()#")){');
		preU.AddOperationScript('			entity.set#config.getupdatedOnString()#(now());');
		preU.AddOperationScript('		}');
		
		preU.AddOperation('		<cfif structKeyExists(entity, "set#config.getupdatedOnString()#")>');
		preU.AddOperation('			<cfset entity.set#config.getupdatedOnString()#(now()) />');
		preU.AddOperation('		</cfif>');
		
		cfc.addFunction(preU);
	
	
		return cfc;
	}
	
	public any function createAuthenticationService(required string path){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName("authenticationService");
	    cfc.setFileLocation(path);
		
		
		
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
	
	public any function createLogin(required string path){
		var i=0;
	    
	    var login  =  New apptacular.handlers.cfc.code.CFPage("login", path);  
	    
		login.AppendBody('<cfsetting showdebugoutput="false" />');
		login.AppendBody('<cfparam name="form.username" default="" type="string" /> ');

		login.AppendBody('<cfset message = "" />');
		login.AppendBody('<cfif structKeyExists(form, "login")>');
		login.AppendBody('	<cfset authService = New #config.getServiceCFCPath()#.AuthenticationService() />');
		login.AppendBody('	<cfset isAuthed = authService.authenticate(form.username, form.password) />');
		login.AppendBody('');	
		login.AppendBody('	<cfif isAuthed>');
		login.AppendBody('		<cfset Session.loggedOn = true />');
		login.AppendBody('		<cfset session.username = form.username />');
		login.AppendBody('		');
		login.AppendBody('		<cflocation url="##cgi.script_name##" addtoken="false"  />');
		login.AppendBody('	<cfelse>');
		login.AppendBody('		<cfset message = "Not Authenticated" />');
		login.AppendBody('	</cfif>');
		login.AppendBody('');	
		login.AppendBody('</cfif>');
		login.AppendBody('');	
		login.AppendBody('<cf_pageWrapper>');
		login.AppendBody('<h2>Login</h2>');
		login.AppendBody('<cf_loginForm username="##form.username##" message="##message##" />');
		login.AppendBody('</cf_pageWrapper>');
		
		return login ;
	
	
	}
	
	public any function createAppCFC(required any datasource, required string path){
		
	    var dbname = arguments.datasource.getName();
	    var fileLocation = arguments.path;
	    
	    var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty("customTagPaths", "ExpandPath('#config.getCustomTagFolder()#/')", false) ;
		appCFC.addApplicationProperty('ormsettings.eventHandler', "#config.getEntityCFCPath()#.eventHandler") ;
		
		
		var onRequestStart= New apptacular.handlers.cfc.code.function();
		onRequestStart.setName('onRequestStart');
		onRequestStart.setAccess("public");
		onRequestStart.setReturnType("boolean");
		onRequestStart.setReturnResult('true');

		onRequestStart.AddOperation('		<cfif structKeyExists(url, "reset_app")>');
		onRequestStart.AddOperation('			<cfset ApplicationStop() />');
		onRequestStart.AddOperation('			<cfset location(cgi.script_name, false) />');
		onRequestStart.AddOperation('		</cfif>');
		onRequestStart.AddOperationScript('		if (structKeyExists(url, "reset_app")){');
		onRequestStart.AddOperationScript('			ApplicationStop();');
		onRequestStart.AddOperationScript('			location(cgi.script_name, false);');
		onRequestStart.AddOperationScript('		}');


		
		
		
		
		
		if (config.getCreateLogin()){
			appCFC.addApplicationProperty('sessionManagement', true) ;
		
			var onSessionStart= New apptacular.handlers.cfc.code.function();
			onSessionStart.setName('onSessionStart');
			onSessionStart.setAccess("public");
			onSessionStart.setReturnType("boolean");
			onSessionStart.setReturnResult('true');

			onSessionStart.AddOperation('		<cfset session.loggedOn = false />');
			onSessionStart.AddOperation('		<cfset session.username = "" />');
		
			onSessionStart.AddOperationScript('		session.loggedOn = false;');
			onSessionStart.AddOperationScript('		session.username = "";');
			
			appCFC.addFunction(onSessionStart);
			
			onRequestStart.AddOperation('		<cfif not session.loggedOn>');
			onRequestStart.AddOperation('			<cfinclude template="login.cfm">');
			onRequestStart.AddOperation('			<cfabort />');
			onRequestStart.AddOperation('		</cfif>');
			onRequestStart.AddOperationScript('		if (not session.loggedOn){');
			onRequestStart.AddOperationScript('			include "login.cfm";');
			onRequestStart.AddOperationScript('			abort;');
			onRequestStart.AddOperationScript('		}');
			
			
	    }
		
		
		appCFC.addFunction(onRequestStart);
		
		return appCFC ;
	}
	
	public any function createViewListCustomTag(required any table, required string path){
	    var i = 0;
		var columnCount = 3;
		var fileLocation = path;
		var fileName = table.getEntityName() & "List";
		var identity = table.getIdentity();
		var entityName =  table.getEntityName();
		
	    var ct  = New apptacular.handlers.cfc.code.customTag(fileName, fileLocation);
		ct.addAttribute(table.getEntityName() & "Array", "array", true);
		ct.addAttribute("maxresults", "numeric", false, -1);
		ct.addAttribute("offset", "numeric", false, -1);
		
		ct.AppendBody('<cfset #entityName#Count = ormExecuteQuery("select Count(*) from #entityName#")[1]  />');
		ct.AppendBody('<cfset prevOffset = attributes.offset - attributes.maxresults />');
		ct.AppendBody('<cfset nextOffset = attributes.offset + attributes.maxresults />');
		ct.AppendBody('<cfset pages = Ceiling(#entityName#Count / attributes.maxresults) />');
		ct.AppendBody('');
		ct.AppendBody('');
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "deleted") eq 0>');
		ct.AppendBody('	<p class="alert">Record deleted</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		
		ct.AppendBody('<cfoutput>');
		ct.AppendBody('<table>');
		ct.AppendBody('	<thead>');
		
		
		ct.AppendBody('		<tr>');
		
		var columns = table.getColumns();
		
		for (i = 1; i <= ArrayLen(columns); i++){
			
			if (columns[i].getIsForeignKey()){
				var fkTable = datasource.getTable(columns[i].getForeignKeyTable());
				ct.AppendBody('			<th>#fkTable.getDisplayName()#</th>');
			}
			
			
			else{
				ct.AppendBody('			<th>#columns[i].getDisplayName()#</th>');
			}
			columnCount++;
			
		}
		
		var references = table.getReferences();
	   	
		if (not isNull(references)){
		
			for (j=1; j <= ArrayLen(references); j++){
				var ref = references[j];
				var foreignTable = datasource.getTable(ref.getForeignKeyTable());
				
				if (not foreignTable.getIsJoinTable()){
					ct.AppendBody('			<th>#foreignTable.getEntityName()#Count</th>');
					columnCount++;
				}
			}
	   	}
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('			<th>#otherJoinTable.getEntityName()#Count</th>');
				columnCount++;
			
			}
		
		}		
		
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</thead>');
		
		ct.AppendBody('	<tbody>');
		
		ct.AppendBody('	<cfloop array="##attributes.#entityName#Array##" index="#entityName#">');
		
		ct.AppendBody('		<tr>');
		
		for (i = 1; i <= ArrayLen(columns); i++){
		 	if (columns[i].getIsForeignKey()){
				var fkTable = datasource.getTable(columns[i].getForeignKeyTable());
				ct.AppendBody('			<td><a href="#fkTable.getEntityName()#.cfm?method=read&amp;#fkTable.getIdentity()#=###EntityName#.get#fkTable.getEntityName()#().get#fkTable.getIdentity()#()##">###EntityName#.get#fkTable.getEntityName()#().get#fkTable.getForeignKeyLabel()#()##</a></td>');
			}
			else if (compareNoCase(columns[i].getuitype(), "boolean") eq 0){
					
				ct.AppendBody('			<td>##YesNoFormat(#entityName#.get#columns[i].getName()#())##</td>');

				
			}
			else if (compareNoCase(columns[i].getuitype(), "date") eq 0){
					
		 			ct.AppendBody('			<td>##dateFormat(#EntityName#.get#columns[i].getName()#(),"#config.getDateFormat()#" )##</td>');

				
			}
			else if (compareNoCase(columns[i].getuitype(), "datetime") eq 0){
					
		 			ct.AppendBody('			<td>##dateFormat(#EntityName#.get#columns[i].getName()#(),"#config.getDateFormat()#" )## ##timeFormat(#EntityName#.get#columns[i].getName()#(),"#config.getTimeFormat()#" )##</td>');

				
			}		
			
				
			else{
				ct.AppendBody('			<td>###entityName#.get#columns[i].getName()#()##</td>');
			}
		}
		
	   	
		if (not isNull(references)){
		
			for (j=1; j <= ArrayLen(references); j++){
				var ref = references[j];
				var foreignTable = datasource.getTable(ref.getForeignKeyTable());
				
				if (not foreignTable.getIsJoinTable()){
					ct.AppendBody('			<td>###entityName#.get#foreignTable.getEntityName()#Count()##</td>');
				}
			}
	   	}
		
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('			<td>###entityName#.get#otherJoinTable.getEntityName()#Count()##</td>');
			
			}
		
		}
		
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=read&#identity#=###entityName#.get#identity#()##">Read</a></td>');
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=edit&#identity#=###entityName#.get#identity#()##">Edit</a></td>');
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=delete_process&#identity#=###entityName#.get#identity#()##" onclick="if (confirm(''Are you sure?'')) { return true}; return false"">Delete</a></td>');
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</cfloop>');
		
		ct.AppendBody('<cfif attributes.offset gte 0>');
		ct.AppendBody('	<tr>');
		ct.AppendBody('	<td colspan="#columnCount#">');
		ct.AppendBody('		<table class="listnav">');
		ct.AppendBody('			<tr>');
		ct.AppendBody('				<td class="prev">');
		ct.AppendBody('					<cfif prevOffset gte 0>');
		ct.AppendBody('						<a href="?offset=##prevOffset##&amp;maxresults=##attributes.maxresults##">&larr; Prev</a>');
		ct.AppendBody('					</cfif>');
		ct.AppendBody('				</td>');
		ct.AppendBody('				<td class="pages">');
		ct.AppendBody('					<cfloop index="i" from="1" to="##pages##">');
		ct.AppendBody('						<cfset offset = 0 + ((i -1) * attributes.maxresults) />');
		ct.AppendBody('						<cfif offset eq attributes.offset>');
		ct.AppendBody('							##i##');
		ct.AppendBody('						<cfelse>');
		ct.AppendBody('							<a href="?offset=##offset##&amp;maxresults=##attributes.maxresults##">##i##</a>');
		ct.AppendBody('						</cfif>');
		ct.AppendBody('					</cfloop>');
		ct.AppendBody('				</td>');
		ct.AppendBody('				<td class="next">');
		ct.AppendBody('					<cfif nextOffset lt #entityname#Count>');
		ct.AppendBody('					<a href="?offset=##nextOffset##&amp;maxresults=##attributes.maxresults##">Next &rarr;<a/>');
		ct.AppendBody('					</cfif>');
		ct.AppendBody('				</td>');
		ct.AppendBody('			</tr>');
		ct.AppendBody('		</table>');
		ct.AppendBody('	</td>');
		ct.AppendBody('	</tr>');
		ct.AppendBody('</cfif>');
		ct.AppendBody('	</tbody>');
		
		ct.AppendBody('	</cfoutput>');
		ct.AppendBody('</table>');
	    
	    return ct;
	}
	
	public any function createViewReadCustomTag(required any table, required string path){
	    var i = 0;
		var fileLocation = path;
		var fileName = table.getEntityName() & "Read";
		var identity = table.getIdentity(); 
		
	    var ct  = New apptacular.handlers.cfc.code.customTag(fileName, fileLocation);
		var EntityName = table.getEntityName();
		var columns = table.getColumns();

		ct.addAttribute(EntityName, 'any', true);
		ct.addAttribute("class", 'string', false, "readpage");
		ct.AppendBody('<cfset #EntityName# = attributes.#EntityName# /> ');
		ct.AppendBody('<cfoutput>');
		ct.AppendBody('<table>');
		ct.AppendBody('	<tbody>');
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			column = columns[i];
		 	
			if (column.getisForeignKey()){
				var fkTable = datasource.getTable(column.getForeignKeyTable());
			
				ct.AppendBody('		<tr>');
		 		ct.AppendBody('			<th>#fkTable.getEntityName()#</th>');
				ct.AppendBody('			<td><a href="#fkTable.getEntityName()#.cfm?method=read&amp;#fkTable.getIdentity()#=###EntityName#.get#fkTable.getEntityName()#().get#fkTable.getIdentity()#()##">###EntityName#.get#fkTable.getEntityName()#().get#fkTable.getForeignKeyLabel()#()##</a></td>');
				ct.AppendBody('		</tr>');
			
				}
			else if (compareNoCase(column.getuitype(), "boolean") eq 0){
					
					ct.AppendBody('		<tr>');
		 			ct.AppendBody('			<th>#column.getDisplayName()#</th>');
		 			ct.AppendBody('			<td>##YesNoFormat(#EntityName#.get#column.getName()#())##</td>');
					ct.AppendBody('		</tr>');

				
			}
			else if (compareNoCase(column.getuitype(), "date") eq 0){
					
					ct.AppendBody('		<tr>');
		 			ct.AppendBody('			<th>#column.getDisplayName()#</th>');
		 			ct.AppendBody('			<td>##dateFormat(#EntityName#.get#column.getName()#(),"#config.getDateFormat()#" )##</td>');
					ct.AppendBody('		</tr>');

				
			}
			else if (compareNoCase(column.getuitype(), "datetime") eq 0){
					
					ct.AppendBody('		<tr>');
		 			ct.AppendBody('			<th>#column.getDisplayName()#</th>');
		 			ct.AppendBody('			<td>##dateFormat(#EntityName#.get#column.getName()#(),"#config.getDateFormat()#" )## ##timeFormat(#EntityName#.get#column.getName()#(),"#config.getTimeFormat()#" )##</td>');
					ct.AppendBody('		</tr>');

				
			}		
				
			else{
		 		ct.AppendBody('		<tr>');
		 		ct.AppendBody('			<th>#column.getDisplayName()#</th>');
		 		ct.AppendBody('			<td>###EntityName#.get#column.getName()#()##</td>');
				ct.AppendBody('		</tr>');
			}
		}
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('		<tr>');
				ct.AppendBody('			<th>#otherJoinTable.getDisplayPlural()#</th>');
				ct.AppendBody('			<td><cf_manyToManyReader  entityname="#otherJoinTable.getEntityName()#" identity="#otherJoinTable.getIdentity()#" foreignKeylabel="#otherJoinTable.getForeignKeyLabel()#" selected="###EntityName#.get#otherJoinTable.getPlural()#()##"  /></td>');
				ct.AppendBody('		</tr>');
			
			}
		
		}
		
		
		ct.AppendBody('	</tbody>');
		ct.AppendBody('</table>');
		
		
		
		
		
		
		ct.AppendBody('</cfoutput>');
	    
	    return ct;
	}
	
	public any function createViewEditCustomTag(required any table, required string path, required any config){
		var i = 0;
		var fileLocation = path;
		var fileName = table.getEntityName() & "Edit"; 
		
	    var ct  = New apptacular.handlers.cfc.code.customTag(fileName, fileLocation);
		var EntityName = table.getEntityName();
		var columns = table.getColumns();
		var identity = table.getIdentity(); 
		
		
		ct.addAttribute(EntityName, 'any', true);
		ct.addAttribute('message', 'string', false, "");
		ct.AppendBody('<cfset #EntityName# = attributes.#EntityName# /> ');
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "updated") eq 0>');
		ct.AppendBody('	<p class="alert">Records updated</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		ct.AppendBody('<cfoutput>');
		
		ct.AppendBody('<cfform action="?method=edit_process" method="post" format="html">');
		
		ct.AppendBody('	<table>');
		ct.AppendBody('	<tbody>');
		
		
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			column = columns[i];
		 	
			columnName = column.getName();
				
	 		if (column.getIsPrimaryKey()){
	 			ct.AppendBody('			<input name="#columnName#" type="hidden" value="###EntityName#.get#columnName#()##" />');
	 		}
			else{
	 			uitype = column.getUIType();
				
				ct.AppendBody('		<tr>');
				
				//Create different UI's depending on data type.
				if (compareNoCase(uitype, "date") eq 0){
					ct.AppendBody('			<th><label for="#columnName#">#column.getDisplayName()#:</label></th>');
	 				ct.AppendBody('			<td><cfinput name="#columnName#" type="datefield" id="#columnName#" value="##DateFormat(#EntityName#.get#columnName#(),''mm/dd/yyyy'')##" /></td>');
				}
				else if (compareNoCase(uitype, "text") eq 0){
					ct.AppendBody('			<th><label for="#columnName#">#column.getDisplayName()#:</label></th>');
	 				ct.AppendBody('			<td><cftextarea name="#columnName#"  id="#columnName#" value="###EntityName#.get#columnName#()##" richtext="true" toolbar="Basic" skin="Silver" /></td>');
				}
				
				else if (compareNoCase(uitype, "boolean") eq 0){
					ct.AppendBody('			<th><label for="#columnName#">#column.getDisplayName()#:</label></th>');
	 				ct.AppendBody('			<td>');
					ct.AppendBody('				<label for="#columnName#true"><input type="radio" name="#columnName#" <cfif isBoolean(#EntityName#.get#columnName#()) AND #EntityName#.get#columnName#()>checked="checked"</cfif> id="#columnName#true" value="1">Yes</label>');
					ct.AppendBody('				<label for="#columnName#false"><input type="radio" name="#columnName#" <cfif isBoolean(#EntityName#.get#columnName#()) AND NOT #EntityName#.get#columnName#()>checked="checked"</cfif> id="#columnName#false" value="0">No</label>');
					ct.AppendBody('			</td>');

				
				}
				
				else if (config.isMagicField(columnName)){
					ct.AppendBody('			<th><label for="#columnName#">#column.getDisplayName()#:</label></th>');
	 				
				
					if (compareNoCase(column.getuitype(), "date") eq 0){
				 		ct.AppendBody('			<td>##dateFormat(#EntityName#.get#column.getName()#(),"#config.getDateFormat()#" )##</td>');
					}
					else if (compareNoCase(column.getuitype(), "datetime") eq 0){
				 		ct.AppendBody('			<td>##dateFormat(#EntityName#.get#column.getName()#(),"#config.getDateFormat()#" )## ##timeFormat(#EntityName#.get#column.getName()#(),"#config.getTimeFormat()#" )##</td>');
					}
					else{
						ct.AppendBody('			<td>###EntityName#.get#columnName#()##</td>');
					}		
				
				
				}
				else if (column.getisForeignKey()){
					var fkTable = datasource.getTable(column.getForeignKeyTable());
					ct.AppendBody('			<cfif url.#table.getIdentity()# eq 0>');
					ct.AppendBody('				<cfset #fkTable.getEntityName()#Value = 0 /> ');
					ct.AppendBody('			<cfelse>');
					ct.AppendBody('				<cfset #fkTable.getEntityName()#Value = #EntityName#.get#fkTable.getEntityName()#().get#columnName#() />');
					ct.AppendBody('			</cfif>');
					
					
					ct.AppendBody('			<th><label for="#fkTable.getEntityName()#">#fkTable.getDisplayName()#:</label></th>');
	 				ct.AppendBody('			<td><cf_foreignkeySelector name="#fkTable.getEntityName()#" entityname="#fkTable.getEntityName()#" identity="#fkTable.getIdentity()#" foreignKeylabel="#fkTable.getforeignKeylabel()#" fieldValue="###fkTable.getEntityName()#Value##" orderby="#fkTable.getOrderby()#" /></td>');	
				}
				else{
					ct.AppendBody('			<th><label for="#columnName#">#column.getDisplayName()#:</label></th>');
	 				ct.AppendBody('			<td><input name="#columnName#" type="text" id="#columnName#" value="###EntityName#.get#columnName#()##" /></td>');
				}
				
				ct.AppendBody('		</tr>');
			}
			
		}
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('		<tr>');
				ct.AppendBody('			<th>#otherJoinTable.getDisplayPlural()#</th>');
				ct.AppendBody('			<td><cf_manyToManySelector name="#otherJoinTable.getPlural()#" entityname="#otherJoinTable.getEntityName()#" identity="#otherJoinTable.getIdentity()#" foreignKeylabel="#otherJoinTable.getForeignKeyLabel()#" selected="###EntityName#.get#otherJoinTable.getPlural()#()##"  orderby="#otherJoinTable.getOrderby()#"  /></td>');
				ct.AppendBody('		</tr>');
			
			}
		
		}
		
		
		ct.AppendBody('		<tr>');
		ct.AppendBody('			<th />');
		ct.AppendBody('			<td><input name="save" type="submit" value="Save" /></td>');
		ct.AppendBody('		</tr>');
		
		
		ct.AppendBody('	</tbody>');
		ct.AppendBody('	</table>');
		ct.AppendBody('</cfform>');
		ct.AppendBody('</cfoutput>');
	    
	    return ct;
	}
	
	public any function createView(required any table, required string path, required string entityCFCPath){
	    
	    var i=0;
	    var view  = New apptacular.handlers.cfc.code.CFPage(table.getEntityName(), arguments.path);
		
		var entityName = table.getEntityName();
		var displayName = table.getDisplayName();
		var identity = table.getIdentity();
		var columns = table.getColumns();
		var orderby = table.getorderby();
		
	    view.AppendBody('<cfsetting showdebugoutput="false" />');
	    view.AppendBody('<cfparam name="url.method" type="string" default="list" />');
	    view.AppendBody('<cfparam name="url.#identity#" type="numeric" default="0" />');
	    view.AppendBody('<cfparam name="url.message" type="string" default="" />');
		view.AppendBody('<cfparam name="url.offset" type="numeric" default="0" />');
		view.AppendBody('<cfparam name="url.maxresults" type="numeric" default="10" />');
	    view.AppendBody('<cfimport path="#arguments.entityCFCPath#.*" />');
		view.AppendBody('<cf_pageWrapper>');
		view.AppendBody();
	   	view.AppendBody('<h2>#displayName#</h2>');
		view.AppendBody();
	    view.AppendBody('<cfswitch expression="##url.method##" >');
		view.AppendBody();
	   	view.AppendBody('	<cfcase value="list">');
	    view.AppendBody('		<cfset #entityName#Array = entityLoad("#entityName#", {}, "#orderby#", {offset=url.offset, maxresults=url.maxresults} ) />');
		
		view.AppendBody('		<cfoutput><p class="breadcrumb">');	
		view.AppendBody('			<a href="index.cfm">Main</a> / <a href="##cgi.script_name##">List</a> /');
		view.AppendBody('			<a href="#EntityName#.cfm?method=edit">New</a>');		
		view.AppendBody('		</p></cfoutput>');	
		
		view.AppendBody('		<cf_#entityName#List #entityName#Array = "###entityName#Array##" message="##url.message##" offset="##url.offset##" maxresults="##url.maxresults##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    
		view.AppendBody('	<cfcase value="read">');
	    view.AppendBody('		<cfset #entityName# = entityLoad("' & entityName  & '", url.#identity#, true) />');
	    
		view.AppendBody('		<cfoutput><p class="breadcrumb">');	
		view.AppendBody('			<a href="index.cfm">Main</a> / <a href="##cgi.script_name##">List</a> /');
		view.AppendBody('			<a href="#EntityName#.cfm?method=edit&amp;#identity#=###EntityName#.get#identity#()##">Edit</a> /');
		view.AppendBody('			<a href="#EntityName#.cfm?method=edit">New</a>');		
		view.AppendBody('		</p></cfoutput>');	
		
		view.AppendBody('		<cf_#entityName#Read #entityName# = "###entityName###" /> ');
		
		var references = table.getReferences();
	   	
		if (not isNull(references)){
		
			for (j=1; j <= ArrayLen(references); j++){
				var ref = references[j];
				var foreignTable = datasource.getTable(ref.getForeignKeyTable());
				
				if (not foreignTable.getIsJoinTable()){
					view.AppendBody('');
					view.AppendBody('		<h3>#foreignTable.getDisplayPlural()#</h3> ');
					view.AppendBody('		<cf_#foreignTable.getEntityName()#List message="" #foreignTable.getEntityName()#Array="###EntityName#.get#foreignTable.getPlural()#()##" /> ');
				}
			}
	   	}
		
		
		view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit">');
	    view.AppendBody('		<cfif url.#identity# eq 0>');
	    view.AppendBody('			<cfset #entityName# = New ' & entityName  & '() />');
	    view.AppendBody('		<cfelse>');
	    view.AppendBody('			<cfset #entityName# = entityLoad("' & entityName  & '", url.#identity#, true) />');
	    view.AppendBody('		</cfif>');
		view.AppendBody('		<cfoutput><p class="breadcrumb">');	
		view.AppendBody('			<a href="index.cfm">Main</a> / <a href="##cgi.script_name##">List</a> /');
		view.AppendBody('		<cfif url.#identity# neq 0>');
	    view.AppendBody('			<a href="#EntityName#.cfm?method=read&amp;#identity#=###EntityName#.get#identity#()##">Read</a> /');
	    view.AppendBody('			<a href="#EntityName#.cfm?method=edit">New</a>');		
		view.AppendBody('		</cfif>');
		view.AppendBody('		</p></cfoutput>');	
		view.AppendBody();
	    view.AppendBody('		<cf_#entityName#Edit #entityName# = "###entityName###" message="##url.message##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit_process">');
	    
		view.AppendBody('		<cfset #entityName# = EntityNew("#entityName#") />');
		view.AppendBody('		<cfset #entityName# = #entityName#.populate(form) />');
	    view.AppendBody('		<cfset EntitySave(#entityName#) />');
	    view.AppendBody('		<cfset ORMFlush() />');
	    view.AppendBody('		<cflocation url ="##cgi.script_name##?method=edit&#identity#=###entityName#.get#identity#()##&message=updated" />');
	    
	    view.AppendBody('	</cfcase>');
	    view.AppendBody();
	    view.AppendBody('	<cfcase value="delete_process">');
	    view.AppendBody('		<cfset #entityName# = entityLoad("' & entityName  & '", url.#identity#, true) />');
	    view.AppendBody('		<cfset EntityDelete(#entityName#) />');
 	    view.AppendBody('		<cfset ORMFlush() />');
		view.AppendBody('		<cflocation url ="##cgi.script_name##?method=list&message=deleted" />');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();   
	    view.AppendBody('</cfswitch>');
		view.AppendBody('</cf_pageWrapper>');
		view.AppendBody();
	    return view;
	}
	
	public any function createIndex(required any datasource, required string path){
		var i=0;
		var tables = datasource.getTables();
	    
	    var index  =  New apptacular.handlers.cfc.code.CFPage("index", path);  
	    index.AppendBody('<cfsetting showdebugoutput="false" />');
		index.AppendBody('<cf_pageWrapper>');
	    index.AppendBody('<ul>');
	    
	   	for (i= 1; i <= ArrayLen(tables); i++){
			table = tables[i];
	    	if (table.getCreateInterface()){
				index.AppendBody('	<li><a href="#table.getEntityName()#.cfm">#table.getDisplayName()#</a></li>');
	    	}
		}
	    
	    
	    index.AppendBody('</ul>');
		index.AppendBody('</cf_pageWrapper>');
		return index ;
	
	
	}
	
	public any function createPageWrapper(required any datasource, required string path, required string csspath){
	    
	    var wrapper  =  New apptacular.handlers.cfc.code.CFPage("pageWrapper", path);  
	    
	    wrapper.AppendBody('<cfprocessingdirective suppresswhitespace="yes">');
		wrapper.AppendBody('<cfif thisTag.executionMode is "start">');
		wrapper.AppendBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
		wrapper.AppendBody('<html xmlns="http://www.w3.org/1999/xhtml">');
		wrapper.AppendBody('<head>');
		wrapper.AppendBody('<cfoutput><title>#datasource.getDisplayName()#</title></cfoutput>');
		wrapper.AppendBody('<link rel="stylesheet" href="#csspath#/screen.css" type="text/css" media="screen"/>');

		
		wrapper.AppendBody('</head>');
		wrapper.AppendBody('<body>');
		wrapper.AppendBody('<h1>#datasource.getDisplayName()#</h1>');
		wrapper.AppendBody('<cfelse>');
		wrapper.AppendBody('</body>');
		wrapper.AppendBody('</html>');
		wrapper.AppendBody('</cfif>');
		wrapper.AppendBody('</cfprocessingdirective>');
		
		
		
	    
		return wrapper ;
	
	
	}
	
	public any function createORMServiceCFC(required any table, required string path, required string EntityCFCPath, string access ="public"){
		var i=0;
		var EntityName = table.getEntityName();
		var OrderBy = table.getOrderBy();
		var cfcPath = EntityCFCPath;
		var columns = table.getColumns();
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(EntityName & "Service");
	    cfc.setFileLocation(path);
	    
		//create Count Method
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('count');
		func.setAccess(arguments.access);
		func.setReturnType("numeric");
		func.setReturnResult('ormExecuteQuery("select Count(*) from #entityName#")[1]');
		cfc.addFunction(func);
		
		//create list method
		var list= New apptacular.handlers.cfc.code.function();
		list.setName('list');
		list.setAccess(arguments.access);
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
		func.setAccess(arguments.access);
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
		func.setAccess(arguments.access);
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
		func.setAccess(arguments.access);
		func.setReturnType("void");
		func.AddArgument(arg);
		func.AddOperation('		<cfset EntityDelete(arguments.#EntityName#) />');
		func.AddOperationScript('		EntityDelete(arguments.#EntityName#);');		
		cfc.addFunction(func);
		
		//Search Method
		var search= New apptacular.handlers.cfc.code.function();
		search.setName("search");
		search.setAccess(arguments.access);
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

	public void function copyCSS(){
		conditionallyCreateDirectory(config.getCSSFilePath());
		var origCSS = ExpandPath("generators/cfapp/storage/screen.css");
		var newCSS = config.getCSSFilePath() & variables.FS & "screen.css";
		FileCopy(origCSS, newCSS);
	}
	
	public void function copyGradient(){
		conditionallyCreateDirectory(config.getCSSFilePath());
		var origCSS = ExpandPath("generators/cfapp/storage/appgrad.jpg");
		var newCSS = config.getCSSFilePath() & variables.FS & "appgrad.jpg";
		FileCopy(origCSS, newCSS);
	}
	
	public void function copyForeignKeyCustomTag(){
		conditionallyCreateDirectory(config.getCustomTagFilePath());
		var origCT = ExpandPath("generators/cfapp/storage/foreignKeySelector.cfm");
		var newCT = config.getCustomTagFilePath() & variables.FS & "foreignKeySelector.cfm";
		FileCopy(origCT, newCT);
	}
	
	public void function copyLoginCustomTag(){
		conditionallyCreateDirectory(config.getCustomTagFilePath());
		var origCT = ExpandPath("generators/cfapp/storage/loginForm.cfm");
		var newCT = config.getCustomTagFilePath() & variables.FS & "loginForm.cfm";
		FileCopy(origCT, newCT);
	}
	
	public void function copyManyToManyCustomTag(){
		conditionallyCreateDirectory(config.getCustomTagFilePath());
		var origCT = ExpandPath("generators/cfapp/storage/manyToManySelector.cfm");
		var newCT = config.getCustomTagFilePath() & variables.FS & "manyToManySelector.cfm";
		FileCopy(origCT, newCT);
	}
	
	public void function copyManyToManyReaderCustomTag(){
		conditionallyCreateDirectory(config.getCustomTagFilePath());
		var origCT = ExpandPath("generators/cfapp/storage/manyToManyReader.cfm");
		var newCT = config.getCustomTagFilePath() & variables.FS & "manyToManyReader.cfm";
		FileCopy(origCT, newCT);
	}

	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
}