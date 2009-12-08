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
					
			   		property.setLazy(true);
					property.setSingularname(otherJoinTable.getEntityName());
			   		cfc.AddProperty(property);
				
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
			   		cfc.AddProperty(property);
				}
			}
	   	}
		
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
	
	public any function createAppCFC(required any datasource, required string path){
		
	    var dbname = arguments.datasource.getName();
	    var fileLocation = arguments.path;
	    
	    var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
	    appCFC.setName('Application') ;
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty("customTagPaths", "ExpandPath('#config.getCustomTagFolder()#/')", false) ;
		appCFC.addApplicationProperty('ormsettings.eventHandler', "#config.getEntityCFCPath()#.eventHandler") ;
		
		
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('onRequestStart');
		func.setAccess("public");
		func.setReturnType("boolean");

		func.AddOperation('		<cfif structKeyExists(url, "reset_app")>');
		func.AddOperation('			<cfset ApplicationStop() />');
		func.AddOperation('			<cfset location(cgi.script_name, false) />');
		func.AddOperation('		</cfif>');
		func.AddOperationScript('		if (structKeyExists(url, "reset_app")){');
		func.AddOperationScript('			ApplicationStop();');
		func.AddOperationScript('			location(cgi.script_name, false);');
		func.AddOperationScript('		}');


		func.setReturnResult('true');
		appCFC.addFunction(func);
		
		
	    
		return appCFC ;
	}
	
	public any function createViewListCustomTag(required any table, required string path){
	    var i = 0;
		var fileLocation = path;
		var fileName = table.getEntityName() & "List";
		var identity = table.getIdentity();
		var entityName =  table.getEntityName();
		
	    var ct  = New apptacular.handlers.cfc.code.customTag(fileName, fileLocation);
		ct.addAttribute(table.getEntityName() & "Array", "array", true);
			
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "deleted") eq 0>');
		ct.AppendBody('	<p class="alert">Record deleted</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		
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
			
			
		}
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('			<th>#otherJoinTable.getDisplayPlural()#</th>');
			
			}
		
		}		
		
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</thead>');
		
		ct.AppendBody('	<tbody>');
		ct.AppendBody('	<cfoutput>');
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
		
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
			
				ct.AppendBody('			<td><cf_manyToManyReader  entityname="#otherJoinTable.getEntityName()#" identity="#otherJoinTable.getIdentity()#" foreignKeylabel="#otherJoinTable.getForeignKeyLabel()#" selected="###EntityName#.get#otherJoinTable.getPlural()#()##"  /></td>');
			
			}
		
		}
		
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=read&#identity#=###entityName#.get#identity#()##">Read</a></td>');
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=edit&#identity#=###entityName#.get#identity#()##">Edit</a></td>');
		ct.AppendBody('			<td class="crudlink"><a href="#entityName#.cfm?method=delete_process&#identity#=###entityName#.get#identity#()##" onclick="if (confirm(''Are you sure?'')) { return true}; return false"">Delete</a></td>');
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</cfloop>');
		ct.AppendBody('	</cfoutput>');
		ct.AppendBody('	</tbody>');
		
		
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
	 				ct.AppendBody('			<td><cf_foreignkeySelector name="#fkTable.getEntityName()#" entityname="#fkTable.getEntityName()#" identity="#fkTable.getIdentity()#" foreignKeylabel="#fkTable.getforeignKeylabel()#" fieldValue="###fkTable.getEntityName()#Value##"  /></td>');	
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
				ct.AppendBody('			<td><cf_manyToManySelector name="#otherJoinTable.getPlural()#" entityname="#otherJoinTable.getEntityName()#" identity="#otherJoinTable.getIdentity()#" foreignKeylabel="#otherJoinTable.getForeignKeyLabel()#" selected="###EntityName#.get#otherJoinTable.getPlural()#()##"  /></td>');
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
		
	    view.AppendBody('<cfsetting showdebugoutput="false" />');
	    view.AppendBody('<cfparam name="url.method" type="string" default="list" />');
	    view.AppendBody('<cfparam name="url.#identity#" type="numeric" default="0" />');
	    view.AppendBody('<cfparam name="url.message" type="string" default="" />');
	    view.AppendBody('<cfimport path="#arguments.entityCFCPath#.*" />');
		view.AppendBody('<cf_pageWrapper>');
		view.AppendBody();
	   	view.AppendBody('<h2>#displayName#</h2>');
		view.AppendBody();
	    view.AppendBody('<cfswitch expression="##url.method##" >');
		view.AppendBody();
	   	view.AppendBody('	<cfcase value="list">');
	    view.AppendBody('		<cfset #entityName#Array = entityLoad("' & entityName  & '") />');
		view.AppendBody('		<cfoutput><p class="breadcrumb">');	
		view.AppendBody('			<a href="index.cfm">Main</a> / <a href="##cgi.script_name##">List</a> /');
		view.AppendBody('			<a href="#EntityName#.cfm?method=edit">New</a>');		
		view.AppendBody('		</p></cfoutput>');	
		
		view.AppendBody('		<cf_#entityName#List #entityName#Array = "###entityName#Array##" message="##url.message##" /> ');
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
	    
	    
	    for (i= 1; i <= ArrayLen(columns); i++){
			column = columns[i];
	    	if(column.getIsPrimaryKey()){
	    		view.AppendBody('		<cfif form.#column.getName()# gt 0>');
				view.AppendBody('			<cfset #entityName# = entityLoad("' & entityName  & '", form.#column.getName()#, true) />');
	    		view.AppendBody('		<cfelse>');
				view.AppendBody('			<cfset #entityName# = EntityNew("' & entityName  & '") />');
				view.AppendBody('		</cfif>');
	    	}
			else if (column.getisForeignKey()){
				var fkTable = datasource.getTable(column.getForeignKeyTable());
				fkEName = fkTable.getentityName();
				view.AppendBody('		<cfset #fkEName# = entityLoad("' & fkEName  & '", form.#fkEName#, true) />');
				view.AppendBody('		<cfset #entityName#.set#fkEName#(#fkEName#) />');
			}
	    	else if (not config.isMagicField(column.getName())){ 
	    		view.AppendBody('		<cfset #entityName#.set#column.getName()#(form.#column.getName()#)  />');
	    	}
	    }
		
		if (table.getHasJoinTable()){
			var joinTables = table.getJoinTables();
			for (i = 1; i <= ArrayLen(joinTables); i++){
				var joinTable = dataSource.getTable(joinTables[i]);
				var otherJoinTable = datasource.getTable(joinTable.getOtherJoinTable(table.getName()));		
				view.AppendBody('');
				view.AppendBody('		<cfif structKeyExists(form, "#otherJoinTable.getPlural()#")>');
				view.AppendBody('			<cfset #entityName#.set#otherJoinTable.getPlural()#([]) />');
				view.AppendBody('			<cfloop list="##form.#otherJoinTable.getPlural()###" index="id">');
				view.AppendBody('				<cfset #otherJoinTable.getEntityName()# = entityLoad("#otherJoinTable.getEntityName()#", id, true) />');
				view.AppendBody('				<cfset #entityName#.add#otherJoinTable.getEntityName()#(#otherJoinTable.getEntityName()#) />');
				view.AppendBody('			</cfloop>');
				view.AppendBody('		</cfif>');
				view.AppendBody('');
				
			
			}
		
		}
		
		
		
		
		
		
		
			
			
		
		
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
		var cfcPath = EntityCFCPath;
		var columns = table.getColumns();
	    
	    var cfc  = New apptacular.handlers.cfc.code.cfc();
	    cfc.setName(EntityName & "Service");
	    cfc.setFileLocation(path);
	    
		//create list method
		var func= New apptacular.handlers.cfc.code.function();
		func.setName('list');
		func.setAccess(arguments.access);
		func.setReturnType("#cfcPath#.#EntityName#[]");
		func.setReturnResult('EntityLoad("#EntityName#")');
		cfc.addFunction(func);
		
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
		var func= New apptacular.handlers.cfc.code.function();
		func.setName("search");
		func.setAccess(arguments.access);
		func.setReturnType("#cfcPath#.#EntityName#[]");
		func.addLocalVariable("hqlString","string","FROM #EntityName# ");
		func.addLocalVariable("whereClause","string","");
		
		var arg = New apptacular.handlers.cfc.code.Argument();
		arg.setName("q");
		arg.setType("string");
		arg.setDefaultValue("");
		func.addArgument(arg);
		
		
		func.AddOperationScript('		if (len(arguments.q) gt 0){');		
		func.AddOperation('		<cfif len(arguments.q) gt 0>');
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i].getName();
			
			if (FindNoCase("char",columns[i].getDataType())){
				func.AddOperationScript('			whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|"); 	  ');		
				func.AddOperation('				<cfset whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|") />');		
			}
		}
		
		func.AddOperationScript('			whereClause = Replace(whereClause, "|", " OR ", "all");');	
		func.AddOperation('			<cfset whereClause = Replace(whereClause, "|", " OR ", "all") />');	
		
		func.AddOperationScript('		}');		
		func.AddOperation('		</cfif>');
		
		func.AddOperationScript('		if (len(whereClause) gt 0){');	
		func.AddOperationScript('			hqlString = hqlString & " WHERE " & whereClause;');	
		func.AddOperationScript('		}');	
		
		func.AddOperation('		<cfif len(whereClause) gt 0>');
		func.AddOperation('			<cfset hqlString = hqlString & " WHERE " & whereClause />');
		func.AddOperation('		</cfif>');
		
		func.setReturnResult('ormExecuteQuery(hqlString)');
		cfc.addFunction(func);		
		
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