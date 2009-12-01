<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />

<cfset message = "" />



<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
	
	columns = DirectoryList(GetDirectoryFromPath(path), false, "query");	
</cfscript>



<cfquery name="columns" dbtype="query">
	SELECT 	directory + '#FS#' + name as columnpath
	FROM 	columns
	WHERE	name != '_table.xml'
</cfquery>

<cfset breadcrumbStruct = structNew() />
<cfloop query="columns">
	<cfif FindNoCase(columnpath, path)>
		<cfset breadcrumbStruct.previous = columns.columnpath[columns.currentRow -1] />
		<cfset breadcrumbStruct.next = columns.columnpath[columns.currentRow +1] />
	</cfif>
</cfloop>




<cf_pageWrapper>


<cfset directory = getDirectoryFromPath(path) />
<cfoutput>

	<table class="breadcrumb">
		<tr>
			<cfif len(breadcrumbStruct.previous)>
				<td id="prev">&larr;<a href="editColumn.cfm?path=#URLEncodedFormat(breadcrumbStruct.previous)#">Edit <strong>#ListFirst(ListLast(breadcrumbStruct.previous, FS), ".")#</strong></a></td>
			<cfelse>
				<td id="prev"></td>
			</cfif>
			
			
			<td>&uarr;<a href="editTable.cfm?path=#URLEncodedFormat(directory)#">Edit <strong>#ListLast(directory, FS)#</strong>&uarr;</a></td>
			
			<cfif len(breadcrumbStruct.next)>
				<td id="next"><a href="editColumn.cfm?path=#URLEncodedFormat(breadcrumbStruct.next)#">Edit <strong>#ListFirst(ListLast(breadcrumbStruct.next, FS), ".")#</strong>&rarr;</a></td>
			<cfelse>
				<td id="next"></td>
			</cfif>		
		<tr>
	</table>

</cfoutput>
<cf_XMLForm fileToEdit="#path#" message="#message#" />

</cf_pageWrapper>
