/**
* @hint Generates all code for ORM in the application
*/
component extends="codeGenerator"{

	/**
	* @hint Spins through all of the tables in the database and creates a service cfc for it. 
	*/
	public apptacular.handlers.cfc.code.cfc function createORMEditableEntityCFC(required any table){
		var i=0;
		var EntityName = table.getEntityName();
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(table.getEntityName());
	    cfc.setFileLocation(config.getEntityFilePath());
		cfc.setFormat(variables.config.getCFCFormat());
		cfc.setMappedSuperClass(true);
		cfc.setOverwriteable(false);
		cfc.PreprendSimpleComment("It is okay to edit this CFC, changes will not be written over.");
		
		return cfc;
	}

	/**
	* @hint Contains all the code it takes to generate orm/entity CFCs for every table in the database. 
	*/
	public apptacular.handlers.cfc.code.cfc function createORMCFC(required any table){
		var i = 0;
		var j = 0;
		var k = 0;
		var composites = StructNew();
		var compositeArray = ArrayNew(1);
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
		cfc.setFormat(variables.config.getCFCFormat());
	    cfc.setName(table.getEntityName());
	    cfc.setFileLocation(variables.config.getEntityFilePath());
	   	cfc.setPersistent(true);
		cfc.PreprendSimpleComment("NOTE: Any changes you make to this CFC will be written over if you regenerate the application.");
		
		// Create Init
		var init= New apptacular.handlers.cfc.code.func();
		init.setName('init');
		init.setHint("A initialization routine, runs when object is created.");
		
		
		//works around a bug in CF 9.0 where even non remotely called functions need to be remote
		//when accessed by a remote service.
		if (variables.config.getCreateServices()){
			init.setAccess(variables.config.getServiceAccess());
		}
		else{
			init.setAccess("public");
		}
		
		init.setReturnType(table.getEntityName());
		init.setReturnResult('This');
		
		
		if (not table.isEntitySameAsTableName()){
		    cfc.setTable(table.getName());
		    cfc.setEntityname(table.getEntityName());
	   	}
		
		if (len(table.getSchema() > 0)){
		    cfc.setTable(table.getName());
		    cfc.setEntityname(table.getEntityName());
			cfc.setSchema(table.getSchema());
	   	}
	    
		var columns = table.getColumns();
		
		
		
		for (i=1; i <= ArrayLen(columns); i++){
	        var column = columns[i];
	       	
	        var property = New apptacular.handlers.cfc.code.property();
	       	property.setName(column.getName());
			property.setType(column.getType());
			property.setORMType(column.getOrmType());
			property.setColumn(column.getColumn());
	       	
			if (not column.getIncludeInEntity()){
				continue;
			}
	       	
			//If it is an identity. 
	       	if (column.getIsPrimaryKey() or FindNoCase("Identity", column.getDataType())){
	       		property.setFieldtype('id');
	       		
				if (table.getisAutoIncrementing()){
					property.setGenerator('native');
				}
				else{
					property.setGenerator('assigned');
				}
	       	
			
			}
			
			//if it is a many to one based on fkeys	
	       	else if (column.getisForeignKey() AND not column.getIsMemeberOfCompositeForeignKey()){
				var fTable = dataSource.getTable(column.getForeignKeyTable());
				
				//Don't wire up many to ones's if the other table is set not to be wired up
				if (not fTable.getcreateInterface()){
					continue;
				}
				
				if (table.getForeignTableCount(fTable.getName()) gt 1 OR CompareNoCase(table.getName(), ftable.getName()) eq 0){
					property.setName(column.getName());
				}	
				else{
					property.setName(fTable.getEntityName());
				}
				
				property.setType("");
				property.setOrmType("");
				property.setRemotingFetch(true);
				property.setFieldtype('many-to-one');
	       		property.setFkcolumn(column.getName());
	       		property.setCFC(fTable.getEntityName());
	       		property.setInverse(true);
	       		property.SetmissingRowIgnored(true);
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
	        
	        cfc.AddProperty(property);
	    }
		
		
		var compositeArray = StructKeyArray(composites);
		
		//handle composite foreign key relationships
		for (i=1; i <= ArrayLen(compositeArray); i++){
			
	       	var fTable = dataSource.getTable(compositeArray[i]);
			
			//Don't wire up many to ones's if the other table is set not to be wired up
			if (not fTable.getcreateInterface()){
				continue;
			}
			
			var property = New apptacular.handlers.cfc.code.property();
			property.setName(fTable.getEntityName());
			property.setType("");
			property.setOrmType("");
			property.setFieldtype('many-to-one');
			property.setRemotingFetch(true);
       		property.setFkcolumn(composites[compositeArray[i]]);
       		property.setCFC(fTable.getEntityName());
       		property.setInverse(true);
       		property.SetmissingRowIgnored(true);
			property.setInsert(false);
			property.setUpdate(false);
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
					
					//Don't wire up many to many's if the far table is set not to be wired up
					if (not otherJoinTable.getcreateInterface() OR not ref.getIncludeInEntity()){
						continue;
					}
					
					var property = New apptacular.handlers.cfc.code.property();
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
			   		property.setRemotingFetch(true);
					property.setSingularname(otherJoinTable.getEntityName());
			   		cfc.AddProperty(property);
					
					var countFunc= New apptacular.handlers.cfc.code.func();
					countFunc.setName("get#otherJoinTable.getEntityName()#Count");
					countFunc.setAccess("public");
					countFunc.setHint("Returns the count of related (many to many) records in #table.getName()#");
					countFunc.setReturnType('numeric');
					countFunc.AddSimpleSet('var hql = "select #table.getEntityName()#.#otherJoinTable.getPlural()#.size as #otherJoinTable.getEntityName()#Count from #table.getEntityName()# #table.getEntityName()# where #table.getIdentity()# = ''##This.get#table.getIdentity()#()##''"',2);
					countFunc.AddSimpleSet('var result = ormExecuteQuery(hql)[1]', 2);	
					countFunc.setReturnResult("result");				
					cfc.addFunction(countFunc);
					
					
				
				}
				else{
				
					//Don't wire up many to many's if the far table is set not to be wired up
					if (not foreignTable.getcreateInterface() OR not ref.getIncludeInEntity()){
						continue;
					}
				
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
					property.setRemotingFetch(true);
			   		cfc.AddProperty(property);
					
					var countFunc= New apptacular.handlers.cfc.code.func();
					countFunc.setAccess("public");
					countFunc.setReturnType('numeric');
					countFunc.setReturnResult('result');
					countFunc.setHint("Returns the count of related (one to many) records in #foreignTable.getName()#");
					
					
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
			
			vcGetter = New apptacular.handlers.cfc.code.func();
			vcGetter.setName("get" & vc.getName());
			vcGetter.setAccess("public");
			vcGetter.setReturnType(vc.getType());
			vcGetter.setHint("Getter for Virtual Column [#vc.getName()#]");
			
			
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
			property.setHint("Virtual Column");
			cfc.AddProperty(property);
			
			//Add initialization to start up for object.
			init.addSimpleSet("variables.#vc.getName()# = This.get#vc.getName()#()", 1);
			
		}
		
		//NullifyZeroID is for use with Remote services.
		var pkeys = table.getPrimaryKeyColumns();
		var func= New apptacular.handlers.cfc.code.func();
		func.setHint("Nullifies blank or zero id's.  Useful for dealing with objects coming back from remoting.");
		func.setName('nullifyZeroID');
		func.setAccess("public");
		func.setReturnType('void');
		
		for (i=1; i <= arraylen(pkeys); i++){
			var pkey = pkeys[i];
			func.StartSimpleIF('get#pkey.getName()#() eq 0 OR get#pkey.getName()#() eq ""', 2);
			func.AddSimpleSet('set#pkey.getName()#(JavaCast("Null", ""))' ,3);
			func.EndSimpleIF(2);
		}
		
		
		cfc.addFunction(func);
		
		
		//Add populate function
		var populate= New apptacular.handlers.cfc.code.func();
		populate.setName('populate');
		populate.setHint("Populates the content of the object from a form structure.");
		
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
			
			if (not column.getIncludeInEntity()){
				continue;
			}
			
			if(column.getIsPrimaryKey()){
				populate.StartSimpleIF('StructKeyExists(arguments.formstruct, "#column.getName()#") AND arguments.formstruct.#column.getName()# gt 0',2);
				populate.AddLineBreak();
				populate.AddSimpleSet('var item = EntityLoad("#table.getEntityName()#", arguments.formstruct.#column.getName()#, true)',3);
				populate.AddLineBreak();
				
				populate.StartSimpleIF('not isNull(item)',3);
				
				populate.AddSimpleSet('This = item',4);
				populate.EndSimpleIF(3,true);
				populate.StartSimpleElse(3);
				populate.AddSimpleSet('This.set#column.getName()#(arguments.formstruct.#column.getName()#)',4);
				populate.EndSimpleIF(3);
				
				populate.EndSimpleIF(2);
				populate.AddLineBreak();
	    	}
			else if (column.getisForeignKey()){
				var fkTable = datasource.getTable(column.getForeignKeyTable());
				var fkEName = fkTable.getentityName();
				
				if (table.getForeignTableCount(fTable.getName()) gt 1 OR CompareNoCase(table.getName(), ftable.getName()) eq 0){
					var formItem = column.getName();
				}	
				else{
					var formItem = fkTable.getEntityName();
				}
				
				populate.StartSimpleIF('StructKeyExists(arguments.formstruct, "#formItem#")',2);
				populate.AddSimpleSet('#formItem# = entityLoad("#fkEName#", arguments.formStruct.#formItem#, true)', 3);
				populate.AddSimpleSet('This.set#formItem#(#formItem#)', 3);
				populate.EndSimpleIF(2);
				populate.AddLineBreak();
				
			}
	    	else if (not config.isMagicField(column.getName())){ 
				
				populate.StartSimpleIF('StructKeyExists(arguments.formstruct, "#column.getName()#")',2);
				populate.AddSimpleSet('This.set#column.getName()#(arguments.formstruct.#column.getName()#)',3);
				populate.EndSimpleIF(2);
				populate.AddLineBreak();
				
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
	public apptacular.handlers.cfc.code.cfc function createEventHandler(required string path){
	
		var cfc  = New apptacular.handlers.cfc.code.cfc();
	    var fileLocation = variables.config.getEntityFilePath();
		var access = variables.config.getServiceAccess();
		
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
		
		
		
		var postD= New apptacular.handlers.cfc.code.func();
		postD.setAccess(access);
		postD.setReturnType("void");
		postD.AddArgument(EntityArg);
		postD.setName('postDelete');
		postD.setHint("Event handler that fires after a delete operation.");
		cfc.addFunction(postD);
		
		var postI= New apptacular.handlers.cfc.code.func();
		postI.setAccess(access);
		postI.setReturnType("void");
		postI.AddArgument(EntityArg);
		postI.setName('postInsert');
		postI.setHint("Event handler that fires after a insert operation.");
		cfc.addFunction(postI);
		
		var postL= New apptacular.handlers.cfc.code.func();
		postL.setAccess(access);
		postL.setReturnType("void");
		postL.AddArgument(EntityArg);
		postL.setName('postLoad');
		postL.setHint("Event handler that fires after a load operation.");
		cfc.addFunction(postL);
		
		var postU= New apptacular.handlers.cfc.code.func();
		postU.setAccess(access);
		postU.setReturnType("void");
		postU.AddArgument(EntityArg);
		postU.setName('postUpdate');
		postU.setHint("Event handler that fires after a update operation.");
		cfc.addFunction(postU);
		
		var preD= New apptacular.handlers.cfc.code.func();
		preD.setAccess(access);
		preD.setReturnType("void");
		preD.AddArgument(EntityArg);
		preD.setName('preDelete');
		preD.setHint("Event handler that fires before a delete operation.");
		cfc.addFunction(preD);
		
		var preI= New apptacular.handlers.cfc.code.func();
		preI.setAccess(access);
		preI.setReturnType("void");
		preI.AddArgument(EntityArg);
		preI.setName('preInsert');
		preI.setHint("Event handler that fires before an insert operation. Ensures magic words get populated.");
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
		
		
		
		var preL= New apptacular.handlers.cfc.code.func();
		preL.setAccess(access);
		preL.setReturnType("void");
		preL.AddArgument(EntityArg);
		preL.setName('preLoad');
		preL.setHint("Event handler that fires before a load operation.");
		cfc.addFunction(preL);
		
		var preU= New apptacular.handlers.cfc.code.func();
		preU.setAccess(access);
		preU.setReturnType("void");
		preU.AddArgument(EntityArg);
		preU.setName('preUpdate');
		preU.setHint("Event handler that fires before a update operation. Ensures magic words get populated.");
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
	public apptacular.handlers.cfc.code.cfc function createAppCFC(){
		
	    var dbname = variables.datasource.getName();
	    var fileLocation = variables.config.getRootFilePath();
	    var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
		var tables = datasource.getTables();
		var i = 0;
		
		
		appCFC.setFormat(variables.config.getCFCFormat());
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty('customTagPaths', 'GetDirectoryFromPath(GetCurrentTemplatePath()) & "customtags"', false) ;
		appCFC.addApplicationProperty('ormsettings.eventHandler', "#config.getEntityCFCPath()#.eventHandler") ;
		appCFC.addApplicationProperty('ormsettings.dbcreate', "#config.getDbcreate()#") ;
		
		if (config.getLogSQL()){
			appCFC.addApplicationProperty('ormsettings.logSQL', true) ;
		}
		
		
		var onRequestStart= New apptacular.handlers.cfc.code.func();
		onRequestStart.setName('onRequestStart');
		onRequestStart.setAccess("public");
		onRequestStart.setReturnType("boolean");
		onRequestStart.setReturnResult('true');

		onRequestStart.AddLineBreak();
		onRequestStart.StartSimpleIF('structKeyExists(url, "reset_app")',2);
		onRequestStart.AddSimpleSet('ApplicationStop()', 3);
		onRequestStart.AddSimpleSet('location(cgi.script_name, false)', 3);
		onRequestStart.EndSimpleIF(2);
		onRequestStart.AddLineBreak();
		
		if (config.getCreateLogin()){
			appCFC.addApplicationProperty('sessionManagement', true) ;
		
			var onSessionStart= New apptacular.handlers.cfc.code.func();
			onSessionStart.setName('onSessionStart');
			onSessionStart.setAccess("public");
			onSessionStart.setReturnType("boolean");
			onSessionStart.setReturnResult('true');

			onSessionStart.AddSimpleSet('session.loggedOn = false', 2);
			onSessionStart.AddSimpleSet('session.username = ""', 2);
			
			appCFC.addFunction(onSessionStart);
			
			onRequestStart.StartSimpleIF('structKeyExists(url, "logout")',2);
			onRequestStart.AddSimpleSet('onSessionStart()', 3);
			onRequestStart.EndSimpleIF(2);
			onRequestStart.AddLineBreak();
			
			onRequestStart.AddOperation('		<cfif not session.loggedOn>');
			onRequestStart.AddOperation('			<cfinclude template="login.cfm">');
			onRequestStart.AddOperation('			<cfabort />');
			onRequestStart.AddOperation('		</cfif>');
			onRequestStart.AddOperationScript('		if (not session.loggedOn){');
			onRequestStart.AddOperationScript('			include "login.cfm";');
			onRequestStart.AddOperationScript('			abort;');
			onRequestStart.AddOperationScript('		}');
			onRequestStart.AddLineBreak();
			
			
			
	    }
		
		
		appCFC.addFunction(onRequestStart);
		
		
		var onAppStart= New apptacular.handlers.cfc.code.func();
		onAppStart.setName('onApplicationStart');
		onAppStart.setAccess("public");
		onAppStart.setReturnType("boolean");
		onAppStart.setReturnResult('true');
		
		
		for (i=1; i <= ArrayLen(tables); i++){
			var table = tables[i];
		
			if (table.isProperTable() and config.getCreateServices() and table.getCreateInterface()){
				onAppStart.AddSimpleSet('application.#table.GetEntityName()#Service = new #config.getServiceCFCPath()#.#table.GetEntityName()#Service()', 2);	
				
			}
			
		}	
		appCFC.addFunction(onAppStart);
		
		return appCFC ;
	}


}