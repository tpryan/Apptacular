<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>

<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editConfig/editconfig.cfm" />
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
	
	<cfheader name="Content-Type" value="text/xml">
	<cfoutput> 
	<response showresponse="true">
		<ide url="#messagesURL#" > 
			<dialog width="655" height="600" />
		</ide> 
	</response>
	
	</cfoutput>
	<cfabort> 
</cfif>

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#handlerURL#?configPath=#configPath#" > 
		<dialog width="655" height="600" /> 
	</ide> 
</response> 
</cfoutput>
