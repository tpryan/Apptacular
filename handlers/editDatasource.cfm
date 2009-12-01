<cfsetting showdebugoutput="FALSE" />

<cfif StructKeyExists(url, "datasourcePath")>
	<cfset schemaPath= url.datasourcePath />
</cfif>

<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	files = DirectoryList(schemaPath, true, "query", "*.xml");
</cfscript>



<cfquery name="datasource" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name = '_datasource.xml'
</cfquery>

<cfquery name="tables" dbtype="query">
	SELECT 	*
	FROM 	files
	WHERE	name = '_table.xml'
</cfquery>

<cfset path = datasource.directory & FS & datasource.name />

<cfset message = "" />

<cf_pageWrapper>

<cf_XMLForm fileToEdit="#path#" message="#message#" />


<h2>Edit Tables</h2>
<ul>
<cfoutput query="tables">
	<li><a href="editTable.cfm?path=#URLEncodedFormat(directory)#">#ListLast(directory, FS)#</a></li>

</cfoutput>
</ul>

</cf_pageWrapper>