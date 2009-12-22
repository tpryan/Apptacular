<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />


<cfset directory = getDirectoryFromPath(path) />

<cfif structKeyExists(url, "delete")>
	<cffile action="delete" file="#path#" />
	<cflocation url="editTable.cfm?path=#URLEncodedFormat(directory)#" addtoken="false" />
</cfif>


<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	columns = DirectoryList(GetDirectoryFromPath(path), false, "query");	
</cfscript>



<cfquery name="columns" dbtype="query">
	SELECT 	directory + '#FS#' + name as columnpath
	FROM 	columns
	WHERE	name like 'vc_%'
	AND		name not like '%apptacularTempNew%'
</cfquery>

<cfset breadcrumbStruct = structNew() />
<cfloop query="columns">
	<cfif FindNoCase(columnpath, path)>
		<cfset breadcrumbStruct.previous = columns.columnpath[columns.currentRow -1] />
		<cfset breadcrumbStruct.next = columns.columnpath[columns.currentRow +1] />
	</cfif>
</cfloop>


<cfif structKeyExists(form, "fileToEdit") and GetFileFromPath(form.fileToEdit) eq "vc_apptacularTempNew.xml" >
	<cfset path = GetDirectoryFromPath(form.fileToEdit) & fs & "vc_" & form.name & ".xml" />
	<cfset fileMove(form.fileToEdit, path) />
	<cfset form.fileToEdit = path />
	
</cfif>

<cfif Not FindNoCase(right(path, 3), "xml")>
	<cfset path = path & fs & "vc_apptacularTempNew.xml" />
	<cfset vc = new apptacular.handlers.cfc.db.virtualColumn() />
	<cfset vc.setName(" ") />
	<cfset vc.setDisplayName(" ") />
	<cfset vc.setGetterCode(" ") />
	<cfset vc.setType("string") />
	<cfset vc.setUIType("string") />
	<cfset fileWrite(path, vc.objectToXML('virtualColumn')) />
</cfif>



<cfset message = "" />

<cf_pageWrapper>


<cfoutput>

	<table class="breadcrumb">
		<tr>
			<cfif structKeyExists(breadcrumbStruct, "previous") AND  len(breadcrumbStruct.previous)>
				<td id="prev">&larr;<a href="editVirtualColumn.cfm?path=#URLEncodedFormat(breadcrumbStruct.previous)#">Edit <strong>#ListFirst(ListLast(breadcrumbStruct.previous, FS), ".")#</strong></a></td>
			<cfelse>
				<td id="prev"></td>
			</cfif>
			
			
			<td>&uarr;<a href="editTable.cfm?path=#URLEncodedFormat(directory)#">Edit <strong>#ListLast(directory, FS)#</strong>&uarr;</a></td>
			
			<cfif structKeyExists(breadcrumbStruct, "next") AND  len(breadcrumbStruct.next)>
				<td id="next"><a href="editVirtualColumn.cfm?path=#URLEncodedFormat(breadcrumbStruct.next)#">Edit <strong>#ListFirst(ListLast(breadcrumbStruct.next, FS), ".")#</strong>&rarr;</a></td>
			<cfelse>
				<td id="next"></td>
			</cfif>		
		<tr>
	</table>

</cfoutput>

<cf_XMLForm fileToEdit="#path#" message="#message#"  cfcreference="apptacular.handlers.cfc.db.virtualcolumn" />


</cf_pageWrapper>