<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">

	<cfparam name="attributes.tablePathToEdit" type="string" />
	<cfparam name="attributes.message" type="string" default="" />
	
	<cfset tooltips = generateToolTips("apptacular.handlers.cfc.db.column") />
	
	<cfscript>
		message = attributes.message;
		path = attributes.tablePathToEdit;
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
		files = DirectoryList(path, true, "query", "*.xml");
		editor = new apptacular.handlers.cfc.utils.editor('column');
		allowedcolumns = editor.getAllowedList();
		uiList = ArrayToList(New apptacular.handlers.cfc.db.mappings().getUiTypes());
	</cfscript>
	
	<cfscript>
	if (structKeyExists(form, "submitcolumns")){
	
		formInfo = duplicate(form);
		structDelete(formInfo, "submitcolumns");
		structDelete(formInfo, "fieldnames");

		updateStruct = structNew();
		formKeys = structKeyArray(formInfo);
		
		for (i = 1; i <= ArrayLen(formKeys); i++){
			updateStruct[getToken(formKeys[i], 1, ".")][getToken(formKeys[i], 2, ".")] = formInfo[formKeys[i]]; 
		}
		
		columns = structKeyArray(updateStruct);
		props = structKeyArray(updateStruct[columns[1]]);
		
		for (i = 1; i <= ArrayLen(columns); i++){
			filePath = path & fs & columns[i] & ".xml";
			XMLProps = XMLParse(FileRead(filePath));
		
			for (j = 1; j <= ArrayLen(props); j++){
				newvalue = updateStruct[columns[i]][props[j]];
				XMLProps['column'][props[j]]['XMLText'] = newvalue;
			}
			FileWrite(filePath,XMLProps);

		}
		message = "Columns Updated";
		
	}
	
	</cfscript>
	
	
	
	
	<cfquery name="columns" dbtype="query">
		SELECT 	*
		FROM 	files
		WHERE	name != '_table.xml'
		AND		name not like  'vc_%'
	</cfquery>
	
	
	<cfscript>
		columns = getColumnPropsQuery(path, allowedcolumns);
		
	
	</cfscript>
	
	<h2>Edit Columns</h2>
	<p class="helplink"><a href="../doc/fields.cfm?item=column">Column Reference</a></p>
		<cfif len(message)>
			<cfoutput><p class="alert">#message#</p></cfoutput>
		</cfif>
	<table id="columns">
	<cfform format="html" action="?path=#path#" method="post">
		<cfoutput>
			<tr>
				<cfloop list="#columns.columnList#" index="attribute">
					<th>#attribute#</th>
				</cfloop>
			</tr>
		
		
			<cflog text="#uilist#" />
        	<cfloop query="columns">
			<tr>
				<cfloop list="#columns.columnList#" index="attribute">
					<cfif attribute eq "column">
						<td>#columns[attribute][columns.currentRow]#</td>
					<cfelseif ListFindNoCase("uiType", attribute)>
						<cfset fieldname = columns['column'][columns.currentRow] & "." & attribute />
						<cfset value = columns[attribute][columns.currentRow] />
						<cflog text="#attribute#: #columns[attribute][columns.currentRow]#" />
						<td>
							<select name="#fieldname#" id="#attribute#">
								<cfloop list="#uilist#" index="uilisttype">
								<option value="#uilisttype#"<cfif CompareNoCase(uilisttype,value) eq 0> selected="selected"</cfif>>#uilisttype#</option>
								</cfloop>
							</select>
						</td>
					<cfelseif ListFindNoCase("displayname", attribute)>
						<cfset fieldname = columns['column'][columns.currentRow] & "." & attribute />
						<cfset value = columns[attribute][columns.currentRow] />
						<td>
							<input name="#fieldname#" type="text" value="#value#" tabindex="#currentRow#" />
						</td>			
					<cfelse>
						<cfset fieldname = columns['column'][columns.currentRow] & "." & attribute />
						<cfset value = columns[attribute][columns.currentRow] />
						<td>
							<input name="#fieldname#" type="text" value="#value#" />
						</td>
					</cfif>
				</cfloop>
				
				
			</tr>
			</cfloop>
        </cfoutput>


	   <tr><td><input type="submit" name="submitcolumns" value="Save" /></td></tr> 
	</cfform>
	</table>


<cfelse>
</cfif>
</cfprocessingdirective>

<cfscript>
	public array function getColumnPropertyList(required string filePath, required string allowedColumns){
		var XML = XMLParse(FileRead(filePath));
		var i = 0;
		var result = StructKeyArray(XML.column);
		for (i = ArrayLen(result); i > 0; i--){
			if(not ListFindNoCase(arguments.allowedColumns, result[i])){
				ArrayDeleteAt(result, i);
			}
		}
		
		return result;	
	
	}
	
	public query function getColumnPropsQuery(required string path, required string allowedColumns){
		var i = 0;
		var j = 0;
		var files = DirectoryList(path, true, "query", "*.xml");
		
		var qoq = new Query(); 
		var queryString = "	SELECT  *  
                          	FROM  	resultSet
							WHERE 	name != '_table.xml'
							AND		name not like  'vc_%'"; 
		qoq.setAttributes(resultSet = files);  
		qoq.SetDBType("query"); 
		var columns = qoq.execute(sql=queryString).getResult(); 
		
		var props = getColumnPropertyList(columns.directory[1] & fs & columns.name[1], arguments.allowedColumns);
		var result =  QueryNew(ArrayToList(props));
		
		for (i = 1; i <= columns.recordCount; i++){
			var filePath = columns.directory[i] & fs & columns.name[i];
			var XMLProps = XMLParse(FileRead(filePath));
			QueryAddRow(result);
			
			for (j = 1; j <= ArrayLen(props); j++){
				if(ListFindNoCase(arguments.allowedColumns, props[j])){
					QuerySetCell(result, props[j], XMLProps.column[props[j]].XMLText);
				}
			}
			
		}
		
		
	
		return result;
	}
	
	public struct function generateToolTips(string cfcreference =""){
		var i =  0;
		var result = StructNew();
		if (len(arguments.cfcreference) < 1){
			return result;
		}
		var metaData = GetComponentMetaData(arguments.cfcreference);
		var props = metaData.properties;
		
		
		for(i=1; i <= ArrayLen(props); i++){
			result[props[i]['name']] = props[i]['hint'];
		}
	
		return result;
	}

	

	public string function getToolTip(required string name){
		if(structKeyExists(variables.toolTips, arguments.name)){
			return variables.toolTips[arguments.name];
		}
		else{
			return "";
		}
	}

</cfscript>