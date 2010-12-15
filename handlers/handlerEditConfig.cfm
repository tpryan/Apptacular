<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>

<cfif left(form.ideeventInfo, 1) neq "<">
    <cfset form.ideeventInfo = URLDecode(form.ideeventInfo) />
</cfif>


<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editConfig/editconfig.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath />

<cfscript>
	utils = New cfc.utils.utils();
	cgiUtils = New cfc.utils.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	resourcePath = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
	configPath = utils.findConfig(projectPath,resourcePath);
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

<cf_ideWrapper messageURL="#handlerURL#?configPath=#configPath#&amp;ideeventInfo=#UrlEncodedFormat(form.ideeventInfo)#" /> 
