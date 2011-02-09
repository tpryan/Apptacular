
<cfsetting showdebugoutput="FALSE" />


<cfscript>
	builderHelper = application.builderhelper;
	utils = New apptacular.handlers.cfc.utils.utils();
	projectPath = BuilderHelper.getProjectPath();
	resourcePath = BuilderHelper.getResourcePath();
	configPath = utils.findConfig(projectPath,resourcePath);
	schemaPath = utils.findConfig(projectPath,resourcePath, "schema");
	
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

<cfset datasourceCFC = "apptacular.handlers.cfc.db.datasource" />
<cfset docHelper = new apptacular.handlers.cfc.utils.docHelper(datasourceCFC) />

<cf_XMLForm fileToEdit="#path#" message="#message#" helper = "#docHelper#"   cfcreference="apptacular.handlers.cfc.db.datasource" />


<h2>Edit Tables</h2>
<ul>
<cfoutput query="tables">
	<li><a href="editTable.cfm?path=#URLEncodedFormat(directory)#">#ListLast(directory, FS)#</a></li>

</cfoutput>
</ul>

</cf_pageWrapper>