
<cfscript>
	handlerPath = getDirectoryFromPath(cgi.script_name) & "createProject/login.cfm";
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.eventinfo.XMLAttributes.projectlocation;
	
	handlerURL = "http://" & cgi.server_name & handlerPath;
</cfscript>


<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#handlerURL#?projectPath=#projectPath#" > 
		<dialog width="655" height="600" /> 
	</ide> 
</response> 
</cfoutput>

