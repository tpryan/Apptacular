
<cfsetting showdebugoutput="FALSE" />

<cftry>
<cfscript>
	builderHelper = application.builderhelper;
	cgiUtils = New apptacular.handlers.cfc.utils.cgiUtils(cgi);
	utils = New apptacular.handlers.cfc.utils.utils();
	projectPath = BuilderHelper.getProjectPath();
	resourcePath = BuilderHelper.getResourcePath();
	configPath = utils.findConfig(projectPath,resourcePath);
	schemaPath = utils.findConfig(projectPath,resourcePath, "schema");
	baseURL = cgiUtils.getBaseURL();
	
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	files = DirectoryList(schemaPath, true, "query", "*.xml");
</cfscript>

<!--- Speficically catch errors that come about when apptacular configuration is message. --->
<cfcatch type="any">
	<cfif FindNoCase("/dev/null",cfcatch.Message)>
		<cfset messageFolder = getDirectoryFromPath(cgi.script_name) />
		<cfset messageFolder = Replace(messageFolder, ListLast(messageFolder, "/"), "", "once") />
		
		<cfset messagesPath = messageFolder & "/messages.cfm" />
		<cfset messagesOptions = "?type=corruptconfig" />
		<cfset messagesURL = baseURL  & messagesPath & messagesOptions />
		
		<cf_ideWrapper messageURL="#messagesURL#" />
		<cfabort>
	<cfelse>
		<cfrethrow>
	</cfif>	
</cfcatch>

</cftry>


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