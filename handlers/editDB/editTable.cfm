<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />




<cfparam name="url.tab" type="string" default="table" />
<cfparam name="url.message" type="string" default="" />

<cfset tableOpen = true />
<cfset columnsOpen = false />
<cfset virtualOpen = false />
<cfset referenceOpen = false />


<cfswitch expression="#url.tab#">
	<cfcase value="columns">
		<cfset tableOpen = false />
		<cfset columnsOpen = true />
	</cfcase>
	<cfcase value="virtual">
		<cfset tableOpen = false />
		<cfset virtualOpen = true />
	</cfcase>
	<cfcase value="reference">
		<cfset tableOpen = false />
		<cfset referenceOpen = true />
	</cfcase>
</cfswitch>

<cfset message = url.message />

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
	AND 	name not like 'ref_%'
</cfquery>

<cfquery name="virtualColumns" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name != '_table.xml'
	AND		name like  'vc_%'
	AND		name not like '%apptacularTempNew%'
</cfquery>

<cfquery name="refs" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name != '_table.xml'
	AND		name like  'ref_%'
</cfquery>



<cf_pageWrapper>

<cfset prevLink = URLEncodedFormat(breadcrumbStruct.previous) />
<cfset prevLabel= ListLast(breadcrumbStruct.previous, FS) />
<cfset nextLink = URLEncodedFormat(breadcrumbStruct.next) />
<cfset nextLabel= ListLast(breadcrumbStruct.next, FS) />
<cfset dsLink = URLEncodedFormat(datasourcePath) />
<cfset dsLabel= ListLast(datasourcePath, FS) />

<cfoutput>
	<table class="breadcrumb">
		<tr>
			<cfif len(breadcrumbStruct.previous)>
				<td id="prev" class="nav"><a href="editTable.cfm?path=#prevLink#">&larr;#prevLabel#</a></td>
			<cfelse>
				<td id="prev"></td>
			</cfif>
			
			<td><a href="editDatasource.cfm?datasourcepath=#dsLink#">&uarr;#dsLabel#&uarr;</a></td>
			
			<cfif len(breadcrumbStruct.next)>
				<td id="next" class="nav"><a href="editTable.cfm?path=#nextLink#">#nextLabel#&rarr;</a></td>
			<cfelse>
				<td id="next"></td>
			</cfif>		
		<tr>
	</table>

<h1 class="table">#ListLast(path, FS)#</h1>
</cfoutput>


<cfset tableCFC = "apptacular.handlers.cfc.db.table" />
<cfset docHelper = new apptacular.handlers.cfc.utils.docHelper(tableCFC) />


<cflayout type="accordion" >

	<cflayoutarea title="Table" selected="#tableOpen#">
		<div class="accpanel">
		<cf_XMLForm fileToEdit="#tablePath#" message="#message#" cfcreference="#tableCFC#" helper="#docHelper#" /> 
		</div>
	</cflayoutarea> 
	
	<cflayoutarea title="Columns" selected="#columnsOpen#">
		<div class="accpanel">
		<cf_XMLColumnsForm tablePathToEdit="#path#" />
		</div>
	</cflayoutarea> 
	
	<cflayoutarea title="Virtual Columns" selected="#virtualOpen#">
		<div class="accpanel">
		<cfoutput>	
		<h2>Edit Virtual Columns</h2>
		<p class="helplink">
			<a href="../doc/fields.cfm?item=virtualcolumn">Virtual Column Reference</a>
		</p>
		<p>
			<a href="editVirtualColumn.cfm?path=#path#">Add Virtual Column</a><br />
		</p>
		<cfloop query="virtualColumns">
			<cfset path = directory & FS & name />
			<cfset vc = GetToken(GetToken(GetFileFromPath(path),1,"."), 2, "_")/>
			<p><a href="editVirtualColumn.cfm?path=#path#">#vc#</a> 
			(<a href="editVirtualColumn.cfm?path=#path#&amp;delete">Delete</a>)</p>
		</cfloop>
		    
		</cfoutput>
		</div>
	</cflayoutarea>
	
	<cflayoutarea title="Related Tables" selected="#referenceOpen#">
		<div class="accpanel">
		<cf_XMLRefsForm fileQuery="#refs#" tablePathToEdit="#path#" message="#message#"  />
		</div>
	</cflayoutarea> 
	 
</cflayout>

</cf_pageWrapper>
