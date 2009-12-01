<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />

<cfset message = "" />

<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	tablePath = path & FS & "_table.xml";
	files = DirectoryList(path, true, "query", "*.xml");
</cfscript>

<cfset datasourcePath = listDeleteAt(path, listLen(path, FS), FS) />

<cfquery name="columns" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name != '_table.xml'
</cfquery>


<cf_pageWrapper>


<cfoutput>
	<p class="breadcrumb">&larr;<a href="editDatasource.cfm?datasourcepath=#URLEncodedFormat(datasourcePath)#">Edit datasource: <strong>#ListLast(datasourcePath, FS)#</strong></a></p>
</cfoutput>

<cf_XMLForm fileToEdit="#tablePath#" message="#message#" />

<h2>Edit Columns</h2>
<ul>
<cfoutput query="columns">
	<cfset fileName = directory & fs & name />
	<li><a href="editColumn.cfm?path=#URLEncodedFormat(fileName)#">#ListFirst(name, ".")#</a></li>

</cfoutput>
</ul>

</cf_pageWrapper>
