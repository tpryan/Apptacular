<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
	
	<cfparam name="attributes.fileToEdit" type="string" />
	<cfparam name="attributes.message" type="string" default="" />
	<cfparam name="attributes.cfcreference" type="string" default="" />
	
	<cfset message = attributes.message />
	
	<cfset tooltips = generateToolTips(attributes.cfcreference) />
	
	<cfset allowed = structNew() />
	<cfset allowed['datasource'] = "displayName" />
	<cfset allowed['table'] = "displayName,displayPlural,ForeignKeyLabel,orderby,plural,createInterface,IsJoinTable" />
	<cfset allowed['column'] = "displayName,uiType" />
	<cfset allowed['config'] = "LockApplication,CreateAppCFC,CreateEntities,CreateViews,CreateServices,CreateLogin,OverwriteDataModel,">
	<cfset allowed['config'] = allowed['config'] & "<Path Information>,rootCFCPath,rootFilePath,cssfolder,customTagFolder,entityFolder,serviceFolder," />
	<cfset allowed['config'] = allowed['config'] & "<Misc>,serviceAccess,CFCFormat,WireOneToManyinViews,LogSQL,<Formats>,dateformat,timeformat," />
	<cfset allowed['config'] = allowed['config'] & "<Magic Fields>,createdOnString,updatedOnString," />
	<cfset allowed['config'] = allowed['config'] & "<MXUnit Settings>,CreateTests,MXUnitFilePath,testFolder" />
	<cfset allowed['virtualcolumn'] = "name,displayName,getterCode,type,uiType" />
	
	<cfset booleans['datasource'] = "" />
	<cfset booleans['table'] = "createInterface,IsJoinTable" />
	<cfset booleans['column'] = "" />
	<cfset booleans['config'] = "LockApplication,CreateAppCFC,CreateEntities,CreateLogin,CreateServices,CreateViews,OverwriteDataModel,CreateTests,WireOneToManyinViews,LogSQL" />
	<cfset booleans['virtualcolumn'] = "" />
	
	<cfset textareas['datasource'] = "" />
	<cfset textareas['table'] = "" />
	<cfset textareas['column'] = "" />
	<cfset textareas['config'] = "" />
	<cfset textareas['virtualcolumn'] = "getterCode" />
	
	<cfif structKeyExists(form, "submit")>
	
		<cfset XMLInfo = Duplicate(form) />
		<cfset fileToEdit = XMLInfo.filetoedit />
		<cfset structDelete(XMLInfo, "filetoedit") />
		<cfset structDelete(XMLInfo, "fieldnames") />
		<cfset structDelete(XMLInfo, "submit") />
		
		<cfset XML = XMLParse(FileRead(fileToEdit)) />
		<cfset XMLRoot = StructKeyArray(XML)[1] />
		<cfset Keys = StructKeyArray(XMLInfo) />
		
		<cfloop array="#keys#" index="key" >
			<cfif FindNoCase("code", key)>
				<cfset XML[XMLRoot][key]['XmlCdata'] = XMLInfo[key] />
			<cfelse>
				<cfset XML[XMLRoot][key]['XMLText'] = Trim(XMLInfo[key]) />
			</cfif>
		</cfloop>
		
		<cfset FileWrite(fileToEdit,XML) />
		<cfset message = "Changed Saved" />
	</cfif>
	
	
	<cfset fileToEdit = attributes.fileToEdit />
	<cfset XML = XMLParse(FileRead(fileToEdit)) />
	<cfset XMLRoot = StructKeyArray(XML)[1] />
	<cfset Keys = ListToArray(allowed[XMLRoot]) />
	
	<cfoutput>
		<h1>Edit #XMLRoot#</h1>
		<cfif len(message)>
			<p class="alert">#message#</p>
		</cfif>
		<cfform action="" method="post">
			<input type="hidden" name="fileToEdit" value="#fileToEdit#" /> 	
			<table>
			
			<cfloop array="#keys#" index="key" >
				<cfif FindNoCase("<", key)>
					<tr><th>&nbsp;</th></tr>	
					<tr><th /><th><strong>#ReplaceList(key, "<,>,/", ",,")#</strong></th></tr>	
					<cfcontinue />
				
				</cfif>
				<cfif ListFindNoCase(booleans[XMLRoot], key)>
					<tr>	
						<th><label for="#key#">#key#</label></th>
						<td>
							<cfTooltip tooltip="#getToolTip(key)#"> 
							<input name="#key#" type="radio" id="#key#true" value="true" <cfif IsBoolean(XML[XMLRoot][key]['XMLText']) AND XML[XMLRoot][key]['XMLText']>checked="checked" </cfif>/>
							<label for="#key#true">True</label>
							<input name="#key#" type="radio" id="#key#false" value="false" <cfif IsBoolean(XML[XMLRoot][key]['XMLText']) AND NOT XML[XMLRoot][key]['XMLText']>checked="checked" </cfif>/>
							<label for="#key#false">False</label>
							</cftooltip>
						</td>			
					</tr>
				<cfelseif ListFindNoCase(textareas[XMLRoot], key)>
					<tr>	
						<th><label for="#key#">#key#</label></th>
						<td>
							<cftextarea name="#key#" tooltip="#getToolTip(key)#" >#XML[XMLRoot][key]['XMLText']#</cftextarea>
						</td>			
					</tr>	
				<cfelse>
					<tr>	
						<th><label for="#key#">#key#</label></th>
						<td>
							<cfinput name="#key#" type="text" id="#key#" tooltip="#getToolTip(key)#" value="#XML[XMLRoot][key]['XMLText']#" />
						</td>			
					</tr>
				</cfif>
					
				
			</cfloop>
				<tr>
					<th />
					<td><input type="submit" name="submit" value="Save" />
				</tr>
			</table>
			
		</cfform>
	
    </cfoutput>

<cfelse>
</cfif>
</cfprocessingdirective>

<cfscript>
	
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