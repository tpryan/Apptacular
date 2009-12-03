<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
	
	<cfparam name="attributes.fileToEdit" type="string" />
	<cfparam name="attributes.message" type="string" default="" />
	
	<cfset message = attributes.message />
	
	<cfset allowed = structNew() />
	<cfset allowed['datasource'] = "displayName" />
	<cfset allowed['table'] = "displayName,displayPlural,ForeignKeyLabel,plural,softdelete" />
	<cfset allowed['column'] = "displayName,uiType" />
	<cfset allowed['config'] = "" />
	
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
			<cfset XML[XMLRoot][key]['XMLText'] = XMLInfo[key] />
		</cfloop>
		
		<cfset FileWrite(fileToEdit,XML) />
		<cfset message = "Changed Saved" />
	</cfif>
	
	
	<cfset fileToEdit = attributes.fileToEdit />
	<cfset XML = XMLParse(FileRead(fileToEdit)) />
	<cfset XMLRoot = StructKeyArray(XML)[1] />
	<cfset Keys = StructKeyArray(XML[XMLRoot]) />
	
	
	
	
	
	
	
	
	
	
	<cfoutput>
		<h1>Edit #XMLRoot#</h1>
		<cfif len(message)>
			<p class="alert">#message#</p>
		</cfif>
		<form action="" method="post">
			<input type="hidden" name="fileToEdit" value="#fileToEdit#" /> 	
			<table>
			<cfloop array="#keys#" index="key" >
				<cfif len(allowed[XMLRoot]) eq 0 OR ListFindNoCase(allowed[XMLRoot], key)>
					<tr>	
						<th><label for="#key#">#key#</label></th>
						<td><input name="#key#" type="text" id="#key#" value="#XML[XMLRoot][key]['XMLText']#" /></td>			
					</tr>
				</cfif>
			</cfloop>
				<tr>
					<th />
					<td><input type="submit" name="submit" value="Save" />
				</tr>
			</table>
			
		</form>
	
    </cfoutput>

<cfelse>
</cfif>
</cfprocessingdirective>