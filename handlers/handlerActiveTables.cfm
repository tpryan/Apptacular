<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>



<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editDB/editActiveTables.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cfscript>
	utils = New cfc.utils();
	XMLDoc = xmlParse(ideeventInfo);
	cgiUtils = New cfc.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	resourcePath = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
	configPath = utils.findConfig(projectPath,resourcePath);
	schemaPath = utils.findConfig(projectPath,resourcePath, "schema");
	
	
</cfscript>


<cfif not FileExists(configPath)>

	<cfscript>
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notanapplication";
		messagesURL = baseURL  & messagesPath & messagesOptions;
	
	</cfscript>
	
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<cfscript>
	configXML = xmlParse(FileRead(configPath));
	configXML.config.OverwriteDataModel.XMLText = TRUE;
	FileWrite(configPath, configXML);
</cfscript>

<cf_ideWrapper messageURL="#handlerURL#?datasourcePath=#schemaPath#" />
