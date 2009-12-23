component extends="codeGenerator"{


	/**
	* @hint Contains all the code it takes to generate orm/entity CFCs for every table in the database. 
	*/
	public any function createORMCFC(required any table){
		var i = 0;
		var j = 0;
		var k = 0;
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
		cfc.setFormat(variables.config.getCFCFormat());
	    cfc.setName(table.getEntityName());
	    cfc.setFileLocation(variables.config.getEntityFilePath());
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
	        var column = columns[i];
	       	
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
				
				if (table.getForeignTableCount(fTable.getName()) gt 1){
					property.setName(column.getName());
					property.setInsert(false);
					property.setUpdate(false);
				}	
				else{
					property.setName(fTable.getEntityName());
				}
				
				
				property.setType("");
				property.setOrmType("");
				property.setFieldtype('many-to-one');
	       		property.setFkcolumn(column.getName());
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
					var property = New apptacular.handlers.cfc.code.property();
					
					if (table.getReferenceCount(foreignTable.getName()) gt 1){
						property.setName(foreignTable.getPlural() & ref.getforeignKey());
						
					}
					else{
						property.setName(foreignTable.getPlural());
					}
					
					
			   		property.setFieldtype('one-to-many');
			   		property.setFkcolumn(ref.getforeignKey());
			   		property.setCFC(foreignTable.getEntityName());
			   		property.setCascade("all-delete-orphan");
					property.setSingularname(foreignTable.getEntityName());
					property.setOrderby(foreignTable.getOrderBy());
			   		cfc.AddProperty(property);
					
					var countFunc= New apptacular.handlers.cfc.code.function();
					countFunc.setAccess("public");
					countFunc.setReturnType('numeric');
					countFunc.setReturnResult('result');
					
					var ftEntityName = foreignTable.getEntityName();
					var ftPlural = foreignTable.getPlural();
					var entityName = table.getEntityName();
					var id = table.getIdentity();
					
					if (table.getReferenceCount(foreignTable.getName()) gt 1){
						countFunc.setName("get#ftEntityName##ref.getforeignKey()#Count");
						var selectString = "#ftPlural##ref.getforeignKey()#.size";
					
					}
					else{
						countFunc.setName("get#ftEntityName#Count");
						var selectString = "#foreignTable.getPlural()#.size";
					
					}
					
					countFunc.AddSimpleSet('var hql = "select #selectString# from #entityName# #entityName# where #entityName#.#id# = ''##This.get#id#()##''"',2);
					countFunc.AddSimpleSet("var result = ormExecuteQuery(hql)[1]",2);
					
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
	
	/**
	* @hint Generates the default event handlers for the application allowing magic columns to work.  
	*/
	public any function createEventHandler(required string path){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    var fileLocation = variables.config.getEntityFilePath();
		
		cfc.setFormat(variables.config.getCFCFormat());
	    cfc.setName("eventHandler");
	    cfc.setFileLocation(fileLocation);
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
	
	/**
	* @hint Generates the ApplicationCFC
	*/
	public any function createAppCFC(){
		
	    var dbname = variables.datasource.getName();
	    var fileLocation = variables.config.getRootFilePath();
	    var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
		appCFC.setFormat(variables.config.getCFCFormat());
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty("customTagPaths", "ExpandPath('#config.getCustomTagFolder()#/')", false) ;
		appCFC.addApplicationProperty('ormsettings.eventHandler', "#config.getEntityCFCPath()#.eventHandler") ;
		if (config.getLogSQL()){
			appCFC.addApplicationProperty('ormsettings.logSQL', true) ;
		}
		
		
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


}