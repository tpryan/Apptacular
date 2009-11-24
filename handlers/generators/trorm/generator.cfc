component{

	public generator function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");		
		return This;
	}
	
	public void function generate(required any datasource, required any config){
		var i =0;
		
		if (config.getCreateAppCFC()){
			createAppCFC(datasource, config.getRootFilePath()).write(config.getCFCFormat());
		}
		
		if (config.getCreateViews()){
			createIndex(datasource, config.getRootFilePath()).write();
			writeCSS(config.getCSSFilePath());
			createPageWrapper(datasource, config.getCustomTagFilePath(), config.getCSSRelativePath()).write();
		}
		
		var tables = arguments.datasource.getTables();
		
		for (i=1; i <= ArrayLen(tables); i++){
			
			if (config.getCreateEntities()){
				createORMCFC(tables[i], config.getEntityFilePath()).write(config.getCFCFormat());
			}
			if (config.getCreateViews()){
				createViewListCustomTag(tables[i], config.getCustomTagFilePath()).write();
				createViewReadCustomTag(tables[i], config.getCustomTagFilePath()).write();
				createViewEditCustomTag(tables[i], config.getCustomTagFilePath()).write();
				createView(tables[i], config.getRootFilePath(), config.getEntityCFCPath()).write();
			}
			if (config.getCreateServices()){
				createORMServiceCFC(tables[i], config.getServiceFilePath(), config.getEntityCFCPath(), config.getServiceAccess()).write(config.getCFCFormat());
			}
		}
		
		
	
	}
	
	public any function createORMCFC(required any table, required string path){
		var i = 0;
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
			property.setOrmType(column.getOrmType());
	       	
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
	       	/*else if (column.isForeignKey()){
	       		property.setName(tableData.columns.referenced_primarykey_table[i]);
	       		property.setFieldtype('many-to-one');
	       		property.setFkcolumn(tableData.columns.referenced_primarykey[i]);
	       		property.setCFC(tableData.columns.referenced_primarykey_table[i]);
	       		property.setInverse(true);
	       		property.SetmissingRowIgnored(true);
	       	}*/	
	        
	        cfc.AddProperty(property);
	    }
	   
	   		/*for (i=1; i lte tableData.foreignkeys.recordCount; i++){
			property = New property();
			property.setName(tableData.foreignkeys.fktable_name[i]);
	   		property.setFieldtype('one-to-many');
	   		property.setFkcolumn(tableData.foreignkeys.fkcolumn_name[i]);
	   		property.setCFC(tableData.foreignkeys.fktable_name[i]);
	   		property.setCascade("all-delete-orphan");
	   		cfc.AddProperty(property);
			
		}*/
		
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
	
	public any function createAppCFC(required any datasource, required string path){
		
	    var dbname = arguments.datasource.getName();
	    var fileLocation = arguments.path;
	    
	    var appCFC  =  New apptacular.handlers.cfc.code.applicationCFC();
	    appCFC.setName('Application') ;
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty("customTagPaths", "ExpandPath('customtags/')", false) ;
		
		
		
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
		
	    var ct  = New apptacular.handlers.cfc.code.customTag(fileName, fileLocation);
		ct.addAttribute(table.getEntityName() & "Array", "array", true);
			
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "deleted") eq 0>');
		ct.AppendBody('	<p class="alert">Record deleted</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		ct.AppendBody('	<p><a href="?method=edit">New</a></p>');	
		ct.AppendBody('<table>');
		ct.AppendBody('	<thead>');
		ct.AppendBody('		<tr>');
		
		var columns = table.getColumns();
		
		for (i = 1; i <= ArrayLen(columns); i++){
		 	if (not columns[i].getIsForeignKey()){
		 		ct.AppendBody('			<th>#columns[i].getDisplayName()#</th>');
			}
		}
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</thead>');
		
		ct.AppendBody('	<tbody>');
		ct.AppendBody('	<cfoutput>');
		ct.AppendBody('	<cfloop array="##attributes.#table.getEntityName()#Array##" index="#table.getEntityName()#">');
		
		ct.AppendBody('		<tr>');
		
		for (i = 1; i <= ArrayLen(columns); i++){
		 	if (not columns[i].getIsForeignKey()){
				ct.AppendBody('			<td>###table.getEntityName()#.get#columns[i].getName()#()##</td>');
			}
		}
		
		ct.AppendBody('			<td><a href="?method=read&#identity#=###table.getEntityName()#.get#identity#()##">Read</a></td>');
		ct.AppendBody('			<td><a href="?method=edit&#identity#=###table.getEntityName()#.get#identity#()##">Edit</a></td>');
		ct.AppendBody('			<td><a href="?method=delete_process&#identity#=###table.getEntityName()#.get#identity#()##" onclick="if (confirm(''Are you sure?'')) { return true}; return false"">Delete</a></td>');
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
		ct.AppendBody('<cfset #EntityName# = attributes.#EntityName# /> ');
		ct.AppendBody('<cfoutput>');
		ct.AppendBody('<p><a href="?method=edit&amp;#identity#=###EntityName#.get#identity#()##">Edit</a></p>');
		ct.AppendBody('<table>');
		ct.AppendBody('	<tbody>');
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			column = columns[i];
		 	if (not column.GetIsForeignKey()){
		 		ct.AppendBody('		<tr>');
		 		ct.AppendBody('			<th>#column.getName()#</th>');
		 		ct.AppendBody('			<td>###EntityName#.get#column.getName()#()##</td>');
				ct.AppendBody('		</tr>');
			}
		}
		
		
		ct.AppendBody('	</tbody>');
		ct.AppendBody('</table>');
		ct.AppendBody('</cfoutput>');
	    
	    return ct;
	}
	
	public any function createViewEditCustomTag(required any table, required string path){
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
		ct.AppendBody('<p><a href="?method=read&amp;#identity#=###EntityName#.get#identity#()##">Read</a></p>');
		ct.AppendBody('<cfform action="?method=edit_process" method="post" format="html">');
		
		ct.AppendBody('	<table>');
		ct.AppendBody('	<tbody>');
		
		
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			column = columns[i];
		 	if (not column.GetIsForeignKey()){
		 	
				columnName = column.getName();
					
		 		if (column.getIsPrimaryKey()){
		 			ct.AppendBody('			<input name="#columnName#" type="hidden" value="###EntityName#.get#columnName#()##" />');
		 		}
				else{
		 			uitype = column.getUIType();
					
					ct.AppendBody('		<tr>');
					
					//Create different UI's depending on data type.
					if (compareNoCase(uitype, "date") eq 0){
						ct.AppendBody('			<th><label for="#columnName#">#columnName#:</label></th>');
		 				ct.AppendBody('			<td><cfinput name="#columnName#" type="datefield" id="#columnName#" value="##DateFormat(#EntityName#.get#columnName#(),''mm/dd/yyyy'')##" /></td>');
					}
					else{
						ct.AppendBody('			<th><label for="#columnName#">#columnName#:</label></th>');
		 				ct.AppendBody('			<td><input name="#columnName#" type="text" id="#columnName#" value="###EntityName#.get#columnName#()##" /></td>');
					}
					
					ct.AppendBody('		</tr>');
				}
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
		view.AppendBody('<cfoutput><p><a href="index.cfm">Main</a> / <a href="##cgi.script_name##">#displayName# List</a></cfoutput>');
		view.AppendBody();
	    view.AppendBody('<cfswitch expression="##url.method##" >');
		view.AppendBody();
	   	view.AppendBody('	<cfcase value="list">');
	    view.AppendBody('		<cfset #entityName#Array = entityLoad("' & entityName  & '") />');
	    view.AppendBody('		<cf_#entityName#List #entityName#Array = "###entityName#Array##" message="##url.message##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    
		view.AppendBody('	<cfcase value="read">');
	    view.AppendBody('		<cfset #entityName# = entityLoad("' & entityName  & '", url.#identity#, true) />');
	    view.AppendBody('		<cf_#entityName#Read #entityName# = "###entityName###" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit">');
	    view.AppendBody('		<cfif url.#identity# eq 0>');
	    view.AppendBody('			<cfset #entityName# = New ' & entityName  & '() />');
	    view.AppendBody('		<cfelse>');
	    view.AppendBody('			<cfset #entityName# = entityLoad("' & entityName  & '", url.#identity#, true) />');
	    view.AppendBody('		</cfif>');
		view.AppendBody();
	    view.AppendBody('		<cf_#entityName#Edit #entityName# = "###entityName###" message="##url.message##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit_process">');
	    view.AppendBody('		<cfset #entityName# = EntityNew("' & entityName  & '") />');
	    
	    for (i= 1; i <= ArrayLen(columns); i++){
			column = columns[i];
	    	if(column.getIsPrimaryKey()){
	    		view.AppendBody('		<cfif form.#column.getName()# gt 0>');
	    		view.AppendBody('			<cfset #entityName#.set#column.getName()#(form.#column.getName()#)  />');
	    		view.AppendBody('		</cfif>');
	    	}
	    	else{ 
	    		view.AppendBody('		<cfset #entityName#.set#column.getName()#(form.#column.getName()#)  />');
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
	    	index.AppendBody('	<li><a href="#table.getEntityName()#.cfm">#table.getDisplayName()#</a></li>');
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

	public void function writeCSS(required string cssLocation){
		conditionallyCreateDirectory(cssLocation);
		var origCSS = ExpandPath("generators/trorm/storage/screen.css");
		var newCSS = cssLocation & variables.FS & "screen.css";
		FileCopy(origCSS, newCSS);
	}


	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
}