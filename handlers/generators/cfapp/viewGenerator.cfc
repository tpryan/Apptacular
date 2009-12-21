component extends="codeGenerator"{

	public any function createViewListCustomTag(required any table){
	    var i = 0;
		var columnCount = 3;
		var fileLocation = variables.config.getCustomTagFilePath();
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
			var column = columns[i];
			
			if (column.getIsForeignKey()){
				var fkTable = datasource.getTable(column.getForeignKeyTable());
				ct.AppendBody('			<th>#fkTable.getDisplayName()#</th>');
			}
			
			else{
				ct.AppendBody('			<th>#column.getDisplayName()#</th>');
			}
			columnCount++;
			
		}
		
		var references = table.getReferences();
	   	
		if (not isNull(references)){
		
			for (j=1; j <= ArrayLen(references); j++){
				var ref = references[j];
				var foreignTable = datasource.getTable(ref.getForeignKeyTable());
				
				
				
				if (not foreignTable.getIsJoinTable()){
					
					if (table.getReferenceCount(foreignTable.getName()) gt 1){
						ct.AppendBody('			<th>#foreignTable.getEntityName()##ref.getforeignKey()#Count</th>');
						
					}
					else{
						ct.AppendBody('			<th>#foreignTable.getEntityName()#Count</th>');
					}
					
					
				
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
			var column = columns[1];
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
				
				
					if (table.getReferenceCount(foreignTable.getName()) gt 1){
						ct.AppendBody('			<th>###entityName#.get#foreignTable.getEntityName()##ref.getforeignKey()#Count()##</th>');
						
					}
					else{
						ct.AppendBody('			<th>###entityName#.get#foreignTable.getEntityName()#Count()##</th>');
					}
				
				
					
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
	
	public any function createViewReadCustomTag(required any table){
	    var i = 0;
		var fileLocation = variables.config.getCustomTagFilePath();
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
	
	public any function createViewEditCustomTag(required any table){
		var i = 0;
		var fileLocation = variables.config.getCustomTagFilePath();
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
				
				else if (variables.config.isMagicField(columnName)){
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
	
	public any function createView(required any table){
	    
	    var i=0;
		var fileLocation = variables.config.getRootFilePath();
	    var view  = New apptacular.handlers.cfc.code.CFPage(table.getEntityName(), fileLocation);
		var entityCFCPath = variables.config.getEntityCFCPath();
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
	    view.AppendBody('<cfimport path="#entityCFCPath#.*" />');
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
	
	public any function createIndex(){
		
		var path = variables.config.getRootFilePath();
		var i=0;
		var tables = variables.datasource.getTables();
	    
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
	
	public any function createPageWrapper(){
	    
		var path = variables.config.getCustomTagFilePath();
		var csspath = variables.config.getCSSRelativePath();
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
		wrapper.AppendBody('<h1>#variables.datasource.getDisplayName()#</h1>');
		wrapper.AppendBody('<cfelse>');
		wrapper.AppendBody('</body>');
		wrapper.AppendBody('</html>');
		wrapper.AppendBody('</cfif>');
		wrapper.AppendBody('</cfprocessingdirective>');
		
		
		
	    
		return wrapper ;
	
	
	}
	
	public any function createLogin(){
		var i=0;
	    var path = variables.config.getRootFilePath();
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


}