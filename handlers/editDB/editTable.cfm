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
	AND		name not like  'vc_%'
</cfquery>

<cfquery name="virtualColumns" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name != '_table.xml'
	AND		name like  'vc_%'
	AND		name not like '%apptacularTempNew%'
</cfquery>



<cf_pageWrapper>


<cfoutput>
	<table class="breadcrumb">
		<tr>
			<cfif len(breadcrumbStruct.previous)>
				<td id="prev"><a href="editTable.cfm?path=#URLEncodedFormat(breadcrumbStruct.previous)#">&larr;<strong>#ListLast(breadcrumbStruct.previous, FS)#</strong></a></td>
			<cfelse>
				<td id="prev"></td>
			</cfif>
			
			
			<td><a href="editDatasource.cfm?datasourcepath=#URLEncodedFormat(datasourcePath)#">&uarr;<strong>#ListLast(datasourcePath, FS)#</strong>&uarr;</a></td>
			
			<cfif len(breadcrumbStruct.next)>
				<td id="next"><a href="editTable.cfm?path=#URLEncodedFormat(breadcrumbStruct.next)#"><strong>#ListLast(breadcrumbStruct.next, FS)#</strong>&rarr;</a></td>
			<cfelse>
				<td id="next"></td>
			</cfif>		
		<tr>
	</table>

<h1 class="table">#ListLast(path, FS)#</h1>
</cfoutput>




<cf_XMLForm fileToEdit="#tablePath#" message="#message#" cfcreference="apptacular.handlers.cfc.db.table" /> 
<cfoutput>
<table>
<tr>
<td><cf_XMLColumnsForm tablePathToEdit="#path#" /></td>
<td> 
	<h2>Edit Virtual Columns</h2>
	<p class="helplink"><a href="../doc/fields.cfm?item=virtualcolumn">Virtual Column Reference</a></p>
	<table>
		<tr><td><a href="editVirtualColumn.cfm?path=#path#">Add Virtual Column</a></td></tr>
	
    	<cfloop query="virtualColumns">
			<cfset path = directory & FS & name />
			<cfset vc = GetToken(GetToken(GetFileFromPath(path),1,"."), 2, "_")/>
			<tr><td><a href="editVirtualColumn.cfm?path=#path#">#vc#</a> </td>
			<td>(<a href="editVirtualColumn.cfm?path=#path#&amp;delete">Delete</a>)</td></tr>
		</cfloop>
    
	</table>
</td>
</tr>
</table>
</cfoutput>


</cf_pageWrapper>
