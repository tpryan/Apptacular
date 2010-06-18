<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>

<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "purge/showlist.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cfscript>
	utils = New cfc.utils();
	XMLDoc = xmlParse(ideeventInfo);
	
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	resourcePath = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
	configPath = utils.findConfig(projectPath,resourcePath);
</cfscript>

<cfif not FileExists(configPath)>

	<cfscript>
		baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notanapplication";
		messagesURL = baseURL  & messagesPath & messagesOptions;
	
	</cfscript>
	
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<cfset appRoot = utils.findAppRoot(projectPath,resourcePath) />

<cf_ideWrapper messageURL="#handlerURL#?appRoot=#appRoot#" />
