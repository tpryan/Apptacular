<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />

<cfset message = "" />

<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	tablePath = path & FS & "_table.xml";
	datasourcePath = listDeleteAt(path, listLen(path, FS), FS);
	
	files = DirectoryList(path, true, "query", "*.xml");
	tables = DirectoryList(datasourcePath, false, "query");
</cfscript>

<cfquery name="tables" dbtype="query">
	SELECT 	directory + '#FS#' + name as tablepath
	FROM 	tables
	WHERE	name != '_datasource.xml'
</cfquery>

<cfset breadcrumbStruct = structNew() />
<cfloop query="tables">
	<cfif FindNoCase(tablepath, path)>
		<cfset breadcrumbStruct.previous = tables.tablepath[tables.currentRow -1] />
		<cfset breadcrumbStruct.next = tables.tablepath[tables.currentRow +1] />
	</cfif>
</cfloop>



<cfquery name="columns" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name != '_table.xml'
</cfquery>

<cf_pageWrapper>


<cfoutput>
	<table class="breadcrumb">
		<tr>
			<cfif len(breadcrumbStruct.previous)>
				<td id="prev">&larr;<a href="editTable.cfm?path=#URLEncodedFormat(breadcrumbStruct.previous)#">Edit <strong>#ListLast(breadcrumbStruct.previous, FS)#</strong></a></td>
			<cfelse>
				<td id="prev"></td>
			</cfif>
			
			
			<td>&uarr;<a href="editDatasource.cfm?datasourcepath=#URLEncodedFormat(datasourcePath)#">Edit <strong>#ListLast(datasourcePath, FS)#</strong>&uarr;</a></td>
			
			<cfif len(breadcrumbStruct.next)>
				<td id="next"><a href="editTable.cfm?path=#URLEncodedFormat(breadcrumbStruct.next)#">Edit <strong>#ListLast(breadcrumbStruct.next, FS)#</strong>&rarr;</a></td>
			<cfelse>
				<td id="next"></td>
			</cfif>		
		<tr>
	</table>


</cfoutput>

<cf_XMLForm fileToEdit="#tablePath#" message="#message#" />
<cf_XMLColumnsForm tablePathToEdit="#path#" />

<!---<h2>Edit Columns</h2>
<ul>
<cfoutput query="columns">
	<cfset fileName = directory & fs & name />
	<li><a href="editColumn.cfm?path=#URLEncodedFormat(fileName)#">#ListFirst(name, ".")#</a></li>

</cfoutput>
</ul>--->

</cf_pageWrapper>
